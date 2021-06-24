//
//  LSBaseVC.swift
//  LSBase
//
//  Created by zrf on 2021/6/16.
//

import Foundation
import RxSwift
//MARK: viewModel自带信号源
open class LSBaseViewModel: NSObject, LSBaseRxProtocol{
    var subject: PublishSubject<Any> = PublishSubject()
    var disposeBag: DisposeBag = DisposeBag()
    /**
     @brief 发起消息，供订阅使用
     @param obj 需要给到订阅者的数据模型
     @author rf/2021-06-16
     */
    public func lsNext<T>(_ obj: T){
        return subject.onNext(obj)
    }
    /**
     @brief 订阅消息
     @param completion 消息响应后回调。 通过lsNext发起消息，completion抛出lsNext的obj参数内容
     */
    public func lsSubscrible(_ completion:((Any) -> Void)? = nil){
        subject.subscribe(onNext: {value in
            completion?(value)
        }).disposed(by: disposeBag)
    }
}

public protocol LSBaseVCProtocol: AnyObject {  //类专属协议
    var viewModel: LSBaseViewModel {get set}  //mvvm框架，必须实现viewModel
    
}

//MARK: 定时器，跟随调用类生命周期
public class LSTimer{
    let disposeBag: DisposeBag = DisposeBag()
    var subscription: Disposable?
    public init(){
        
    }
    //MARK: 定时器封装
    public func schedule(_ second:CGFloat, callback:(()->Void)?){
        subscription = Observable<Int>.interval(DispatchTimeInterval.milliseconds(Int(second*1000)), scheduler: MainScheduler.instance).subscribe(onNext: { (num) in
            if let cb = callback{
                cb()
            }
        })
        //.disposed(by:disposeBag)
    }
    /**
     @brief 默认定时器销毁跟随调用类生命周期，手动调用销毁使用cancel(如调用类生命周期很长的情况需手动销毁)
     @discussion 调用cancel后，定时器被销毁，需要再次执行时，需要再次调用schedule
     */
    public func cancel(){
        subscription?.dispose()
    }
    public class func delay(_ second: TimeInterval, callback:(()->Void)?){
        DispatchQueue.main.asyncAfter(deadline: .now() + second) {
            if let cb = callback{
                cb()
            }
        }
    }
    deinit {
        cancel()
        print("LSTimer定时器销毁")
    }
}


