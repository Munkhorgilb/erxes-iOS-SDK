//
//  MessengerServiceProtocol.swift
//  Erxes iOS SDK
//

import Foundation

protocol MessengerServiceProtocol {

    func conversationDetail(conversationId: String?, success: @escaping(_ data: ConversationDetailModel) -> (), failure: @escaping(_ errorClosure: String) -> ())
    func widgetsMessengerSupporters(success: @escaping(_ data: [UserModel]) -> (), failure: @escaping(_ errorClosure: String) -> ())

    func insertMessage(customerId: String?, visitorId: String?, message: String?, attachments: [AttachmentInput]?, conversationId: String?, contentType: String, success: @escaping(_ data: MessageModel) -> (), failure: @escaping(_ errorClosure: String) -> ())
   func readConversation(conversationId: String,success: @escaping(_ data: Scalar_JSON) -> (), failure: @escaping(_ errorClosure: String) -> ())
}
