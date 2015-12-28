//
//  DMCacheUtils.swift
//  UITest
//
//  Created by MiloDu on 15/12/28.
//  Copyright © 2015年 Milo. All rights reserved.
//

import Foundation

class DMCacheUtils: NSObject {
    
    static func cacheFromArray<T>(array: Array<T>!, count : Int,reuse: (object: T!, index: Int)->Void){
        var maxCount = count
        if(array != nil){
            maxCount = max(array.count, count)
        }
        for i in 0 ..< maxCount {
            var object : T! = nil
            if(array != nil && array.count > i){
                object = array[i]
            }
            reuse(object: object, index: i)
        }
    }
}
