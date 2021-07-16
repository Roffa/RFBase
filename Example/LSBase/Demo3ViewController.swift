//
//  Demo3ViewController.swift
//  LSBase_Example
//
//  Created by zrf on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

extension LSHudView{
    static func text(text:String){
        LSHudView.textColor = .blue
        LSHudView.text(text: text, offset:.center)
    }
}

class Demo3ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "3"
        // Do any additional setup after loading the view.
        tableView.ls_header = LSRefreshView.header()
    }

    override func viewDidAppear(_ animated: Bool) {
        LSHudView.text(text: "弹框")
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
