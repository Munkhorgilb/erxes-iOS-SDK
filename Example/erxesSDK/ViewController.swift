//
//  ViewController.swift
//  erxesSDK
//
//  Created by Munkh-orgil on 12/14/2023.
//  Copyright (c) 2023 Munkh-orgil. All rights reserved.
//

import UIKit
import erxesSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        Erxes.setup(erxesApiUrl: "https://office.erxes.io/gateway", brandId: "tBdZg4")
//        Erxes.setup(erxesApiUrl: "https://office.erxes.io/gateway", brandId: "HGjG2_")
          Erxes.setup(erxesApiUrl: "https://erxes.priuscenter.mn/gateway", brandId: "wEcdSa")
//        Erxes.setup(erxesApiUrl: "https://orgil.app.erxes.io", organizationName: "orgil", brandId: "7-rCr1")
        
        let button = UIButton(type:  .system)
        button.backgroundColor = UIColor(hexString: "#5629B6")
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        button.setTitle("Show Erxes Widget", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let text = "Show Erxes Widget"
        let font = button.titleLabel?.font ?? UIFont.systemFont(ofSize: 17)
        let textWidth = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
        button.frame = CGRect(x: 0, y: 0, width: textWidth + 20, height: 60)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonAction(sender: UIButton!) {
        Erxes.start()
    }
}

