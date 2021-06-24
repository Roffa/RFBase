//
//  STTabBarViewController.swift
//  ScanTools
//
//  Created by 古月木四点 on 2020/12/1.
//
// MARK: 自定义tabbar  支持中心凸起显示/单图片显示/单文字显示
import Foundation

public class TabbarChild: NSObject{ //child viewcontroller info
    public var vc: UIViewController?
    public var normalImg: UIImage?
    public var selectImg: UIImage?
    public var title: String?
}

open class LSTabBarController: UITabBarController, LSTabBarDelegate {
    public var vcArray: [TabbarChild]?  //需要显示的子viewcontroller信息
    {
        didSet{
            setupChildController()
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tabBar = LSTabBar()
        tabBar.bCenter = isShowCenter()
        tabBar.centerImg = setCenterImage()
        tabBar.newDelegate = self
        tabBar.tintColor = .lightGray
        self.setValue(tabBar, forKey: "tabBar")
        
    }
    public func setupChildController(vc: UIViewController, normalImgName: String, selectedImgName: String, title: String) {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: normalImgName)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImgName)
        addChild(vc)
    }
    private func setupChildController() {
        vcArray?.forEach({ child in
            let vc = child.vc
            let normalImg = child.normalImg
            let selectedImg = child.selectImg
            vc!.tabBarItem.title = child.title
            vc!.tabBarItem.image = normalImg
            vc!.tabBarItem.selectedImage = selectedImg
            addChild(vc!)
        })
    }
    
    open override var selectedIndex: Int {
        didSet {
            print("-tabBar-selectedIndex:\(self.selectedIndex)")
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect idex: Int) {
        
   
        ls_tabBar(tabBar, didSelect: idex)
    }
    //MARK: 需子类重载以满足不同功能
    /**
     @brief 点击tabbar后响应， 在子类实现具体方法
     @author rf/2021-06-23
     */
    open func ls_tabBar(_ tabBar: UITabBar, didSelect idex: Int)  {
        
    }
    open func isShowCenter() -> Bool{
         return false
    }
    open func setCenterImage() -> UIImage?{
        return nil
    }
}
