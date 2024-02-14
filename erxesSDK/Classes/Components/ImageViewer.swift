//
//  ImageViewer.swift
//  erxesiosdk
//

import UIKit
import SDWebImage

class ImageViewer: UIView {
    
    var closeButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage.erxes(with: .cancel, textColor: UIColor(hexString: uiOptions?.color ?? defaultColorCode)!, size: CGSize(width: 25, height: 25), backgroundColor: .clear), for: .normal)
        button.addTarget(ImageViewer.self, action: #selector(closeAction), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)?.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .white
        
        return button
    }()
    
    var imageView: UIImageView = {
     let imageview = UIImageView()
        imageview.backgroundColor = .black
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    convenience init(attachmentUrl:String) {
        self.init(frame: .zero)
        didLoad()
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        imageView.sd_setImage(with: URL(string: attachmentUrl.readFile()))
    }
    
    func didLoad() {
        self.addSubview(imageView)
        self.addSubview(closeButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(50)
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(40)
        }
    }
    
    @objc func closeAction(){
        
        self.removeFromSuperview()
    }

}
