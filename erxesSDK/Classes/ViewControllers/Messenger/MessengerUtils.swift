//
//  MessengerUtils.swift
//  Erxes iOS SDK
//

import Foundation

extension MessengerView {
    
    func isNewMessage(id: String) -> Bool {
        let temp = self.messages.filter { $0._id == id }
        if temp.count != 0 {
            return false
        } else {
            return true
        }
    }
    
}
