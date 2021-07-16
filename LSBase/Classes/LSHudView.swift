//
//  LSHudView.swift
//  LSBase
//
//  Created by zrf on 2021/6/22.
//

import Foundation
//MARK: 基于MBProgressHUD Swift版封装集成，已适配Swift5
//demo: LSHudView.succ(image:UIImage(named: "Checkmark"))  //自定义加载成功弹框
open class LSHudView: UIView{
    public enum LSHudViewOrientation {
        case center  //弹框居中显示
        case bottom  //弹框底部显示
    }
    /**
     @brief 配置文字颜色样式
     */
    public static var textColor: UIColor?
    /**
     @brief 显示loading view
     @param view 父视图，默认为window
     @param text loading时文字信息
     @return 返回hud
     @discussion 当view上已存在hud正在显示，调用方法将返回正在显示的hud，新hud显示失败。 避免hud叠加显示异常
     */
    @discardableResult
    public class func loading(_ view: UIView = UIApplication.shared.windows.last!, text: String? = nil) -> UIView{
        if let h = HKProgressHUD.hudForView(view){ //当本地已存在弹框，新弹框显示失败
            return h
        }
        let hud = HKProgressHUD.show(addedToView: view, animated: true)
        if let text = text {
            hud.label?.text = text
        }
        //延时0.2秒，避免在viewdidload中加载时window被UITransitionView覆盖
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            // your function here
            view.bringSubviewToFront(hud)
        }
        if let color = self.textColor {
            hud.label?.textColor = color
        }
        return hud
    }
    /**
     @brief 隐藏hud
     @param hudView  hudView本身|父视图|nil
     @note 当传入参数为hudview时， 直接隐藏。否则从父视图查找或者从默认视图查找
     */
    public class func hide(_ hudView: UIView? = nil){
        if let view = hudView{
            if let hud = view as? HKProgressHUD {
                hud.hide(animated: true)
            }else{
                let hud = HKProgressHUD.hudForView(view)
                hud?.hide(animated: true)
            }
        }else{
            let view = UIApplication.shared.windows.last!
            let hud = HKProgressHUD.hudForView(view)
            hud?.hide(animated: true)
        }
        
    }
    /**
     @brief 更改Hud文字信息
     @param view 对外抛出的hudView
     @param text 需要显示的新文字信息
     @author rf/2021-07-08
     */
    public class func updateText(_ view: UIView, text: String){
        guard let hud = view as? HKProgressHUD  else {
            fatalError(#file + ".传入的view必须为hudView")
        }
        hud.label?.text = text
    }
    /**
     @brief 只显示文字信息弹框
     @param view 父视图，默认为wiondow
     @param text 文字信息
     @param delay 当值>0时，在delay秒后自动消失，默认1.5s  值小于0关闭自动消失
     @author rf/2021-06-21
     @discussion 当view上已存在hud正在显示，调用方法将返回正在显示的hud，新hud显示失败。 避免hud叠加显示异常
     */
    @discardableResult
    public class func text(_ view: UIView = UIApplication.shared.windows.last!, text: String, offset: LSHudViewOrientation = .bottom , delay: TimeInterval = 1.5 )  -> UIView{
        if let h = HKProgressHUD.hudForView(view){ //当本地已存在弹框，新弹框显示失败
            return h
        }
        let hud = HKProgressHUD.show(addedToView: view, animated: true)
        hud.mode = .text
        hud.label?.text = text
        switch offset {
        case .center:
            hud.offset = CGPoint(x: 0, y: 0)
        default:
            hud.offset = CGPoint(x: 0, y: HKProgressHUD.maxOffset)
        }
        if delay > 0 { //自动消失
            hud.hide(animated: true, afterDelay: delay)
        }
        if let color = self.textColor {
            hud.label?.textColor = color
        }
        
        return hud
    }
    /**
     @brief 显示成功hud
     @param image UIImage 当需要自定义图片时，传入
     @param delay 当值>0时，在delay秒后自动消失，默认1.5s  值<0关闭自动消失
     @author rf/2021-06-21
     @discussion 当view上已存在hud正在显示，调用方法将返回正在显示的hud，新hud显示失败。 避免hud叠加显示异常
     */
    @discardableResult
    public class func succ(_ view: UIView = UIApplication.shared.windows.last!, text: String? = nil, image: UIImage? = nil, delay: TimeInterval = 1.5) -> UIView{
        if let h = HKProgressHUD.hudForView(view){ //当本地已存在弹框，新弹框显示失败
            return h
        }
        let hud = HKProgressHUD.show(addedToView: view, animated: true)
        hud.mode = .customView
        if let text = text {
            hud.label?.text = text
        }
        if let i = image {
            hud.customView = UIImageView(image: i)
        }else{
            hud.customView = UIImageView(image: img("ls_hud_succ"))
        }
        if delay > 0 { //自动消失
            hud.hide(animated: true, afterDelay: delay)
        }
        if let color = self.textColor {
            hud.label?.textColor = color
        }
        return hud
    }
    /**
     @brief 显示失败hud
     @param image UIImage 当需要自定义图片时，传入
     @param delay 当值>0时，在delay秒后自动消失，默认1.5s  值小于0关闭自动消失
     @author rf/2021-06-21
     @discussion 当view上已存在hud正在显示，调用方法将返回正在显示的hud，新hud显示失败。 避免hud叠加显示异常
     */
    @discardableResult
    public class func fail(_ view: UIView = UIApplication.shared.windows.last!, text: String? = nil, image: UIImage? = nil, delay: TimeInterval = 1.5) -> UIView{
        if let h = HKProgressHUD.hudForView(view){ //当本地已存在弹框，新弹框显示失败
            return h
        }
        let hud = HKProgressHUD.show(addedToView: view, animated: true)
        hud.mode = .customView
        if let text = text {
            hud.label?.text = text
        }
        if let i = image {
            hud.customView = UIImageView(image: i)
        }else{
            hud.customView = UIImageView(image: img("ls_hud_fail"))
        }
        if delay > 0 { //自动消失
            hud.hide(animated: true, afterDelay: delay)
        }
        if let color = self.textColor {
            hud.label?.textColor = color
        }
        return hud
    }
    /**
     @brief 组件内图片使用
     */
    public class func img(_ name: String) -> UIImage?{
        let frameworkBundle = Bundle(for: self)
//  未使用xcassets读取图片
//        let imgPath = frameworkBundle.path(forResource: name, ofType: "png")
//        let img = UIImage(contentsOfFile: imgPath ?? "")
        let img = UIImage(named: name, in: frameworkBundle, compatibleWith: nil)
        return img ?? nil
    }
}
