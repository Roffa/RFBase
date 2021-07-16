//
//  LSRefreshView.swift
//  LSBase
//
//  Created by zrf on 2021/7/15.
//

import Foundation

open class LSRefreshView: UIView{
    public fileprivate(set) var label: UILabel?
    public var customView: UIView?  //需要自定义视图时，使用它,与label互斥
    
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
            case .drag:
                label?.text = dragStr
            case .refresh:
                label?.text = refreshStr
            }
        }
    }
    public private(set) var idleStr = "下拉刷新"
    public private(set) var dragStr = "松开刷新"
    public private(set) var refreshStr = "正在刷新"
    
}

extension LSRefreshView{
    public static func header(_ customView: UIView? = nil) -> LSRefreshView{
        let refreshView = LSRefreshView(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.width, height: 64))
        if let v = customView {
            refreshView.addSubview(v)
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
        refreshView.backgroundColor = .purple
        return refreshView
    }
    
}

extension UIScrollView{
    static var b = true
    fileprivate struct AssociatedKeys {
        static var ls_header: String = "ls_header"
    }
    
    public var ls_header: LSRefreshView?{
        get { objc_getAssociatedObject(self, &AssociatedKeys.ls_header) as? LSRefreshView }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ls_header, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)  //增加tableView监听
            
            if let view = ls_header { //上一个视图从父视图删除
                view.removeFromSuperview()
            }
            addSubview(newValue!)
            
        }
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        let tableView = object as! UIScrollView
        print("isTracking=\(isTracking),isDragging=\(isDragging), isDecelerating=\(isDecelerating), y=\(contentOffset.y)")
        if isTracking, isDragging {  //手指正在滑动
            if contentOffset.y < -60  {  //滑动距离大于60像素
                ls_header?.mode = .drag
            }else if contentOffset.y > -50 {
                ls_header?.mode = .idle
            }
        }else if isDecelerating{  //手指放开
            if contentOffset.y > -50 {
                ls_header?.mode = .idle
            }else{
                //下拉距离超过60像素，手指松开时,判定为开始下拉刷新
                if contentOffset.y > -75 {
                    beginRefresh()
                }
            }
        }

    }
    public func beginRefresh(){
        if UIScrollView.b {
            UIScrollView.b = false
            LSTimer.delay(3) {
                print("执行了")
                UIScrollView.b = true
                self.endRefresh()
            }
        }
        
        ls_header?.mode = .refresh
        if contentInset == .zero {
            contentInset = UIEdgeInsets(top: 65, left: 0, bottom: 0, right: 0)
        }
        
    }
    public func endRefresh(){
        ls_header?.label?.text = ls_header?.idleStr
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
