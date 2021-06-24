//
//  ViewModel.swift
//  LSBase_Example
//
//  Created by zrf on 2021/6/16.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import LSBase

class ViewModel:LSBaseViewModel {
    override init() {
        super.init()

        method1()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            method2()
        }
        
    }
    
    func method1() -> Void {
        lsNext("123")
    }
    func method2() -> Void {
        lsNext("456")
    }
}
