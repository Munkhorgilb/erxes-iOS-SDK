//
//  Erxes.swift
//  erxesiosdk
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

var lang = "en"
var API_URL = "http://localhost:3300"
let screenSize = UIScreen.main.bounds
let SCREEN_WIDTH = screenSize.width
let SCREEN_HEIGHT = screenSize.height

var customerId: String!
var visitorId: String!
var brandCode: String!
var integrationId: String!
var formCode: String!

var customerEmail = ""
var customerPhoneNumber = ""
var customerCode = ""
var customData: Scalar_JSON = [:]
var companyCustomData: Scalar_JSON = [:]
var isUser = false
let defaultColorCode = "#EEEEEE"

var isSaas = false

var sender = UIView()

var messengerData: MessengerData?
var leadData: LeadData?
var uiOptions: UIOptions?
var brand: BrandModel?

func clearVisitorId() {
    visitorId = nil
}

@objc public class Erxes: NSObject {
    static func storeEmail(value: String) {
        customerEmail = value
        UserDefaults().set(customerEmail, forKey: "email")
        UserDefaults().synchronize()
    }

    static func storePhoneNumber(value: String) {
        customerPhoneNumber = value
        UserDefaults().set(customerPhoneNumber, forKey: "phone")
        UserDefaults().synchronize()
    }

    static func storeCustomerId(value: String) {
        customerId = value
        UserDefaults().set(value, forKey: "customerId")
        UserDefaults().synchronize()
    }

    static func storeIntegrationId(value: String) {
        integrationId = value
        UserDefaults().set(value, forKey: "integrationId")
        UserDefaults().synchronize()
    }

    static func storeThemeColor(hex: String) {
        UserDefaults().set(hex, forKey: "themeColor")
        UserDefaults().synchronize()
    }

