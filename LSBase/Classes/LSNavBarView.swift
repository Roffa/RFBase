//
//  LSNavBarView.swift
//  LSBase
//
//  Created by zrf on 2021/6/23.
//  自定义导航

import UIKit

public struct NavSubscribleName {
    public static let left = "navView_leftBtnSubject"
    public static let right = "navView_rightBtnSubject"
}

open class LSNavBarView: LSBaseView {
    var safeTop: CGFloat = 0   //安全区域顶部高度
    var navBar: UINavigationBar
    public var navItem: UINavigationItem
    public var leftBarItem: UIBarButtonItem? = nil
    public var rightBarItem: UIBarButtonItem? = nil
    
    public var title: String{
        get {
            navItem.title ?? ""
        } set {
            navItem.title = newValue
        }
    }
    public var titleColor: UIColor?{  //标题颜色设置
        willSet{
            var dict: [NSAttributedString.Key : Any] = navBar.titleTextAttributes ?? [:]
            dict[NSAttributedString.Key.foregroundColor] = newValue
            navBar.titleTextAttributes = dict
        }
    }
    public var titleFont: UIFont?{  //标题颜色设置
        willSet{
            var dict: [NSAttributedString.Key : Any] = navBar.titleTextAttributes ?? [:]
            dict[.font] = newValue
            navBar.titleTextAttributes = dict
        }
    }
    public override init(frame: CGRect = CGRect.zero) {
        var newFrame: CGRect
        if frame == CGRect.zero {
            newFrame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44 ))
        }else{
            newFrame = frame
        }
        if #available(iOS 11.0, *),
           let window = UIApplication.shared.windows.last {
            safeTop = window.safeAreaInsets.top
            newFrame.size.height += safeTop
        }
        
        navBar = UINavigationBar(frame: CGRect(origin:CGPoint(x: 0, y: safeTop) , size: CGSize(width: newFrame.width, height: newFrame.height-safeTop)))
        navItem = UINavigationItem()
        super.init(frame: newFrame)
        setupUI()
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() -> Void {
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        addSubview(navBar)
        
        navBar.pushItem(navItem, animated: true)
    }
    //MARK: 增加左右操作按钮， 支持string、UIimage、uiview(响应事件自己维护)
    public func addLeftBarItem<T>(_ text:T, space: CGFloat = 0){
        let clicked: Selector = #selector(leftBarClicked(_:))
        if let str = text as? String {
            leftBarItem = UIBarButtonItem(title: str, style: UIBarButtonItem.Style.plain, target: self, action:clicked)
        }else if let img = text as? UIImage {
            leftBarItem = UIBarButtonItem(image: img, style: .plain, target: self, action:clicked )
        }else if let view = text as? UIView { //自定义view
            leftBarItem = UIBarButtonItem(customView: view)
        }else{
            fatalError("text只支持String/UIImage/UIView")
        }
        leftBarItem?.tintColor = .black
        // left按钮
        if space != 0 {
            let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            rightSpace.width = space
            navItem.leftBarButtonItems = [rightSpace, leftBarItem!]
            navBar.pushItem(navItem, animated: true)
        }else{
            navItem.setLeftBarButton(leftBarItem, animated: true)
        }
    }
    /**
     @brief 设置右侧按钮
     @param text  String/UIImage/UIView
     @param space 右侧距离右边距偏移
     */
    public func addRightBarItem<T>(_ text:T, space: CGFloat = 0){
        let clicked: Selector = #selector(rightBarClicked(_:))
        if let str = text as? String {
            rightBarItem = UIBarButtonItem(title: str, style: UIBarButtonItem.Style.plain, target: self, action:clicked)
        }else if let img = text as? UIImage {
            rightBarItem = UIBarButtonItem(image: img, style: .plain, target: self, action:clicked )
        }else if let view = text as? UIView { //自定义view
            rightBarItem = UIBarButtonItem(customView: view)
        }else{
            fatalError("text只支持String/UIImage/UIView")
        }
        // right按钮
        if space != 0 {
            let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            rightSpace.width = space
            navItem.rightBarButtonItems = [rightSpace, rightBarItem!]
        }else{
            navItem.rightBarButtonItems = [rightBarItem!]
        }
        
    }
    
    /**
     @brief 设置导航栏左右按钮样式，如文字大小
     @author rf/2021-06-23
     */
    public class func setBarItemAttributes(_ bar: UIBarButtonItem, attr: [NSAttributedString.Key : Any]){
        bar.setTitleTextAttributes(attr, for: .normal)
    }
    /**
     @brief 简单改变左右颜色，包括图片颜色. 也可以直接设置UINavigationBar
     */
    public class func changeBarItemColor(_ bar: UIBarButtonItem, color: UIColor){
        bar.tintColor = color
    }
    @objc func leftBarClicked(_ bar: UIBarButtonItem){
        lsNext(NavSubscribleName.left)
    }
    @objc func rightBarClicked(_ bar: UIBarButtonItem){
        lsNext(NavSubscribleName.right)
    }
}
