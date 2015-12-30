//
//  UIArrowView.swift
//  UITest
//
//  Created by MiloDu on 15/12/29.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class UIArrowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let pointStart = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.2)
        let pointEnd = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.8)
        let pointLeft = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * 0.6)
        let pointRight = CGPointMake(self.frame.size.width * 0.7, self.frame.size.height * 0.6)
        let path = UIBezierPath()
        path.moveToPoint(pointStart)
        path.addLineToPoint(pointEnd)
        
        path.moveToPoint(pointLeft)
        path.addLineToPoint(CGPointMake(pointEnd.x + 0.9, pointEnd.y))
        
        path.moveToPoint(pointRight)
        path.addLineToPoint(CGPointMake(pointEnd.x - 0.9, pointEnd.y))
        
        UIColor.lightGrayColor().set()
        path.lineWidth = 2
        path.lineJoinStyle = CGLineJoin.Round
        path.stroke()
    }
}
