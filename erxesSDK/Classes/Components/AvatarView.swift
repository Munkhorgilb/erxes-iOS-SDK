//
//  AvatarView.swift
//  Erxes iOS SDK
//

import UIKit

class AvatarView: UIImageView {
    
  

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
   

}
