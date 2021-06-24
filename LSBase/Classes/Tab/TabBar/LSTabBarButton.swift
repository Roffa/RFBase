//
//  STTabBarButton.swift
//  ScanTools
//
//  Created by 古月木四点 on 2020/12/3.
//

import Foundation

class LSTabBarButton: UIControl {
    
    var image: UIImage?
    var selectedImage: UIImage?
    var title: String?
    
    let titleLabel = UILabel()
    let imageView = UIImageView()
    
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? UIColor(red: 65.0/255.0, green: 127.0/255, blue: 248.0/255, alpha: 1) : UIColor(red: 192/255.0, green: 195.0/255, blue: 198.0/255, alpha: 1)
            imageView.image = isSelected ? selectedImage : image
        }
    }
    
    init(_ title: String?, _ image: UIImage?, _ selectedImage: UIImage?) {
        super.init(frame: .zero)
        
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            if title == nil {  //无文字，图片居中显示
                make.centerY.equalToSuperview()
            }else{
                make.top.equalTo(6)
            }
            
        }
        imageView.image = image
        
        self.addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.textColor = UIColor(red: 65.0/255.0, green: 127.0/255, blue: 248.0/255, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 10)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            if image == nil {  //无图片， 文字居中显示
                make.centerY.equalToSuperview()
            }else{
                make.top.equalTo(imageView.snp.bottom).offset(5)
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
