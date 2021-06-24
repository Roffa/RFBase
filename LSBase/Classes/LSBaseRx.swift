//
//  LSBaseRx.swift
//  LSBase
//
//  Created by zrf on 2021/6/21.
//  处理mvvm模式下，消息的传递。所有跨class进行消息传递的现象都应该遵循LSBaseRxProtocol，通过lsNext/lsSubscrible进行消息的发送与监听

import Foundation
import RxSwift

//MARK: 全局信号源, 勿与局部信号源混合使用。使用全局信号源时应避免消息重名
public struct rx {
    static var subject: PublishSubject<Any> = PublishSubject()
    static var disposeBag: DisposeBag = DisposeBag()
}

public protocol LSBaseRxProtocol {
    func lsNext<T>(_ obj: T)
    func lsSubscrible(_ completion:((Any) -> Void)? )
}

extension LSBaseRxProtocol {
    /**
     @brief 发起消息，供订阅使用
     @param obj 需要给到订阅者的数据模型
     @author rf/2021-06-16
     */
    public func lsNext<T>(_ obj: T){
        return rx.subject.onNext(obj)
    }
    /**
     @brief 订阅消息
     @param completion 消息响应后回调。 通过lsNext发起消息，completion抛出lsNext的obj参数内容
     */
    public func lsSubscrible(_ completion:((Any) -> Void)? = nil){
        rx.subject.subscribe(onNext: {value in
            completion?(value)
        }).disposed(by: rx.disposeBag)
    }
}
