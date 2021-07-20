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

    var row = 20
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "3"
        // Do any additional setup after loading the view.
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        view.backgroundColor = .red
        tableView.dataSource = self
        tableView.ls_header = LSRefreshView.header().idle {
            print("刷新恢复初始状态")
        }.drag {
            print("正在下拉")
        }.refresh {
            print("刷新中")
            LSTimer.delay(3) { [weak self] in
                print("执行了")
                self?.row = 20
                self?.tableView.endRefresh()
            }
            
        }
        tableView.ls_footer = LSRefreshView.footer(texts:[.idle:"上拉加载", .drag:"松手更新"]).refresh {
            print("刷新中")
            LSTimer.delay(3) { [weak self] in
                print("执行了")
                self?.tableView.footerEndRefresh()
                self?.row += 10
                self?.tableView.reloadData()
            }
            
        }
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
extension Demo3ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return row
    }
    
}
