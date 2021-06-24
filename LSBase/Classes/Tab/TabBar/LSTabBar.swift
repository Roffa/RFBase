//
//  STTabBar.swift
//  ScanTools
//
//  Created by 古月木四点 on 2020/12/2.
//

import Foundation
import SnapKit

protocol LSTabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect idex: Int)
}

class LSTabBar: UITabBar {
    var bCenter = false        //是否显示中心按钮
    var centerImg: UIImage?     //中心按钮图片
    var tabBarButtons = [LSTabBarButton]()
    var newDelegate: LSTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var centerBtn: UIButton = {
        let centerBtn = UIButton()
        centerBtn.addTarget(self, action: #selector(cententBtnAction), for: .touchUpInside)
        if let img = centerImg {
            centerBtn.setImage(img, for: .normal)
        }
        
        centerBtn.setTitleColor(.gray, for: .normal)
        centerBtn.layer.cornerRadius = 35
        centerBtn.backgroundColor = .white
        return centerBtn
    }()
}

extension LSTabBar {
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
//        super.setItems(items, animated: animated)
        
        if tabBarButtons.count == 0 && items!.count > 0{
            addCustomTabBarBtns(items)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension LSTabBar {

    private func addCustomTabBarBtns(_ items: [UITabBarItem]?) {
        
        let barShadowView = UIView()
        barShadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        barShadowView.layer.shadowOffset = CGSize(width: 0, height: -1.5)
        barShadowView.layer.shadowRadius = 3;
        barShadowView.layer.shadowOpacity = 1;
        barShadowView.backgroundColor = .white
        self.addSubview(barShadowView)
        barShadowView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(1)
            make.height.equalTo(2)
        }
        
        let contentV = UIView()
        self.addSubview(contentV)
        
        var safeBottom: CGFloat = 0
        if #available(iOS 11.0, *),
           let window = UIApplication.shared.windows.last {
            safeBottom = window.safeAreaInsets.bottom
           
        }
        contentV.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(1)
            make.bottom.equalTo(-safeBottom)
        }
        contentV.backgroundColor = .white
        
//        MARK: 中心按钮处理
        if bCenter {  //当需要显示中心视图
            contentV.addSubview(centerBtn)
            centerBtn.snp.makeConstraints { (make) in
                make.bottom.equalTo(0)
                make.centerX.equalTo(contentV)
                make.width.height.equalTo(70)
            }
            let btnshadowView = UIView()
            btnshadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            btnshadowView.layer.shadowOffset = CGSize(width: 0, height: -1.5)
            btnshadowView.layer.shadowRadius = 3;
            btnshadowView.layer.shadowOpacity = 1;
            btnshadowView.layer.cornerRadius = 35;
            btnshadowView.backgroundColor = .white
            self.insertSubview(btnshadowView, belowSubview: contentV)
            btnshadowView.snp.makeConstraints { (make) in
                make.center.equalTo(centerBtn)
                make.height.width.equalTo(70)
            }
        }
        
        createTabbarButton(items, contentV: contentV)
        
        self.tabBarDidSelectBtn(tabBarButtons[0])
    }
    func createTabbarButton(_ items: [UITabBarItem]?, contentV: UIView){
        for i in 0..<items!.count {
            let btn = LSTabBarButton(items![i].title, items![i].image, items![i].selectedImage)
            contentV.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.bottom.top.equalTo(0)
                if bCenter {  //显示中心按钮
                    if items!.count == 2 {  //tabbar带中心视图总共3个
                        if i==0 {
                            make.left.equalTo(0)
                            make.right.equalTo(centerBtn.snp.left)
                        }else {
                            make.right.equalTo(0)
                            make.left.equalTo(centerBtn.snp.right)
                        }
                    }else{ //tabbar带中心视图总共5个
                        if i == 0 {
                            make.left.equalTo(0)
                        }else if i == 1{
                            make.left.equalTo(tabBarButtons.last!.snp.right)
                            make.right.equalTo(centerBtn.snp.left)
                        }else if i == 2{
                            make.left.equalTo(centerBtn.snp.right)
                        }else {
                            make.right.equalTo(0)
                            make.left.equalTo(tabBarButtons.last!.snp.right)
                        }
                    }
                }else{
                    if i == 0 {
                        make.left.equalTo(0)
                    }else if i == items!.count-1{
                        make.right.equalTo(0)
                        make.left.equalTo(tabBarButtons.last!.snp.right)
                        make.width.equalTo(tabBarButtons.last!.snp.width)
                    }else {
                        make.left.equalTo(tabBarButtons.last!.snp.right)
                        make.width.equalTo(tabBarButtons.last!.snp.width)
                    }
                }
            }
            btn.tag = i;
            btn.addTarget(self, action: #selector(tabBarDidSelectBtn(_:)), for: .touchUpInside)
            
            tabBarButtons.append(btn)
        }
    }
    @objc func cententBtnAction() {
        newDelegate?.tabBar(self, didSelect: -1)
    }
    
    @objc func tabBarDidSelectBtn(_ btn: LSTabBarButton) {
        newDelegate?.tabBar(self, didSelect: btn.tag)
        
        for button in tabBarButtons {
            button.isSelected = button == btn
        }
    }
}

// fix:jira IOS-242 拍摄按钮的上半部分，点击存在穿透
extension LSTabBar {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard !self.isHidden, view == nil else {
            return view
        }
        if bCenter, self.centerBtn.frame.contains(point) {
            return self.centerBtn
        }
        return view
    }
}
