//
//  MyView.swift
//  UITest
//
//  Created by MiloDu on 15/12/14.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class MyView : UIView {
    let PI = CGFloat(M_PI)
    let PI_2 = CGFloat(M_PI * 0.5)
    //Center Point
    private var touchCenter : CGPoint!
    private var radius : CGFloat = 0
    private var layerProgress : CAShapeLayer!
    private var viewPointer : UIView!
    private var lastLocation : CGPoint = CGPointMake(CGFloat.min,CGFloat.min)
    private var currentAngle : CGFloat = 0
    
    var minValue : CGFloat = 0.0
    var maxValue : CGFloat = 10.0
    var interval : CGFloat = 1.0
    var lineWidth : CGFloat = 10
    
    var progress : CGFloat = 0.5 {
        didSet{
            if(progress != oldValue){
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layerProgress.strokeEnd = progress
                CATransaction.commit()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = createPath()
        path.lineWidth = lineWidth
        UIColor.grayColor().set()
        path.stroke()
    }
    
    private func config(){
        self.backgroundColor = UIColor.clearColor()
        self.multipleTouchEnabled = false
        
        radius = self.bounds.width * 0.4
        touchCenter = CGPointMake(self.bounds.width * 0.5, self.bounds.height * 0.5)
        interval = 1 / maxValue
        print("touchCenter = \(touchCenter),radius = \(radius),interval = \(interval)")
        configProgressLayer()
        configPointer()
        
        let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onDrag:")
        self.addGestureRecognizer(dragGestureRecognizer)
    }
    
    private func configProgressLayer(){
        layerProgress = CAShapeLayer()
        layerProgress.frame = self.bounds
        
        let path = createPath(true)
        layerProgress.path = path.CGPath
        layerProgress.lineWidth = lineWidth
        layerProgress.lineCap = kCALineCapRound
        layerProgress.fillColor = UIColor.clearColor().CGColor
        layerProgress.strokeColor = UIColor.redColor().CGColor
//        layerProgress.strokeEnd = 0.0
        layerProgress.strokeEnd = progress
        
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = [UIColor.blueColor().CGColor,UIColor.greenColor().CGColor]
        layer.startPoint = CGPointZero
        layer.endPoint = CGPointMake(1, 0)
        layer.mask = layerProgress
        self.layer.addSublayer(layer)
    }
    
    private func configPointer(){
        viewPointer = UIView(frame: self.bounds)
        let rect = viewPointer.bounds
        let imageView = UIImageView(frame: CGRectMake(rect.width * 0.4, rect.height * 0.2, viewPointer.bounds.size.width * 0.2, viewPointer.bounds.size.height * 0.3))
        
        imageView.image =  UIImage(named: "pointer")
        viewPointer.addSubview(imageView)
        
        let label = UILabel(frame: CGRectMake(0,rect.height * 0.5,rect.width,rect.height * 0.5))
        label.textAlignment = NSTextAlignment.Center
        label.text = "转动吧少年"
        viewPointer.addSubview(label)
        addSubview(viewPointer)
        rotate()
    }
    
    private func rotate(){
        currentAngle = -PI_2 + progress * PI
        viewPointer.transform = CGAffineTransformMakeRotation(currentAngle)
    }
    
    private func createPath(isSemi : Bool = false) -> UIBezierPath{
        var endAngle = PI
        if(isSemi){
            endAngle = 0
        }
        let path = UIBezierPath(arcCenter: touchCenter, radius: radius, startAngle: -PI, endAngle: endAngle, clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func generateAnim() -> CABasicAnimation{
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.duration = 2
        anim.fromValue = 0
        anim.toValue = 1
        return anim
    }
    
    func onDrag(sender : UIPanGestureRecognizer){
        let location =  sender.locationInView(self)
        let dir = pointMinus(location, p2: touchCenter)
        let angle = computeRotate(pointMinus(lastLocation, p2: touchCenter), to: dir)
        currentAngle += angle
        if(currentAngle >= PI_2){
            currentAngle = PI_2
        }else if(currentAngle <= -PI_2){
            currentAngle = -PI_2
        }
        viewPointer.transform = CGAffineTransformMakeRotation(currentAngle)
        progress = (currentAngle + PI_2) / PI
        lastLocation = location
    }

    private func computeRotate(from : CGPoint, to : CGPoint)->CGFloat{
        let epsilon :  CGFloat = 1e-6
        let nyPI : CGFloat = acos(-1.0)
        var angle : CGFloat = 0
        let dist = sqrt(from.x * from.x + from.y * from.y)
        let x1 = from.x / dist
        let y1 = from.y / dist
        let dist2 = sqrt(to.x * to.x + to.y * to.y)
        let x2 = to.x / dist2
        let y2 = to.y / dist2
        let dot = x1 * x2 + y1 * y2
        if(fabs(dot - 1) < epsilon){
            angle = 0
        }else if(fabs(dot + 1) <= epsilon){
            angle = nyPI
        }else{
            angle = acos(dot)
            let cross = x1 * y2 - x2 * y1
            if(cross < 0){
                angle = -angle
            }
        }
        return angle
    }
    
    private func pointMinus(p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        return CGPointMake(p1.x - p2.x, p1.y - p2.y)
    }
    
    private func pointAdd(p1 : CGPoint, p2 : CGPoint) ->CGPoint{
        return CGPointMake(p1.x + p2.x, p1.y + p2.y)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("count = \(touches.count)")
        for touch in touches{
            lastLocation = touch.locationInView(self)
            break
        }
    }
}
