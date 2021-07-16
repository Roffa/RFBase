//
//  ViewController.swift
//  LSBase
//
//  Created by zrf on 06/16/2021.
//  Copyright (c) 2021 zrf. All rights reserved.
//

import UIKit
@_exported import LSBase  //全局导入，其他类无需再次import

class ViewController:UIViewController, LSBaseVCProtocol, LSBaseRxProtocol {
    lazy var viewModel: LSBaseViewModel = ViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel.lsSubscrible({ value in
            print("接收到ViewModel事件：\(value)")
        })
        
//        let view = LSHudView.loading(text:"加载中")   //loading
//        let view = LSHudView.text(self.view, text:"文字弹框", offset: .center) //纯文字弹框
//        let view = LSHudView.succ(text:"加载成功")
//        DispatchQueue.global(qos: .userInitiated).async {
//            // Do something useful in the background and update the hud periodically.
//            sleep(5)
//            DispatchQueue.main.async {
//                LSHudView.hide(view)
//            }
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //如3个hud同时显示，将只显示第一个
//        LSHudView.text(text: "底部弹框")
        LSHudView.succ(image:UIImage(named: "Checkmark"))
        LSHudView.fail()
        
//        LSEmptyView.show(self.view, title: "亲，您尚未登录账号,亲，您尚未登录账号,亲，您尚未登录账号,亲，登录账号", text:"登录/注册")
        lsSubscrible({ value in
            if let name = value as? String, name == EmptySubscribleName.title{
                print("接收到全局信号源事件,超时重试响应：\(value)")
            }else if let name = value as? String, name == EmptySubscribleName.done{
                print("接收到全局信号源事件,按钮响应：\(value)")
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnClicked(_ sender: UIButton) {
        self.present(Demo3ViewController(), animated: true, completion: nil)
    }
}

