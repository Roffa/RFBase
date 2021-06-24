//
//  Demo1ViewController.swift
//  LSBase_Example
//
//  Created by zrf on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LSBase


class Demo1ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "1"
        // Do any additional setup after loading the view.
        let navView = LSNavBarView()
        navView.addLeftBarItem(LSHudView.img("ls_back_black")) //
        let imgv = UIImageView(frame: CGRect(origin: CGPoint(x: 40, y: 0), size: CGSize(width: 44, height: 44)))
        imgv.backgroundColor = .red
        navView.addRightBarItem(imgv, space: -10)
        navView.title = "标题"
//        navView.titleColor = .gray
//        navView.titleFont = UIFont.systemFont(ofSize: 15)
//        LSNavBarView.setBarItemAttributes(navView.leftBarItem!, attr: [.font : UIFont.systemFont(ofSize: 15), .foregroundColor : UIColor.white])
//        navView.backgroundColor = .purple
        view.addSubview(navView)
        
    }

    @IBAction func btnClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(Demo2ViewController(), animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
