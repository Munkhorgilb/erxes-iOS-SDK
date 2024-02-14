//
//  MoreView.swift
//  erxesiosdk
//

import UIKit
protocol MoreViewDelegate: class  {
    func close()
    func end()
}
class MoreView: UIViewController {
    weak var delegate: MoreViewDelegate?
    
    var endButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.setTitle("End conversation".localized(lang), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(endAction), for: .touchUpInside)
        
        return button
    }()
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.setTitle("Close".localized(lang), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(closeButton)
        self.view.addSubview(endButton)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func closeAction(){
        self.dismiss(animated: true) {
            self.delegate?.close()
        }
        
    }
    
    @objc func endAction(){
        self.dismiss(animated: true) {
            self.delegate?.end()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        
        closeButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        endButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(closeButton.snp.top)
            make.height.equalTo(40)
        }
    }
    

}
