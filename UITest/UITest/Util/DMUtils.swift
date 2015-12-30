//
//  DMUtils.swift
//  UITest
//
//  Created by MiloDu on 15/12/26.
//  Copyright © 2015年 Milo. All rights reserved.
//

import Foundation

class DMUtils: NSObject {

    static func base64Encode(str: String) -> String!{
        // 将字符串进行UTF8编码成NSData
        let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        // 将NSData进行base64编码
        let base64Str = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64Str
    }
    
    static func base64Decode(str: String) -> String!{
        // 将base64字符串转换成NSData
        let data = NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions(rawValue: 0))
        // 对NSData数据进行UTF8解码
        let str = String(data: data!, encoding: NSUTF8StringEncoding)
        return str
    }
}
