//
//  UIViscidView.swift
//  UITest
//
//  Created by MiloDu on 16/1/3.
//  Copyright © 2016年 Milo. All rights reserved.
//
//UnReadBubbleView
import UIKit
class UIViscidView: UIView {
    private let PI = CGFloat(M_PI)
    private let MinScale : CGFloat = 0.3
    private var _link : CADisplayLink!
    private var _layerOrigin : CAShapeLayer!
    private var _layerMove : CAShapeLayer!
    private var _layerShape : CAShapeLayer!
    private var _originFrame : CGRect!
    private var _radius : CGFloat = 0
    private var _distance : CGFloat = 0
    private var _scale : CGFloat = 1
    private var _center : CGPoint!
    private var _points : Array<CGPoint>!
    private var offsetOld : CGPoint!
    var offset : CGPoint = CGPointMake(0, 0)
    var viscid : CGFloat = 1000
    var color : UIColor = UIColor.greenColor()
    
    var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self._config()
    }

    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        self._config()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._config()
    }
    
    private func _config(){
        self.backgroundColor = UIColor.clearColor()
        _points = Array<CGPoint>(count:6, repeatedValue: CGPointZero)
        _center = CGPointMake(self.width * 0.5, self.height * 0.5)
        _radius = self.width * 0.5 - 1
        _scale = 1 - MinScale
        
        _layerOrigin = CAShapeLayer()
        _layerOrigin.frame = self.bounds
        _layerOrigin.backgroundColor = UIColor.clearColor().CGColor
        let path = UIBezierPath(arcCenter: _center, radius: _radius, startAngle: 0, endAngle: PI * 2, clockwise: true)
        _layerOrigin.path = path.CGPath
        _layerOrigin.strokeColor = color.CGColor
        _layerOrigin.fillColor = color.CGColor
        self.layer.addSublayer(_layerOrigin)
        
        let path2 = UIBezierPath(arcCenter: _center, radius: _radius, startAngle: 0, endAngle: PI * 2, clockwise: true)
        _layerMove = CAShapeLayer()
        _layerMove.frame = self.bounds
        _layerMove.backgroundColor = UIColor.clearColor().CGColor
        _layerMove.path = path2.CGPath
        _layerMove.strokeColor = UIColor.redColor().CGColor
        _layerMove.fillColor = UIColor.redColor().CGColor
//        _layerMove.strokeColor = color.CGColor
//        _layerMove.fillColor = color.CGColor
//        _layerMove.hidden = true
        self.layer.addSublayer(_layerMove)

        _layerShape = CAShapeLayer()
        _layerShape.strokeColor = color.CGColor
        _layerShape.fillColor = color.CGColor
        _layerShape.hidden = true
        self.layer.addSublayer(_layerShape)
    }
    
    func start(){
        if _link == nil {
            print("sssssssstart")
            
            _layerMove.hidden = false
            _layerShape.hidden = false
            _layerOrigin.hidden = false
            _link = CADisplayLink(target: self, selector: "_update:")
            _link.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        }
    }
    
    func end(){
        if _link != nil{
            print("eeeeeeeedn")
            _link.invalidate()
            _link = nil

        }
    }
    
    func reset(showAnimation : Bool = true){
        end()
        _layerShape.hidden = true
        _layerOrigin.transform = CATransform3DIdentity
        _layerOrigin.hidden = true
        
        print("111is in =\(CATransform3DIsAffine(self._layerMove.transform))")
        if showAnimation {
            _layerMove.addAnimation(_createAnim(), forKey: nil)
//            UIView.animateWithDuration(0.8, animations: { () -> Void in
//                self._layerMove.transform = CATransform3DIdentity
//            })
//            let anim = CABasicAnimation(keyPath: "transform.scale.x")
//            anim.toValue = 1
//            anim.duration = 4
//            self._layerShape.addAnimation(anim, forKey: nil)
        } else {
            _scale = 1 - MinScale
            _layerShape.hidden = true
            _layerOrigin.transform = CATransform3DIdentity
            //            _layerOrigin.hidden = true
            _layerMove.transform = CATransform3DIdentity
            _layerMove.hidden = true
            self._layerMove.hidden = true
            self._layerMove.transform = CATransform3DIdentity
        }
    }
    
    func _update(link: CADisplayLink){
        if offset != offsetOld{
            print("update")
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        if isAnimating{
            return
        }
        print("drawRect")
        _computePoints()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let scale1 = MinScale + _scale
        _layerOrigin.transform = CATransform3DMakeScale(scale1, scale1, 0)
        
        if _distance > 0 {
            let scale2 = 1 - _scale
            let t = CATransform3DMakeTranslation(offset.x, offset.y, 0)
            _layerMove.transform = CATransform3DScale(t, scale2, scale2, 0)
        }else{
            _layerMove.transform = CATransform3DIdentity
        }

        let path = UIBezierPath()
        if _distance > _radius {
            path.moveToPoint(_points[0])
            path.addQuadCurveToPoint(_points[2], controlPoint: _points[4])
            path.addLineToPoint(_points[3])
            path.addQuadCurveToPoint(_points[1], controlPoint: _points[5])
            path.moveToPoint(_points[0])
        }
        _layerShape.path = path.CGPath
        CATransaction.commit()
        offsetOld = offset
    }

    private func _computePoints() {
        _distance = sqrt(offset.x * offset.x + offset.y * offset.y)
        let d = _distance - _radius * (1 - MinScale)
        if d > 0 {
            _scale = (1 - MinScale) * (1 - min(1, sqrt(d / viscid)))
        }
        
        let cosDegree = offset.y / _distance
        let sinDegree = offset.x / _distance

        let r1 = _radius * (MinScale + _scale)
        let r2 = _radius * (1 - _scale)

        _points[0] = CGPointMake(_center.x - r1 * cosDegree, _center.y + r1 * sinDegree)
        _points[1] = CGPointMake(_center.x + r1 * cosDegree, _center.y - r1 * sinDegree)
        _points[2] = CGPointMake(_center.x + offset.x - r2 * cosDegree, _center.y + offset.y + r2 * sinDegree)
        _points[3] = CGPointMake(_center.x + offset.x + r2 * cosDegree, _center.y + offset.y - r2 * sinDegree)
        _points[4] = DMPointAdd(DMPointMiddle(_points[0], _points[2]), CGPointMake((_radius - r1) * cosDegree, (_radius - r1) * sinDegree))
        _points[5] = DMPointMinus(DMPointMiddle(_points[1], _points[3]), CGPointMake((_radius - r1) * cosDegree, (_radius - r1) * sinDegree))
    }
    
    private func _createAnim() -> CABasicAnimation{
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.duration = 0.8
        anim.toValue = 1
        anim.fillMode = kCAFillModeBackwards
        anim.delegate = self
        return anim
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self._layerMove.transform = CATransform3DMakeScale(1, 1, 1)
    }
}
