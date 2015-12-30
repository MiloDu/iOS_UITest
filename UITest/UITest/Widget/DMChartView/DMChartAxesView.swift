//
//  DMChart.swift
//  UITest
//
//  Created by Milo on 15/12/28.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMChartAxesView: DMChartView {
    //用于缓存UILabel
    private var _arrayXLabel = Array<UILabelWithPadding>()
    private var _arrayYLabel = Array<UILabelWithPadding>()
    
    internal var _widthChart : CGFloat = 0
    internal var _heightChart : CGFloat = 0
    internal var _intervalX : CGFloat = 0
    internal var _intervalY : CGFloat = 0
    internal var _bottomY : CGFloat = 0          //图表底部坐标，位于X轴label之上
    internal var _countY : Int = 0               //根据valueMax和valueInterval计算
    
    var arrayPoint = Array<CGPoint>()
    
    var colorXAxes = UIColor.grayColor()
    var colorYAxes = UIColor.grayColor()
    
    var marginLeft : CGFloat = 40           //Y轴上label的 width
    var marginBottom : CGFloat = 20         //X轴上label的 height
    var marginTop : CGFloat = 10            //Y轴上最上边label到箭头的距离
    var marginRight : CGFloat = 10          //X轴上最右边label到箭头的距离
    
    var marginBetweenXLabel : CGFloat = 2   //X轴上label之间的距离
    //X轴上的label回调，允许定制
    var labelForXAxes : ((label: UILabel, index : Int)->Void)?
    //Y轴上的label回调，允许定制
    var labelForYAxes : ((label: UILabel, index : Int, isMax : Bool)->Void)?
    
    var isJustDivider : Bool{
        return self.valueMax % self.valueInterval == 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func config(){
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        print("drawRect")
        compute()
        
        drawAxes()
        
        drawXLabel()
        
        drawYLabel()
    }
    
    private func compute(){
        //图表的有效宽度和高度
        self._widthChart = self.width - self.marginLeft - self.marginRight
        self._heightChart = self.height - self.marginBottom - self.marginTop
        self._bottomY = self.height - self.marginBottom
        //Y轴数量
        let countF = valueMax / valueInterval
        self._countY = Int(ceil(countF))
        //像素间隔
        if(arrayData.count > 0){
            self._intervalX = _widthChart / CGFloat(arrayData.count)
        }
        self._intervalY = self._heightChart / countF
        //数据点
        arrayPoint.removeAll()
        for i in 0 ..< arrayData.count{
            let x = self.marginLeft + (CGFloat(i) + 0.5) * self._intervalX
            let y = self._bottomY - (self.arrayData[i].value / self.valueMax) * self._heightChart
            arrayPoint.append(CGPointMake(x, y))
        }
    }
    
    private func drawAxes(){
        let arrowLength : CGFloat = 4
        let pathAxes = UIBezierPath()
        let startX = marginLeft
        let startY = self._bottomY + 0.5 // +0.5是为了防止被Bar覆盖
        let endX = self.width - 1
        let endY : CGFloat = 1
        let origin = CGPointMake(startX, startY)
        //X Axes
        pathAxes.moveToPoint(origin)
        pathAxes.addLineToPoint(CGPointMake(endX, startY))
        //X Arrow
        pathAxes.moveToPoint(CGPointMake(endX - arrowLength, startY - arrowLength))
        pathAxes.addLineToPoint(CGPointMake(endX, startY))
        pathAxes.moveToPoint(CGPointMake(endX - arrowLength, startY + arrowLength))
        pathAxes.addLineToPoint(CGPointMake(endX, startY))
        //X draw
        colorXAxes.set()
        pathAxes.lineWidth = 1
        pathAxes.stroke()
        
        //Y Axes
        pathAxes.moveToPoint(CGPointMake(startX, startY + 0.5))
        pathAxes.addLineToPoint(CGPointMake(startX, endY))
        //Y Arrow
        pathAxes.moveToPoint(CGPointMake(startX - arrowLength, endY + arrowLength))
        pathAxes.addLineToPoint(CGPointMake(startX, endY))
        pathAxes.moveToPoint(CGPointMake(startX + arrowLength, endY + arrowLength))
        pathAxes.addLineToPoint(CGPointMake(startX, endY))
        //Y draw
        colorYAxes.set()
        pathAxes.lineWidth = 1
        pathAxes.stroke()
        
        //Y flag
        for i in 1 ..< self._countY + 1{
            let y = startY - CGFloat(i) * self._intervalY
            pathAxes.moveToPoint(CGPointMake(startX, y))
            pathAxes.addLineToPoint(CGPointMake(startX + 2, y))
        }
        pathAxes.stroke()
    }
    
//    private func drawXLabel(){
//        if(arrayXString.count <= 0){
//            for view in _arrayXLabel{
//                view.hidden = true
//            }
//            return
//        }
//        
//        let labelWidth = self._widthChart / CGFloat(arrayXString.count)
//        let maxCount = max(_arrayXLabel.count, arrayXString.count)
//        for i in 0 ..< maxCount {
//            if(i < arrayXString.count){
//                var label : UILabelWithPadding!
//                let frame = CGRectMake(CGFloat(i) * labelWidth + self.marginLeft, self._bottomY, labelWidth, self.marginBottom)
//                if(_arrayXLabel.count <= i){
//                    label = UILabelWithPadding(frame: frame)
//                    self.addSubview(label)
//                    _arrayXLabel.append(label)
//                    label.textColor = UIColor.grayColor()
//                    label.font = UIFont.systemFontOfSize(12)
//                    label.textAlignment = NSTextAlignment.Center
//                }else{
//                    label = _arrayXLabel[i]
//                    label.frame = frame
//                    label.hidden = false
//                }
//                label.tag = 1000 + i
//                label.text = String(i)
////                label.backgroundColor = UIColor.blackColor()
//                self.labelForXAxes?(label: label, index: i)
//            }else{
//                _arrayXLabel[i].hidden = true
//            }
//        }
//    }
//    private func drawYLabel(){
//        if(valueMax <= 0){
//            for view in _arrayYLabel{
//                view.hidden = true
//            }
//            return
//        }
//        
//        //使用缓存机制
//        let maxCount = max(self._arrayYLabel.count, self._countY + 1)
//        for i in 0 ..< maxCount {
//            if(i < self._countY + 1){
//                var label : UILabelWithPadding!
//                var frame = CGRectMake(0, self._bottomY - 10 - CGFloat(i) * self._intervalY, self.marginLeft, 20)
//                //不能整除时，该值为true
//                let singleMax = (i == self._countY && !isJustDivider)
//                if (singleMax){
//                    frame.origin.y = self.marginTop
//                    print("add max")
//                }else if(i == 0){
//                    frame.origin.y -= 6
//                }
//                if(_arrayYLabel.count <= i){
//                    //创建新的label
//                    print("Add y = \(i)")
//                    label = createYLabel(frame)
//                    self.addSubview(label)
//                    _arrayYLabel.append(label)
//                } else {
//                    //使用缓存中的label
//                    label = _arrayYLabel[i]
//                    label.frame = frame
//                    label.hidden = false
//                    print("reuse y = \(i)")
//                }
//                label.tag = 2000 + i
//                if(!singleMax){
//                    label.text = String(CGFloat(i) * self.valueInterval)
//                }else{
//                    label.text = String(CGFloat(valueMax))
//                }
//                self.labelForYAxes?(label: label, index: i, isMax : isJustDivider)
//            } else {
//                //隐藏缓存中多余的label
//                _arrayYLabel[i].hidden = true
//            }
//        }
//    }
    
    private func drawXLabel(){
        if(arrayXString.count <= 0){
            for view in _arrayXLabel{
                view.hidden = true
            }
            return
        }
        
        let labelWidth = self._widthChart / CGFloat(arrayXString.count)
        DMCacheUtils.cacheFromArray(_arrayXLabel, count: arrayXString.count) {[weak self](var label, index) -> Void in
            if(index < self!.arrayXString.count){
                let frame = CGRectMake(CGFloat(index) * labelWidth + self!.marginLeft, self!._bottomY, labelWidth, self!.marginBottom)
                if(label == nil){
                    label = UILabelWithPadding(frame: frame)
                    self!.addSubview(label)
                    self!._arrayXLabel.append(label)
                    label.textColor = UIColor.grayColor()
                    label.font = UIFont.systemFontOfSize(12)
                    label.textAlignment = NSTextAlignment.Center
                    
                }else{
                    label.frame = frame
                    label.hidden = false
                }
                label.tag = 1000 + index
                label.text = String(index)
                self!.labelForXAxes?(label: label, index: index)
            }else{
                label?.hidden = true
            }
        }
    }
    
    private func drawYLabel(){
        if(valueMax <= 0){
            for view in _arrayYLabel{
                view.hidden = true
            }
            return
        }
        
        //使用缓存机制
        DMCacheUtils.cacheFromArray(self._arrayYLabel,count: self._countY + 1,reuse:{[weak self](var label, index) -> Void in
            if(index < self!._countY + 1){
                var frame = CGRectMake(0, self!._bottomY - 10 - CGFloat(index) * self!._intervalY, self!.marginLeft, 20)
                //不能整除时，该值为true
                let singleMax = (index == self!._countY && !self!.isJustDivider)
                if (singleMax){
                    frame.origin.y = self!.marginTop
                    print("add max")
                }else if(index == 0){
                    frame.origin.y -= 6
                }
                if(label == nil){
                    //创建新的label
                    print("Add y = \(index)")
                    label = self!.createYLabel(frame)
                    self!.addSubview(label)
                    self!._arrayYLabel.append(label)
                } else {
                    //使用缓存中的label
                    label.frame = frame
                    label.hidden = false
                    print("reuse y = \(index)")
                }
                label.tag = 2000 + index
                if(!singleMax){
                    label.text = String(CGFloat(index) * self!.valueInterval)
                }else{
                    label.text = String(CGFloat(self!.valueMax))
                }
                self!.labelForYAxes?(label: label, index: index, isMax : self!.isJustDivider)
            } else {
                //隐藏缓存中多余的label
                label?.hidden = true
            }
        })
    }
    
    private func createYLabel(frame : CGRect) -> UILabelWithPadding{
        let label = UILabelWithPadding(frame: frame)
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = NSTextAlignment.Right
        label.padding = UIEdgeInsetsMake(0, self.marginBetweenXLabel, 0, self.marginBetweenXLabel)
        return label
    }
}