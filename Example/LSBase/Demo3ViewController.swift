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
    private lazy var tableViewHepler: LSTableViewHelper = {
        let hepler = LSTableViewHelper()
        hepler.dataSource = [CLTitleCellItem(text: "测试数据1"), CLTitleCellItem(text: "测试数据11"), CLTitleCellItem(text: "测试数据111"), CLTitleCellItem(text: "测试数据1111")]
        return hepler
    }()
    var row = 20
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "3"
        // Do any additional setup after loading the view.
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        view.backgroundColor = .red
        tableView.dataSource = tableViewHepler
        tableView.delegate = tableViewHepler
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
        
        tableViewHepler.cellForRow { cell, item, indexPath in
            let model: CLTitleCellItem = item as! CLTitleCellItem
//            cell.textLabel?.text = "更改数据\(model.title)"
        }.selectRow { item, indexPath in
            print("点了第\(indexPath.row+1)行")
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
class CLTitleCellItem: NSObject {
    private (set) var title: String = ""
    var accessoryType: UITableViewCell.AccessoryType = .none
    var didSelectCellCallback: ((IndexPath) -> ())?
    init(text: String) {
        self.title = text
    }
}
extension CLTitleCellItem: LSCellItemProtocol {
    func bindCell() -> UITableViewCell.Type {
        return CLTitleCell.self
    }
    func cellHeight() -> CGFloat {
        return 80
    }
}

//MARK: - JmoVxia---类-属性
class CLTitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - JmoVxia---布局
private extension CLTitleCell {
    func initUI() {
        selectionStyle = .none
    }
    func makeConstraints() {
    }
}
extension CLTitleCell: LSCellProtocol {
    func ls_setItem(_ item: LSCellItemProtocol) {
        guard let item = item as? CLTitleCellItem else { return }
        textLabel?.text = item.title
        accessoryType = item.accessoryType
    }
}
