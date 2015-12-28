//
//  DMChartBarView.swift
//  UITest
//
//  Created by Milo on 15/12/28.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMChartBarView: DMChartAxesView {
    
    private var _layerBar : CAShapeLayer!
    private var _arrayLayerText = Array<CATextLayer>()
    var colorBarBackground = UIColor.lightGrayColor()
    var colorBar = UIColor.greenColor()
    var maxBarWidth : CGFloat = 80      //最大的Bar宽度
    var marginBar : CGFloat = 4         //Bar之间的宽度/2
    var showBackground = false
    var showText = true
    var showAnimation = true
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if(showBackground){
            drawBarBackground()
        }
        drawBar()
    }
    
    private func drawBarBackground(){
        let path = createPath(true)
        colorBarBackground.set()
        path.stroke()
    }

    private func drawBar(){
        if(_layerBar == nil){
            _layerBar = CAShapeLayer()
            self.layer.addSublayer(_layerBar)
        }
        let path = createPath(false)
        _layerBar.strokeColor = colorBar.CGColor
        _layerBar.path = path.CGPath
        if(!showAnimation){
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            _layerBar.lineWidth = path.lineWidth
            CATransaction.commit()
        }else{
            _layerBar.lineWidth = path.lineWidth
            _layerBar.addAnimation(self.createAnimation(), forKey: DMAnimationUtils.kAnimStroekEnd)
        }
    }
    
    private func drawText(width : CGFloat){
//        for i in 0 ..< arrayData
//        let layerText : CATextLayer!
//        if(index < _arrayLayerText.count){
//            layerText = _arrayLayerText[index]
//        }else{
//            layerText = CATextLayer()
//            self.layer.addSublayer(layerText)
//            _arrayLayerText.append(layerText)
//            
//            layerText.fontSize = 12
//            layerText.contentsScale = UIScreen.mainScreen().scale
//            layerText.alignmentMode = kCAAlignmentCenter
//            layerText.foregroundColor = colorBar.CGColor
//        }
//        layerText.frame = CGRectMake(self.arrayPoint[index].x - width * 0.5, self.arrayPoint[index].y - 20, width, 20)
//        layerText.string = String(self.arrayData[index].value / self.valueMax)
    }
    
    private func createPath(isBackground : Bool) -> UIBezierPath {
        let path = UIBezierPath()
        let startY = self.bottomY
        let width = max(1 ,min(self.maxBarWidth, self.intervalX - self.marginBar * 2))
        for i in 0 ..< self.arrayData.count {
            path.moveToPoint(CGPointMake(self.arrayPoint[i].x, startY))
            if(isBackground){
                path.addLineToPoint(CGPointMake(self.arrayPoint[i].x, startY - self.heightChart))
            }else{
                path.addLineToPoint(self.arrayPoint[i])
            }
        }
        path.lineWidth = width
        
        if(showText){
            drawText(width)
        }
        return path
    }
    
    private func createAnimation() -> CABasicAnimation{
        return DMAnimationUtils.createAnimStrokeEnd(1)
    }
}
