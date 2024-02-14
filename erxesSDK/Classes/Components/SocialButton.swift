//
//  SocialButton.swift
//  Erxes iOS SDK
//

import UIKit

class SocialButton: UIButton {

    var params: Dictionary<String, Any>
    
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
    }
}
