//  
//  AuthtenticationServiceProtocol.swift
//  Erxes iOS SDK
//

import Foundation

protocol AuthtenticationServiceProtocol {

    func authenticate(type:String,value:String,success: @escaping(_ data: Scalar_JSON) -> (), failure: @escaping(_ errorClosure: String) -> ())

}

