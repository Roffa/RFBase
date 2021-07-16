//
//  Demo2ViewController.swift
//  LSBase_Example
//
//  Created by zrf on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class Demo2ViewController: UIViewController {
    var timer: LSTimer? = LSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "2"
        LSTimer.delay(4) {
            print("延时了4秒执行")
        }
        // Do any additional setup after loading the view.
       
    }
    override func viewWillAppear(_ animated: Bool) {
        timer?.schedule(1, callback: {
            print("每次调用了")
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer!.cancel()
        
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
