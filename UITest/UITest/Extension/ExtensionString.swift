//
//  ExtensionString.swift
//  UITest
//
//  Created by Milo on 15/12/29.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit
extension String {

    func toMD5() -> String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestLen)
        return String (format: hash as String)
    }
    
    func toBase64Encode() -> String!{
        // 将字符串进行UTF8编码成NSData
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        // 将NSData进行base64编码
        let base64Str = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64Str
    }
    
    func toBase64Decode() -> String!{
        // 将base64字符串转换成NSData
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        // 对NSData数据进行UTF8解码
        let str = String(data: data!, encoding: NSUTF8StringEncoding)
        return str
    }

}
