//
//  UIDollarView.swift
//  UITest
//
//  Created by MiloDu on 15/12/29.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class UIDollarView: UIView {
    var color = UIColor.lightGrayColor()
    var layerShape : CAShapeLayer!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        layerShape = CAShapeLayer()
        self.layer.addSublayer(layerShape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = DMPathUtils.createPathDollar(self.bounds)
        layerShape.path = path.CGPath
        layerShape.lineWidth = 2
        layerShape.strokeColor = color.CGColor
        layerShape.fillColor = UIColor.clearColor().CGColor
    }
    
    func setStrokeEnd(end : CGFloat){
        self.layerShape.strokeEnd = end
    }
    
    func addAnimationRotate(){
        let anim = CABasicAnimation(keyPath: "transform.rotate.y")
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 2
        anim.repeatCount = HUGE
        layerShape.addAnimation(anim, forKey: "rotateY")
    }
}
