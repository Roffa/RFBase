//
//  LSBaseView.swift
//  LSBase
//
//  Created by zrf on 2021/6/21.
//

import UIKit
import RxSwift

//MARK: 给view实现信号源传递能力
open class LSBaseView: UIView, LSBaseRxProtocol {
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
