//
//  TableViewController.swift
//  LSBase_Example
//
//  Created by zrf on 2021/6/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LSBase

class TableViewController: LSTabBarController {
    override func ls_tabBar(_ tabBar: UITabBar, didSelect idex: Int)  {
        print("点了、\(idex)")
        if idex != -1 {
            self.selectedIndex = idex
        }else {
            
        }
    }
    
//    override func isShowCenter() -> Bool {
//        return true
//    }
    override func setCenterImage() -> UIImage?{
        return LSHudView.img("ls_back_black")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let child1 = TabbarChild()
        child1.vc = UINavigationController(rootViewController: Demo1ViewController())
//        child1.normalImg = LSHudView.img("ls_back_black")
        child1.selectImg = LSHudView.img("ls_back_black")
        child1.title = "226"
        
        let child2 = TabbarChild()
        child2.vc = UINavigationController(rootViewController:Demo2ViewController())
        child2.normalImg = LSHudView.img("ls_hud_fail")
        child2.selectImg = LSHudView.img("ls_back_black")
        child2.title = "456"
        
        let child3 = TabbarChild()
        child3.vc = UINavigationController(rootViewController:Demo3ViewController())
        child3.normalImg = LSHudView.img("ls_hud_fail")
        child3.selectImg = LSHudView.img("ls_back_black")
        child3.title = "789"
        self.vcArray = [child1, child2, child3]
    }

    
}
