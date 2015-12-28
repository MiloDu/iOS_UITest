//
//  DMChartBarView.swift
//  UITest
//
//  Created by Milo on 15/12/28.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMChartBarView: DMChartAxesView {
    
    private var layerBar : CAShapeLayer!
    var colorBarBackground = UIColor.lightGrayColor()
    var colorBar = UIColor.magentaColor()
    var maxBarWidth : CGFloat = 80      //最大的Bar宽度
    var marginBar : CGFloat = 4         //Bar之间的宽度/2
    var showAnimation = true
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawBarBackground()
        drawBar()
    }
    
    private func drawBarBackground(){
        let path = createPath(true)
        colorBarBackground.set()
        path.stroke()
    }

    private func drawBar(){
        if(layerBar == nil){
            layerBar = CAShapeLayer()
            self.layer.addSublayer(layerBar)
        }
        let path = createPath(false)
        layerBar.strokeColor = colorBar.CGColor
        layerBar.path = path.CGPath
        if(!showAnimation){
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layerBar.lineWidth = path.lineWidth
            CATransaction.commit()
        }else{
            layerBar.lineWidth = path.lineWidth
            layerBar.addAnimation(self.createAnimation(), forKey: DMAnimationUtils.kAnimStroekEnd)
        }
    }
    
    private func createPath(isBackground : Bool) -> UIBezierPath {
        let path = UIBezierPath()
        let startY = self.height - self.marginBottom
        for i in 0 ..< self.arrayData.count {
            let x = self.marginLeft + (CGFloat(i) + 0.5) * self.intervalX + self.marginBar
            path.moveToPoint(CGPointMake(x, startY))
            if(isBackground){
                path.addLineToPoint(CGPointMake(x, startY - self.heightChart))
            }else{
                path.addLineToPoint(CGPointMake(x, startY - self.arrayData[i].value / self.valueMax * self.heightChart))
            }
        }
        let width = max(1 ,min(self.maxBarWidth, self.intervalX - self.marginBar * 2))
        path.lineWidth = width
        return path
    }
    
    private func createAnimation() -> CABasicAnimation{
        return DMAnimationUtils.createAnimStrokeEnd(1)
    }
}
