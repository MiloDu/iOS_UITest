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
            _drawBarBackground()
        }
        _drawBar()
    }
    
    private func _drawBarBackground(){
        let path = _createPath(true)
        colorBarBackground.set()
        path.stroke()
    }

    private func _drawBar(){
        if(_layerBar == nil){
            _layerBar = CAShapeLayer()
            self.layer.addSublayer(_layerBar)
        }
        let path = _createPath(false)
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
    
    private func _drawText(width : CGFloat){
        weak var weakself = self
        DMCacheUtils.cacheFromArray(_arrayLayerText, count: arrayData.count) {(var layer, index) -> Void in
            if(index < weakself?.arrayData.count){
                if(layer == nil){
                    layer = CATextLayer()
                    weakself?.layer.addSublayer(layer)
                    weakself?._arrayLayerText.append(layer)
                    
                    layer.fontSize = 12
                    layer.contentsScale = UIScreen.mainScreen().scale
                    layer.alignmentMode = kCAAlignmentCenter
                    layer.foregroundColor = weakself?.colorBar.CGColor
                }else{
                    layer.hidden = false
                }
                layer.frame = CGRectMake( weakself!.arrayPoint[index].x - width * 0.5, weakself!.arrayPoint[index].y - 20, width, 20)
                layer.string = String( weakself!.arrayData[index].value / weakself!.valueMax)
            }else{
                layer.hidden = true
            }
        }
    }
    
    private func _createPath(isBackground : Bool) -> UIBezierPath {
        let path = UIBezierPath()
        let startY = self._bottomY
        let width = max(1 ,min(self.maxBarWidth, self._intervalX - self.marginBar * 2))
        for i in 0 ..< self.arrayData.count {
            path.moveToPoint(CGPointMake(self.arrayPoint[i].x, startY))
            if(isBackground){
                path.addLineToPoint(CGPointMake(self.arrayPoint[i].x, startY - self._heightChart))
            }else{
                path.addLineToPoint(self.arrayPoint[i])
            }
        }
        path.lineWidth = width
        
        if(showText){
            _drawText(width)
        }
        return path
    }
    
    private func createAnimation() -> CABasicAnimation{
        return DMAnimationUtils.createAnimStrokeEnd(1)
    }
}