    static func getVisitorId() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }

    static func restore() {
        let defaults = UserDefaults()
        if let email = defaults.string(forKey: "email") {
            customerEmail = email
        }

        if let phone = defaults.string(forKey: "phone") {
            customerPhoneNumber = phone
        }
        if let integrationid = defaults.string(forKey: "integrationId") {
            integrationId = integrationid
        }

        if let customerid = defaults.string(forKey: "customerId") {
            customerId = customerid
        } else {
            visitorId = getVisitorId()
        }
    }

    @objc public static func setup(erxesApiUrl: String? = nil, organizationName: String? = nil, brandId: String, email: String? = nil, phone: String? = nil, code: String? = nil, data: String? = nil, companyData: String? = nil) {
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses.append(MessengerView.self)

        restore()
        brandCode = brandId

        API_URL = erxesApiUrl ?? ""

        if let subdomain = organizationName {
            isSaas = true
            API_URL = "https://\(subdomain).app.erxes.io/api"
        }

        if (API_URL.last == "/") {
            API_URL = String(API_URL.dropLast())
        }

        ErxesClient.shared.setupClient(apiUrlString: API_URL)

        let mutation = ConnectMutation(brandCode: brandCode)

        if ((email) != nil) {
            customerEmail = email!
        }

        if ((phone) != nil) {
            customerPhoneNumber = phone!
        }

        if ((code) != nil) {
            customerCode = code!
        }

        if let jsonString = data {
            let jsonData = Data(jsonString.utf8)

            do {
                // make sure this JSON is in the format we expect
                customData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] ?? [:]
                

            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        if let jsonCompanyString = companyData {
            let jsonData = Data(jsonCompanyString.utf8)
            
            do {
                // make sure this JSON is in the format we expect
                companyCustomData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] ?? [:]
                
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }

        if ((email != nil && email!.count > 0) || (phone != nil && phone!.count > 0) || (code != nil && code!.count > 0)) {
            isUser = true
        }

        connect(mutation: mutation)
    }

    @objc public static func setSender(view: UIView) {
        sender = view
    }


    @objc public static func prepare(parent: UIViewController, senderView: UIView) {
        sender = senderView
        if (integrationId != nil) || (customerId != nil) {

            let mutation = ConnectMutation(brandCode: brandCode, cachedCustomerId: customerId, visitorId: visitorId)
            connect(mutation: mutation)
        }
    }


    private static func connect(mutation: ConnectMutation) {
        visitorId = getVisitorId()

        if ((customerId) != nil) {
            visitorId = nil
        }
        
        mutation.isUser = isUser
        mutation.data = customData
        mutation.companyData = companyCustomData
        mutation.email = customerEmail
        mutation.phone = customerPhoneNumber
        mutation.code = customerCode
        mutation.visitorId = visitorId
        mutation.cachedCustomerId = customerId
        
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            switch result {

            case .success(let graphQLResult):
                if let responseModel = graphQLResult.data?.widgetsMessengerConnect?.fragments.connectResponseModel {
                    integrationId = responseModel.integrationId

                    if let customerId = responseModel.customerId {
                        storeCustomerId(value: customerId)
                    }

                    if let messengerDataJson = responseModel.messengerData {
                        do {
                            messengerData = try MessengerData(from: messengerDataJson) { decoder in
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                            }
                            formCode = messengerData?.formCode
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                    if let uiOptionsJson = responseModel.uiOptions {
                        do {
                            uiOptions = try UIOptions(from: uiOptionsJson) { decoder in
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                            }
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                    if let languageCode = responseModel.languageCode {
                        lang = languageCode
                    }
                    brand = responseModel.brand?.fragments.brandModel

                    UserDefaults.standard.setValue(true, forKey: "authenticated")

//                    saveBrowserInfo()
                }
                if let errors = graphQLResult.errors {
                    print("Errors from server: \(errors)")
                    UserDefaults.standard.setValue(false, forKey: "authenticated")
                }
            case .failure(let error):
                UserDefaults.standard.setValue(false, forKey: "authenticated")
                print("Failure! Error: \(error)")
            }
        }
    }

//    @objc private static func saveBrowserInfo() {
//        let browserInfo = ["userAgent": UIDevice.modelName]
//        let mutation = WidgetsSaveBrowserInfoMutation(customerId: customerId, visitorId: getVisitorId(), browserInfo: browserInfo)
//
//        ErxesClient.shared.client.perform(mutation: mutation) { result in
//
//            switch result {
//
//            case .success(let graphQLResult):
//
//                if let response = graphQLResult.data?.widgetsSaveBrowserInfo?.fragments.messageModel {
//
//                    let avatarUrl = response.user?.fragments.userModel.details?.avatar ?? ""
//                    let fullName = response.user?.fragments.userModel.details?.fullName ?? "Operator"
//                    guard let content = response.engageData?.content, content.count != 0 else { return }
//
//                    EngageView.show(avatarUrl, fullName: fullName, text: content)
//
//                }
//
//                if let errors = graphQLResult.errors {
//                    print("Errors from server: \(errors)")
//                }
//            case .failure(let error):
//                print("Failure! Error: \(error)")
//
//            }
//        }
//    }


    @objc public static func start() {
        if integrationId == nil || integrationId.count == 0 {
            let mutation = ConnectMutation(brandCode: brandCode)
            connect(mutation: mutation)
        } else {
            openErxes()
        }
    }

    static func forceBridgeFromObjectiveC(_ value: Any) -> Any {

        switch value {
            case is NSString:
                return value as! String
            case is Bool:
                return value as! Bool
            case is Int:
                return value as! Int
            case is Int64:
                return value as! Int64
            case is Double:
                return value as! Double
            case is NSDictionary:
                return Dictionary(uniqueKeysWithValues: (value as! NSDictionary).map { ($0.key as! AnyHashable, forceBridgeFromObjectiveC($0.value)) })
            case is NSArray:
                return (value as? NSArray).map { forceBridgeFromObjectiveC($0) } as Any
            default:
                return value
            }
    }



    @objc private static func openErxes() {
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            var currentController = topController
            while let presentedViewController = currentController.presentedViewController {
                currentController = presentedViewController
            }

            let navigationController = MainNavigationController()
            navigationController.modalPresentationStyle = .custom
            navigationController.isNavigationBarHidden = true
            if (messengerData?.requireAuth)! {
                if UserDefaults().bool(forKey: "authenticated") {
                    let controller = HomeView()
                    navigationController.viewControllers.insert(controller, at: 0)
                } else {
                    let controller = AuthtenticationView()
                    
                    navigationController.viewControllers.insert(controller, at: 0)
                }
            } else {
                let controller = HomeView()

                navigationController.viewControllers.insert(controller, at: 0)
            }
            currentController.present(navigationController, animated: true, completion: nil)
        }
    }



    @objc public static func endSession(completionHandler: () -> Void = { }) {
        let defaults = UserDefaults()
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "phone")
        defaults.removeObject(forKey: "customerId")
        defaults.removeObject(forKey: "integrationId")
        defaults.removeObject(forKey: "authenticated")
        defaults.synchronize()
        customerEmail = ""
        customerPhoneNumber = ""
        customerId = nil
        integrationId = ""
        IQKeyboardManager.shared.enable = false
        visitorId = getVisitorId()
        completionHandler()
    }



    public static func erxesBundle() -> Bundle {
        let frameworkBundle = Bundle(for: AuthtenticationView.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("erxesSDK.bundle")
        if let bundleURL = bundleURL, let resourceBundle = Bundle(url: bundleURL) {
            return resourceBundle
        } else {
            // Handle the case where bundleURL is nil or resourceBundle is nil
            // You might want to log an error, print a message, or return a default bundle
            fatalError("Unable to locate erxesSDK.bundle")
        }
    }
}
