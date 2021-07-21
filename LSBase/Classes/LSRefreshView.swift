//
//  LSRefreshView.swift
//  LSBase
//
//  Created by zrf on 2021/7/15.
//

import Foundation

open class LSRefreshView: UIView{
    public fileprivate(set) var label: UILabel?
    public fileprivate(set) var customView: UIView?  //需要自定义视图时，使用它,与label互斥
    
    /**
     下拉/上拉刷新当前状态
     idle: 初始状态
     drag: 正在下拉/上拉
     refresh: 正在刷新
     */
    public enum RefreshMode{
        case idle, drag, refresh
    }
    public var mode: RefreshMode = .idle{//当前模式
        didSet {
            switch mode {
            case .idle:
                label?.text = idleStr
                if let callback = idleCallback {
                    callback()
                }
            case .drag:
                label?.text = dragStr
                if let callback = dragCallback {
                    callback()
                }
            case .refresh:
                label?.text = refreshStr
                if let callback = refreshCallback {
                    callback()
                }
            }
        }
    }
    public private(set) var idleStr = "下拉刷新"
    public private(set) var dragStr = "松开刷新"
    public private(set) var refreshStr = "正在刷新"
    
    private var idleCallback: (()->Void)?
    private var dragCallback: (()->Void)?
    private var refreshCallback: (()->Void)?
}
//MARK: 回调
extension LSRefreshView{
    @discardableResult
    public func idle(_ closure: @escaping ()->Void) -> Self {
        idleCallback = closure
        return self
    }
    @discardableResult
    public func drag(_ closure: @escaping ()->Void) -> Self {
        dragCallback = closure
        return self
    }
    @discardableResult
    public func refresh(_ closure: @escaping ()->Void) -> Self {
        refreshCallback = closure
        return self
    }
}
//MARK: header
extension LSRefreshView{
    /// header
    /// - Parameters:
    ///   - customView: 自定义下拉更新。
    ///   - texts: 下拉更新过程中各类文案信息
    ///   - Notes: customView与texts互斥. 传参时不要同时使用
    /// - Returns: 下拉更新视图
    public static func header(_ customView: UIView? = nil, texts:[RefreshMode:String]? = nil) -> LSRefreshView{
        let refreshView = LSRefreshView(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.width, height: 64))
        if let v = customView {
            refreshView.addSubview(v)
            refreshView.frame.size.height = v.frame.size.height
            refreshView.frame.origin.y = -refreshView.frame.size.height
            refreshView.customView = v
        }else{
            if refreshView.label == nil {
                refreshView.label = UILabel(frame: refreshView.bounds)
                refreshView.label?.textAlignment = .center
                refreshView.label?.textColor = .gray
                refreshView.addSubview(refreshView.label!)
                refreshView.label!.numberOfLines = 0
                refreshView.label!.font = UIFont.systemFont(ofSize: 14)
            }
        }
        if let dict = texts {
            if let idle = dict[.idle] {
                refreshView.idleStr = idle
            }
            if let idle = dict[.drag] {
                refreshView.dragStr = idle
            }
            if let idle = dict[.refresh] {
                refreshView.refreshStr = idle
            }
        }
        return refreshView
    }
    /// footer
    /// - Parameters:
    ///   - customView: 自定义下拉更新。
    ///   - texts: 下拉更新过程中各类文案信息
    ///   - Notes: customView与texts互斥. 传参时不要同时使用
    /// - Returns: 下拉更新视图
    public static func footer(_ customView: UIView? = nil, texts:[RefreshMode:String]? = nil) -> LSRefreshView{
        let refreshView = LSRefreshView(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.width, height: 64))
        if let v = customView {
            refreshView.addSubview(v)
            refreshView.frame.size.height = v.frame.size.height
            refreshView.frame.origin.y = -refreshView.frame.size.height
            refreshView.customView = v
        }else{
            if refreshView.label == nil {
                refreshView.label = UILabel(frame: refreshView.bounds)
                refreshView.label?.textAlignment = .center
                refreshView.label?.textColor = .gray
                refreshView.addSubview(refreshView.label!)
                refreshView.label!.numberOfLines = 0
                refreshView.label!.font = UIFont.systemFont(ofSize: 14)
            }
        }
        if let dict = texts {
            if let idle = dict[.idle] {
                refreshView.idleStr = idle
            }
            if let idle = dict[.drag] {
                refreshView.dragStr = idle
            }
            if let idle = dict[.refresh] {
                refreshView.refreshStr = idle
            }
        }
        return refreshView
    }
}

