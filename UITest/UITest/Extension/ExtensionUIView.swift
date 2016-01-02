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
    
    
    static func imageCornerWithColor(color: UIColor, size: CGSize, cornerRadius: CGFloat)-> UIImage{
//        let rect = CGRectMake(0, 0, size.width, size.height)
//        
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
//        path.addClip()
//        color.set()
//        path.stroke()
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
        return imageHollowWithColor(color, size: size, cornerRadius: cornerRadius, lineWidth: 0)
    }

    static func imageHollowWithColor(color: UIColor, size: CGSize, cornerRadius: CGFloat, lineWidth: CGFloat)-> UIImage{
        let rect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        color.set()
        path.addClip()
        if lineWidth > 0{
            path.lineWidth = lineWidth
            path.stroke()
        }else{
            path.fill()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
