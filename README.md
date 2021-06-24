# LSBase

[![CI Status](https://img.shields.io/travis/zrf/LSBase.svg?style=flat)](https://travis-ci.org/zrf/LSBase)
[![Version](https://img.shields.io/cocoapods/v/LSBase.svg?style=flat)](https://cocoapods.org/pods/LSBase)
[![License](https://img.shields.io/cocoapods/l/LSBase.svg?style=flat)](https://cocoapods.org/pods/LSBase)
[![Platform](https://img.shields.io/cocoapods/p/LSBase.svg?style=flat)](https://cocoapods.org/pods/LSBase)

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
