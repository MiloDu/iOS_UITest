//
//  DMChart.swift
//  UITest
//
//  Created by Milo on 15/12/28.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMChartAxesView: DMChartView {
    
    internal var widthChart : CGFloat = 0
    internal var heightChart : CGFloat = 0
    internal var intervalX : CGFloat = 0
    internal var intervalY : CGFloat = 0
    internal var countY : Int = 0               //根据valueMax和valueInterval计算
    //用于缓存UILabel
    private var arrayXLabel = Array<UILabelWithPadding>()
    private var arrayYLabel = Array<UILabelWithPadding>()
    
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
        self.widthChart = self.width - self.marginLeft - self.marginRight
        self.heightChart = self.height - self.marginBottom - self.marginTop
        //Y轴数量
        let countF = valueMax / valueInterval
        self.countY = Int(ceil(countF))
        //像素间隔
        if(arrayData.count > 0){
            self.intervalX = widthChart / CGFloat(arrayData.count)
        }
        self.intervalY = self.heightChart / countF
    }
    
    private func drawAxes(){
        let arrowLength : CGFloat = 4
        let pathAxes = UIBezierPath()
        let startX = marginLeft
        let startY = self.height - marginBottom
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
        for i in 1 ..< self.countY + 1{
            let y = self.height - self.marginBottom - CGFloat(i) * self.intervalY
            pathAxes.moveToPoint(CGPointMake(startX, y))
            pathAxes.addLineToPoint(CGPointMake(startX + 2, y))
        }
        pathAxes.stroke()
    }
    
    private func drawXLabel(){
        if(arrayXString.count <= 0){
            for view in arrayXLabel{
                view.hidden = true
            }
            return
        }
        
        var labelWidth = self.width - self.marginLeft - self.marginRight
        labelWidth /= CGFloat(arrayXString.count)
        let maxCount = max(arrayXLabel.count, arrayXString.count)
        for i in 0 ..< maxCount {
            if(i < arrayXString.count){
                var label : UILabelWithPadding!
                let frame = CGRectMake(CGFloat(i) * labelWidth + self.marginLeft + self.marginBetweenXLabel, self.height - marginBottom, labelWidth - self.marginBetweenXLabel * 2 , self.marginBottom)
                if(arrayXLabel.count <= i){
                    label = UILabelWithPadding(frame: frame)
                    self.addSubview(label)
                    arrayXLabel.append(label)
                    label.textColor = UIColor.grayColor()
                    label.font = UIFont.systemFontOfSize(12)
                    label.textAlignment = NSTextAlignment.Center
                }else{
                    label = arrayXLabel[i]
                    label.frame = frame
                    label.hidden = false
                }
                label.tag = 1000 + i
                label.text = String(i)
                self.labelForXAxes?(label: label, index: i)
            }else{
                arrayXLabel[i].hidden = true
            }
        }
    }
    
    private func drawYLabel(){
        if(valueMax <= 0){
            for view in arrayYLabel{
                view.hidden = true
            }
            return
        }
        
        //使用缓存机制
        let maxCount = max(self.arrayYLabel.count, self.countY + 1)
        for i in 0 ..< maxCount {
            if(i < self.countY + 1){
                var label : UILabelWithPadding!
                var frame = CGRectMake(0, self.height - self.marginBottom - 10 - CGFloat(i) * self.intervalY, self.marginLeft, 20)
                //不能整除时，该值为true
                let singleMax = (i == self.countY && !isJustDivider)
                if (singleMax){
                    frame.origin.y = self.marginTop
                    print("add max")
                }else if(i == 0){
                    frame.origin.y -= 6
                }
                if(arrayYLabel.count <= i){
                    //创建新的label
                    print("Add y = \(i)")
                    label = createYLabel(frame)
                    self.addSubview(label)
                    arrayYLabel.append(label)
                } else {
                    //使用缓存中的label
                    label = arrayYLabel[i]
                    label.frame = frame
                    label.hidden = false
                    print("reuse y = \(i)")
                }
                label.tag = 2000 + i
                if(!singleMax){
                    label.text = String(CGFloat(i) * self.valueInterval)
                }else{
                    label.text = String(CGFloat(valueMax))
                }
                self.labelForYAxes?(label: label, index: i, isMax : isJustDivider)
            } else {
                //隐藏缓存中多余的label
                arrayYLabel[i].hidden = true
            }
        }
    }
    
    private func createYLabel(frame : CGRect) -> UILabelWithPadding{
        let label = UILabelWithPadding(frame: frame)
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = NSTextAlignment.Right
        label.padding = UIEdgeInsetsMake(0, 4, 0, 4)
        return label
    }
}