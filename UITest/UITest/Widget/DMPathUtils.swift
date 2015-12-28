//
//  DMPathUtils.swift
//  UITest
//
//  Created by MiloDu on 15/12/27.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMPathUtils: NSObject {
    static let PI = CGFloat(M_PI)
    static func createPathDollar(border : CGRect) -> UIBezierPath{
        let middle = CGPointMake(border.origin.x + border.size.width * 0.5, border.origin.y + border.size.height * 0.5)
        let center = CGPointMake(middle.x, middle.y - border.size.height * 0.16)
        let center2 = CGPointMake(middle.x, middle.y + border.size.height * 0.16)
        let radius = border.size.height * 0.16
        
        let path = UIBezierPath()
        path.addArcWithCenter(center, radius: radius, startAngle: -0.1 * PI , endAngle: -1.5 * PI, clockwise: false)
        path.addArcWithCenter(center2, radius: radius, startAngle: -0.5 * PI, endAngle: 0.9 * PI, clockwise: true)
        path.moveToPoint(CGPointMake(middle.x, middle.y - border.size.height * 0.4))
        path.addLineToPoint(CGPointMake(middle.x, middle.y + border.size.height * 0.4))
        return path
    }
}
