//
//  DMChartLineView.swift
//  UITest
//
//  Created by MiloDu on 15/12/28.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMChartLineView: DMChartAxesView {
    private var _layerShape : CAShapeLayer!
    private var _layerPoint : CAShapeLayer!
    var colorLine = UIColor.greenColor()
    var colorPoint = UIColor.yellowColor()
    var showPoint = true
    var showAnimation = true
    
    override func config() {
        super.config()
        if(_layerShape == nil){
            _layerShape = CAShapeLayer()
            _layerShape.backgroundColor = UIColor.clearColor().CGColor
            self.layer.addSublayer(_layerShape)
        }
        if(_layerPoint == nil){
            _layerPoint = CAShapeLayer()
            _layerPoint.backgroundColor = UIColor.clearColor().CGColor
            self.layer.addSublayer(_layerPoint)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        _drawLine()
        print("sublayer = \(self.layer.sublayers?.count)")
    }
    
    private func _drawLine(){
        let path = UIBezierPath()
        let path2 = UIBezierPath()
        for i in 0 ..< self.arrayPoint.count{
            if(i == 0){
                path.moveToPoint(self.arrayPoint[i])
            }else{
                path.addLineToPoint(self.arrayPoint[i])
            }
            if(showPoint){
                path2.moveToPoint(self.arrayPoint[i])
                path2.addArcWithCenter(self.arrayPoint[i], radius: 1.5, startAngle: 0, endAngle: DMPathUtils.PI * 2, clockwise: true)
            }
        }
        _layerShape.path = path.CGPath
        _layerShape.strokeColor = colorLine.CGColor
        _layerShape.lineWidth = 1
        
        if(showPoint){
            _layerPoint.path = path2.CGPath
//            _layerPoint.strokeColor = UIColor.clearColor().CGColor
            _layerPoint.fillColor = UIColor.clearColor().CGColor
            _layerPoint.strokeColor = colorPoint.CGColor
            _layerPoint.lineWidth = 3
        }
        if(showAnimation){
            let anim = DMAnimationUtils.createAnimStrokeEnd(2)
            _layerShape.addAnimation(anim, forKey: DMAnimationUtils.kAnimStroekEnd)
            _layerPoint.addAnimation(anim, forKey: DMAnimationUtils.kAnimStroekEnd)
        }
    }
}
