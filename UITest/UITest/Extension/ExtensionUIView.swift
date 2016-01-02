//
//  ExtensionUIView.swift
//  UITest
//
//  Created by MiloDu on 15/12/27.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

extension UIView {
    var originX : CGFloat{
        return self.frame.origin.x
    }
    
    var originY : CGFloat {
        return self.frame.origin.y
    }
    
    var width :  CGFloat{
        return self.frame.size.width
    }
    
    var height : CGFloat{
        return self.frame.size.height
    }
    
    static func imageWithColor(color: UIColor)-> UIImage{
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
