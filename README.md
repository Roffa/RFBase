# LSBase

[![CI Status](https://img.shields.io/travis/zrf/LSBase.svg?style=flat)](https://travis-ci.org/zrf/LSBase)
[![Version](https://img.shields.io/cocoapods/v/LSBase.svg?style=flat)](https://cocoapods.org/pods/LSBase)
[![License](https://img.shields.io/cocoapods/l/LSBase.svg?style=flat)](https://cocoapods.org/pods/LSBase)
[![Platform](https://img.shields.io/cocoapods/p/LSBase.svg?style=flat)](https://cocoapods.org/pods/LSBase)
> LSBase组件不依托具体业务，定义相关BaseView系列类与方法。区别于LSTools、LSUIKit

## 功能概述
+ 基于RX的消息传递封装
+ 遵循MVVM模式的BaseViewController
+ 空页面显示文字与按钮
+ HUD 封装，支持loading/fail/succ，以及动态修改hud文字信息
+ 自定义UINavigationBar
+ 自定义UITabbarController
+ 延时方法封装
+ 无循环引用的定时器
+ 下拉刷新、上拉加载更多
+ UITableView数据源便捷工具

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
#### 基于rx的消息传递 LSBaseRxProtocol demo
LSBaseViewMode/LSBaseView自动遵循LSBaseRxProtocol，每个class有自己独立的subject信号源
同时，LSBaseRxProtocol协议有一套默认的信号源，该信号源定义为全局信号源，使用时可以根据需求选择直接使用全局信号源完成消息传递
```
//ViewModel中发起消息
func method1() -> Void {
    lsNext("123")  //发送123消息
}
//ViewController中订阅消息
var viewModel: LSBaseViewModel = ViewModel()
viewModel.lsSubscrible({ value in
    print("2订阅的消息为：\(value)")  //接收到123
})
```
#### 基于MBProgressHUD Swift版LSHudView demo
![加载中](https://upload-images.jianshu.io/upload_images/9129568-7b2a242d5c995ae5.png?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)
![成功](https://upload-images.jianshu.io/upload_images/9129568-c8923a26719e00d6.png?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)
```
//如遇如下情况，多个hud在同一时间被调用，内部自动拦截后面的hud显示，如下场景只会显示第一个hud'加载中'
let hud = LSHudView.loading(text:"加载中")    //加载中，隐藏时调用 LSHudView.hide(hud)
LSHudView.text(text: "底部弹框")    //默认1.5秒后自动消失
LSHudView.succ(image:UIImage(named: "Checkmark"))  //成功
LSHudView.fail()
LSHudView.updateText(hud, text:"加载完成")  //更改hud信息
```

#### LSEmptyView demo
![空页面1](https://upload-images.jianshu.io/upload_images/9129568-66da7ea5bf27c43b.png?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)

![空页面2](https://upload-images.jianshu.io/upload_images/9129568-6c4a490c3e86fd80.png?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)
```
//利用全局消息源订阅空页面点击响应
LSEmptyView.titleColor = UIColor(red: 0.6, green: 0.1, blue: 0.8, alpha: 1)
LSEmptyView.show(self.view, title: "请求超时，点击重试")
lsSubscrible({ value in
    if let name = value as? String, name == EmptySubscribleName.title{
        print("接收到全局信号源事件,超时重试响应：\(value)")
    }
})
```
#### LSTabBarController/LSNavBarView demo
继承LSTabBarController
```
//重载下列方法可以监听点击与中心按钮配置
override func ls_tabBar(_ tabBar: UITabBar, didSelect idex: Int)  {
    print("点了、\(idex)")
    if idex != -1 {
        self.selectedIndex = idex
    }else {
        
    }
}

override func isShowCenter() -> Bool {
    return true
}
override func setCenterImage() -> UIImage?{
    return LSHudView.img("ls_back_black")
}

//下列方法快速封装，显示时根据每个item的title/normalImg配置不同，自动兼容
let child1 = TabbarChild()
child1.vc = Demo1ViewController()
//        child1.normalImg = LSHudView.img("ls_back_black")
child1.selectImg = LSHudView.img("ls_back_black")
child1.title = "226"
let child2 = TabbarChild()
child2.vc = Demo1ViewController()
child2.normalImg = LSHudView.img("ls_back_black")
child2.selectImg = LSHudView.img("ls_back_black")
child2.title = "456"
self.vcArray = [child1, child2]

//导航器自定义
let navView = LSNavBarView()
navView.addLeftBarItem(LSHudView.img("ls_back_black")) //
let imgv = UIImageView(frame: CGRect(origin: CGPoint(x: 40, y: 0), size: CGSize(width: 44, height: 44)))
imgv.backgroundColor = .red
navView.addRightBarItem(imgv, space: -10)
navView.title = "标题"
```
 #### LSTimer定时器、延时执行
 需要将LSTimer定义为属性
 ```
 LSTimer.delay(4) {
     print("延时了4秒执行")
 }
 //不会造成循环引用问题，生命周期跟随调用类
 var timer: LSTimer? = LSTimer()
 timer?.schedule(1, callback: {
     print("每次调用了")
 })
 timer!.cancel()  //手动取消
 ```
 
 #### LSRefreshView下拉刷新
 ```
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
```

#### LSTableViewHelper
```
private lazy var tableViewHepler: LSTableViewHelper = {
    let hepler = LSTableViewHelper()
    hepler.dataSource = [CLTitleCellItem(text: "测试数据1"), CLTitleCellItem(text: "测试数据11"), CLTitleCellItem(text: "测试数据111"), CLTitleCellItem(text: "测试数据1111")]
    return hepler
}()
tableView.dataSource = tableViewHepler
tableView.delegate = tableViewHepler

tableViewHepler.cellForRow { cell, item, indexPath in
    let model: CLTitleCellItem = item as! CLTitleCellItem
//            cell.textLabel?.text = "更改数据\(model.title)"
}.selectRow { item, indexPath in
    print("点了第\(indexPath.row+1)行")
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
```


## 更新记录
### 0.2.0(2021-07-21)
增加下拉刷新类LSRefreshView
增加TableView数据源便捷工具LSTableViewHelper

### 0.1.6(2021-07-08)
LSHudView增加`updateText`方法，达到动态更改HUD文案信息

### 0.1.5(2021-07-08)
优化LSHudView, 避免HKProgressHud直接对外使用. 将原各方法返回的HKProgressHud改为UIView
优化LSHudView.hide方法，传参支持hudView与父视图，使用更加便捷


## Requirements

## Installation

LSBase is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LSBase'
```

## Author

zrf, zhourongfeng@021.com

## License

LSBase is available under the MIT license. See the LICENSE file for more info.
