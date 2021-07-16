//
//  LSEmptyView.swift
//  LSBase
//
//  Created by zrf on 2021/6/22.
//
//MARK: 空白页封装
import Foundation
import RxSwift
import SnapKit

public struct EmptySubscribleName {
    public static let title = "emptyView_titleBtnSubject"  //点击页面文字信息发出的信号信息
    public static let done = "emptyView_doneBtnSubject"  //点击页面按钮发出的信号信息
}

open class LSEmptyView: UIView, LSBaseRxProtocol{
    public static var titleFont: UIFont = UIFont.systemFont(ofSize: 14)  //内容文字大小
    public static var titleColor: UIColor = UIColor(red: 213.0/255.0, green: 213.0/255.0, blue: 213.0/255.0, alpha: 1)  //内容文字颜色
    
    public static var imgTop: CGFloat = -50    //图片顶部距离中心的距离
    public static var space: CGFloat = 30    //图片与文字间距离
    
    public static var doneFont: UIFont = UIFont.systemFont(ofSize: 14)  //按钮文字大小
    public static var doneColor: UIColor = .white  //按钮文字颜色
    public static var doneBgColor: UIColor = UIColor(red: 65.0/255.0, green: 127.0/255.0, blue: 249.0/255.0, alpha: 1)  //按钮背景颜色
    public static var doneHeight = 32   //按钮高度
    
    //图片
    fileprivate lazy var imgBtn: UIButton = {
        let imageBtn = UIButton(type: .custom)
        imageBtn.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        imageBtn.contentMode = .scaleAspectFit
        return imageBtn
    }()

    //文字
    fileprivate lazy var titleBtn: UIButton = {
        let imageBtn = UIButton(type: .custom)
        imageBtn.titleLabel?.font = LSEmptyView.titleFont
        imageBtn.titleLabel?.textAlignment = .center
        imageBtn.setTitleColor(LSEmptyView.titleColor, for: .normal)
        imageBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping //设置换行
        imageBtn.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        return imageBtn
    }()
    //按键
    fileprivate lazy var doneBtn: UIButton = {
        let imageBtn = UIButton(type: .system)
        imageBtn.layer.cornerRadius = 5
        imageBtn.layer.masksToBounds = true
        imageBtn.backgroundColor = LSEmptyView.doneBgColor
        imageBtn.titleLabel?.font = LSEmptyView.doneFont
        imageBtn.titleLabel?.textAlignment = .center
        imageBtn.setTitleColor(LSEmptyView.doneColor, for: .normal)
        imageBtn.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        
        return imageBtn
    }()
    /**
     @brief 初始化
     @param view 父视图
     @param img 图片
     @param text  按钮内容，默认无按钮
     */
    convenience init(_ view: UIView, img: UIImage? = nil, title: String, text: String? = nil){
        self.init(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: view.frame.size))
        backgroundColor = .clear
        
        titleBtn.setTitle(title, for: .normal)
 
        var image: UIImage?
        if img != nil {
            image = img
        }else{
            image = LSHudView.img("ls_empty")
        }
        imgBtn.setImage(image, for: .normal)
        imgBtn.setImage(image, for: .highlighted)
        let maxValue = max(max(image?.size.height ?? 0, image?.size.width ?? 0), 100)
        addSubview(titleBtn)
        addSubview(imgBtn)
        
        imgBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(LSEmptyView.imgTop)
            make.size.equalTo(maxValue)
        }
        titleBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgBtn.snp.bottom).offset(LSEmptyView.space)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        if let txt = text {
            addSubview(doneBtn)
            doneBtn.setTitle(txt, for: .normal)
            let width = txt.boundingRect(with:CGSize(width: 0, height: Self.doneHeight), options:[.usesFontLeading, .usesDeviceMetrics], attributes: [NSAttributedString.Key.font: Self.doneFont], context: nil).size.width
            doneBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleBtn.snp.bottom).offset(LSEmptyView.space)
                make.width.equalTo(width+30)
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
                make.height.equalTo(Self.doneHeight)
            }
        }
    }
    @objc fileprivate func btnClicked(_ sender: UIButton){
        if sender == titleBtn ||
            sender == imgBtn{
            lsNext(EmptySubscribleName.title)
        }else if sender == doneBtn{
            lsNext(EmptySubscribleName.done)
        }
    }
}
public extension LSEmptyView {
    
    @discardableResult
    class func show(_ view: UIView, img: UIImage? = nil, title: String, text: String? = nil)->LSEmptyView {
        hide(fromView: view)
        let backV = LSEmptyView(view, img: img, title: title, text: text)
        backV.tag = 777
        view.addSubview(backV)
        return backV
    }
    
    class func hide(fromView view: UIView) {
        let blackView = view.viewWithTag(777)
        if let blackV = blackView {
            blackV.removeFromSuperview()
        }
    }
}


//private var emptyViewKey = "emptyViewKey"
//extension UIView {
//    public  var emptyView: LSEmptyView? {
//        get {
//            return objc_getAssociatedObject(self, &emptyViewKey) as? LSEmptyView
//        }
//        set {
//            let view: LSEmptyView = newValue!
//            objc_setAssociatedObject(self, &emptyViewKey, view, .OBJC_ASSOCIATION_ASSIGN)
//            LSEmptyView.hide(fromView: self)
//            addSubview(view)
//            bringSubviewToFront(view)
//        }
//    }
//}
