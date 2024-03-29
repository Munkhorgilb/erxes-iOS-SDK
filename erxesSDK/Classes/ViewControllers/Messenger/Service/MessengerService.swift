//
//  MessengerService.swift
//  Erxes iOS SDK
//

import Foundation


class MessengerService: MessengerServiceProtocol {

    func conversationDetail(conversationId: String?, success: @escaping (ConversationDetailModel) -> (), failure: @escaping (String) -> ()) {
        let query = WidgetsConversationDetailQuery(_id: conversationId, integrationId: integrationId)
        
        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in

            switch result {
                
            case .success(let graphQLResult):

                if let response = graphQLResult.data?.widgetsConversationDetail?.fragments.conversationDetailModel{
                    
                    success(response)
                }

                if let errors = graphQLResult.errors {

                    let error = errors.compactMap({ $0.localizedDescription }).joined(separator: ", ")
                    failure(error)

                }
            case .failure(let error):
                print(error.localizedDescription, "Error conversationDetail")
                failure(error.localizedDescription)
            }
        }
    }

    func widgetsMessengerSupporters(success: @escaping ([UserModel]) -> (), failure: @escaping (String) -> ()) {
        let query = WidgetsMessengerSupportersQuery(integrationId: integrationId)
        
        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
            
            switch result {
                
            case .success(let graphQLResult):
                
                if let response = graphQLResult.data?.widgetsMessengerSupporters?.supporters?.compactMap({$0?.fragments.userModel}) {
                    success(response)
                }
//                
                if let errors = graphQLResult.errors {
                    
                    let error = errors.compactMap({ $0.localizedDescription }).joined(separator: ", ")
                    failure(error)
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func insertMessage(customerId: String?, visitorId: String?, message: String?, attachments: [AttachmentInput]?, conversationId: String?, contentType:String,success: @escaping (MessageModel) -> (), failure: @escaping (String) -> ()) {
        let mutation = WidgetsInsertMessageMutation(integrationId: integrationId, customerId : customerId, visitorId: visitorId, message: message, contentType: contentType, conversationId: conversationId, attachments: attachments)
        
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                
                if let response = graphQLResult.data?.widgetsInsertMessage?.fragments.messageModel {
                    UserDefaults().set(response.customerId, forKey: "customerId")
                    UserDefaults().synchronize()
                    clearVisitorId()
                    success(response)
                }
                
                if let errors = graphQLResult.errors {
                    
                    let error = errors.compactMap({ $0.localizedDescription }).joined(separator: ", ")
                    failure(error)
                    
                }
            case .failure(let error):
                print(error.localizedDescription, "Error insertMessage")
                failure(error.localizedDescription)
            }
        }
    }

    
    func readConversation(conversationId: String, success: @escaping (Scalar_JSON) -> (), failure: @escaping (String) -> ()) {
        let mutation = WidgetsReadConversationMessagesMutation(conversationId: conversationId)
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
    
                if let response = graphQLResult.data?.widgetsReadConversationMessages {
                    
                    success(response)
                }
                
                if let errors = graphQLResult.errors {
                    
                    let error = errors.compactMap({ $0.localizedDescription }).joined(separator: ", ")
                    failure(error)
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
}
