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
        Erxes.setup(erxesApiUrl: "https://erxes.priuscenter.mn/gateway", brandId: "wEcdSa")
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
          button.backgroundColor = .green
          button.setTitle("Test Button", for: .normal)
          button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

          self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonAction(sender: UIButton!) {
        Erxes.start()
    }
}

