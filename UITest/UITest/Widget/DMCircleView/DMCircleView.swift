//
//  MyView.swift
//  UITest
//
//  Created by MiloDu on 15/12/14.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMCircleView : UIView {
    let PI = CGFloat(M_PI)
    let PI_2 = CGFloat(M_PI * 0.5)
    //Center Point
    private var _touchCenter : CGPoint!
    private var _radius : CGFloat = 0
    private var _layerProgress : CAShapeLayer!
    private var _viewPointer : UIView!
    private var _lastLocation : CGPoint = CGPointMake(CGFloat.min,CGFloat.min)
    private var _currentAngle : CGFloat = 0
    
    var minValue : CGFloat = 0.0
    var maxValue : CGFloat = 10.0
    var interval : CGFloat = 1.0
    var lineWidth : CGFloat = 10
    
    var progress : CGFloat = 0.5 {
        didSet{
            if(progress != oldValue){
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                _layerProgress.strokeEnd = progress
                CATransaction.commit()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _config()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _config()
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = _createPath()
        path.lineWidth = lineWidth
        UIColor.grayColor().set()
        path.stroke()
    }
    
    private func _config(){
        self.backgroundColor = UIColor.clearColor()
        self.multipleTouchEnabled = false
        
        _radius = self.bounds.width * 0.4
        _touchCenter = CGPointMake(self.bounds.width * 0.5, self.bounds.height * 0.5)
        interval = 1 / maxValue
        print("_touchCenter = \(_touchCenter),_radius = \(_radius),interval = \(interval)")
        _configProgressLayer()
        _configPointer()
        
        let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: "_onDrag:")
        self.addGestureRecognizer(dragGestureRecognizer)
    }
    
    private func _configProgressLayer(){
        _layerProgress = CAShapeLayer()
        _layerProgress.frame = self.bounds
        
        let path = _createPath(true)
        _layerProgress.path = path.CGPath
        _layerProgress.lineWidth = lineWidth
        _layerProgress.lineCap = kCALineCapRound
        _layerProgress.fillColor = UIColor.clearColor().CGColor
        _layerProgress.strokeColor = UIColor.redColor().CGColor
//        _layerProgress.strokeEnd = 0.0
        _layerProgress.strokeEnd = progress
        
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = [UIColor.blueColor().CGColor,UIColor.greenColor().CGColor]
        layer.startPoint = CGPointZero
        layer.endPoint = CGPointMake(1, 0)
        layer.mask = _layerProgress
        self.layer.addSublayer(layer)
    }
    
    private func _configPointer(){
        _viewPointer = UIView(frame: self.bounds)
        let rect = _viewPointer.bounds
        let imageView = UIImageView(frame: CGRectMake(rect.width * 0.4, rect.height * 0.2, _viewPointer.bounds.size.width * 0.2, _viewPointer.bounds.size.height * 0.3))
        
        imageView.image =  UIImage(named: "pointer")
        _viewPointer.addSubview(imageView)
        
        let label = UILabel(frame: CGRectMake(0,rect.height * 0.5,rect.width,rect.height * 0.5))
        label.textAlignment = NSTextAlignment.Center
        label.text = "转动吧少年"
        _viewPointer.addSubview(label)
        addSubview(_viewPointer)
        _rotate()
    }
    
    private func _rotate(){
        _currentAngle = -PI_2 + progress * PI
        _viewPointer.transform = CGAffineTransformMakeRotation(_currentAngle)
    }
    
    private func _createPath(isSemi : Bool = false) -> UIBezierPath{
        var endAngle = PI
        if(isSemi){
            endAngle = 0
        }
        let path = UIBezierPath(arcCenter: _touchCenter, radius: _radius, startAngle: -PI, endAngle: endAngle, clockwise: true)
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
    
    func _onDrag(sender : UIPanGestureRecognizer){
        let location =  sender.locationInView(self)
        let dir = _pointMinus(location, p2: _touchCenter)
        let angle = _computeRotate(_pointMinus(_lastLocation, p2: _touchCenter), to: dir)
        _currentAngle += angle
        if(_currentAngle >= PI_2){
            _currentAngle = PI_2
        }else if(_currentAngle <= -PI_2){
            _currentAngle = -PI_2
        }
        _viewPointer.transform = CGAffineTransformMakeRotation(_currentAngle)
        progress = (_currentAngle + PI_2) / PI
        _lastLocation = location
    }

    private func _computeRotate(from : CGPoint, to : CGPoint)->CGFloat{
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
    
    private func _pointMinus(p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        return CGPointMake(p1.x - p2.x, p1.y - p2.y)
    }
    
    private func _pointAdd(p1 : CGPoint, p2 : CGPoint) ->CGPoint{
        return CGPointMake(p1.x + p2.x, p1.y + p2.y)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("count = \(touches.count)")
        for touch in touches{
            _lastLocation = touch.locationInView(self)
            break
        }
    }
}