extension UIScrollView{
    fileprivate struct AssociatedKeys {
        static var ls_header: String = "ls_header"
        static var ls_footer: String = "ls_footer"
    }
    
    
    public var ls_header: LSRefreshView?{
        get { objc_getAssociatedObject(self, &AssociatedKeys.ls_header) as? LSRefreshView }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ls_header, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == nil {
                removeObserver(self, forKeyPath: "contentOffset")
                return
            }
            addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)  //增加tableView监听
            
            if let view = ls_header { //上一个视图从父视图删除
                view.removeFromSuperview()
            }
            addSubview(newValue!)
            
        }
    }
    public var ls_footer: LSRefreshView?{
        get { objc_getAssociatedObject(self, &AssociatedKeys.ls_footer) as? LSRefreshView }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ls_footer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == nil {
                removeObserver(self, forKeyPath: "contentOffset")
                removeObserver(self, forKeyPath: "contentSize")
                return
            }
            addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: &AssociatedKeys.ls_footer)  //增加tableView监听
            addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: &AssociatedKeys.ls_footer)  //增加tableView监听
            
            if let view = ls_footer { //上一个视图从父视图删除
                view.removeFromSuperview()
            }
            addSubview(newValue!)
            
            newValue?.backgroundColor = .purple
        }
        
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        let tableView = object as! UIScrollView
//        print("isTracking=\(isTracking),isDragging=\(isDragging), isDecelerating=\(isDecelerating), y=\(contentOffset.y)")
//        print("path=\(keyPath),contentSize=\(contentSize.height), contentInset=\(contentInset)")
        
        if keyPath! == "contentSize" {
            if contentSize.height < frame.height {
                ls_footer!.frame.origin.y = frame.height
            }else{
                ls_footer!.frame.origin.y = contentSize.height
            }
        }else{
            if ls_header?.mode == .refresh || ls_footer?.mode == .refresh { return }
            if isTracking, isDragging {  //手指正在滑动
                if let header = ls_header {
                    if contentOffset.y < -header.frame.height*0.9  {  //滑动距离大于一定像素
                        header.mode = .drag
                    }else if contentOffset.y > -header.frame.height*0.8  {
                        header.mode = .idle
                    }
                }
                if let footer = ls_footer {
                    let oft = contentOffset.y + frame.height
                    if oft  > footer.frame.origin.y + footer.frame.height*0.9  {  //滑动距离大于一定像素
                        footer.mode = .drag
                    }else if oft < footer.frame.origin.y + footer.frame.height*0.8  {
                        footer.mode = .idle
                    }
                }
            }else if isDecelerating{  //手指放开
                if let header = ls_header {
                    if contentOffset.y > -header.frame.height*0.8 {
                        header.mode = .idle
                    }else{
                        //下拉结束，回弹到一定位置，手指松开时,判定为开始下拉刷新
                        if contentOffset.y > -header.frame.height*1.1 {
                            beginRefresh()
                        }
                    }
                }
                if let footer = ls_footer {
                    let oft = contentOffset.y + frame.height
                    if oft < footer.frame.origin.y + footer.frame.height*0.8 {
                        footer.mode = .idle
                    }else{
                        //下拉结束，回弹到一定位置，手指松开时,判定为开始下拉刷新
                        if oft < footer.frame.origin.y + footer.frame.height*1.1 {
                            footerBeginRefresh()
                        }
                    }
                }
            }
        }
        
        
    }
    public func beginRefresh(){
    
        ls_header?.mode = .refresh
        if contentInset == .zero {
            contentInset = UIEdgeInsets(top: ls_header!.frame.height, left: 0, bottom: 0, right: 0)
        }
        
    }
    public func endRefresh(){
        if contentInset == .zero { return }
        UIView.animate(withDuration: 0.3) { [self] in
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }completion: { [self] bFinish in
            ls_header?.mode = .idle
        }
        
    }
//    MARK: - footer
    public func footerBeginRefresh(){
        ls_footer?.mode = .refresh
        if contentInset == .zero {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom:   ls_footer!.frame.height, right: 0)
        }
        
    }
    public func footerEndRefresh(){
        if contentInset == .zero { return }
        UIView.animate(withDuration: 0.3) { [self] in
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }completion: { [self] bFinish in
            ls_footer?.mode = .idle
        }
        
    }
}
