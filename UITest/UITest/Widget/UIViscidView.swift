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
    private var _link : CADisplayLink!
    private var _layerOrigin : CAShapeLayer!
    private var _layerMove : CAShapeLayer!
    private var _layerShape : CAShapeLayer!
    private var _originFrame : CGRect!
    private var _radius : CGFloat = 0
    private var _radiusChange : CGFloat = 0
    private var _scale : CGFloat = 1
    private var _center : CGPoint!
    private var _points : Array<CGPoint>!
    private var offsetOld : CGPoint!
    var offset : CGPoint = CGPointMake(0, 0)
    var viscid : CGFloat = 100
    var color : UIColor = UIColor.greenColor()
    
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
        _radiusChange = _radius
        
        _layerOrigin = CAShapeLayer()
        _layerOrigin.frame = self.bounds
        _layerOrigin.backgroundColor = UIColor.clearColor().CGColor
        let path = UIBezierPath(arcCenter: _center, radius: _radiusChange, startAngle: 0, endAngle: PI * 2, clockwise: true)
        _layerOrigin.path = path.CGPath
        _layerOrigin.strokeColor = color.CGColor
        _layerOrigin.fillColor = color.CGColor
        self.layer.addSublayer(_layerOrigin)
        
        let path2 = UIBezierPath(arcCenter: _center, radius: _radius, startAngle: 0, endAngle: PI * 2, clockwise: true)
        _layerMove = CAShapeLayer()
        _layerMove.frame = CGRectMake(0, self.height * 0.5, self.width, self.height)
        _layerMove.backgroundColor = UIColor.clearColor().CGColor
        _layerMove.path = path2.CGPath
        _layerMove.strokeColor = UIColor.redColor().CGColor
        _layerMove.fillColor = UIColor.redColor().CGColor
//        _layerMove.strokeColor = color.CGColor
//        _layerMove.fillColor = color.CGColor
        _layerMove.hidden = true
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
            _link = CADisplayLink(target: self, selector: "_update:")
            _link.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        }
    }
    
    func end(){
        if _link != nil{
            print("eeeeeeeedn")
            _layerMove.hidden = true
            _layerShape.hidden = true
            _link.invalidate()
            _link = nil
        }
    }
    
    func reset(showAnimation : Bool = true){
        if showAnimation {
            UIView.animateWithDuration(0.4, animations: {[weak self] () -> Void in
                self?._layerShape.hidden = true
                self?._layerOrigin.hidden = true
                self?._layerMove.transform = CATransform3DIdentity
                }, completion: { (Bool) -> Void in
                    self._layerOrigin.transform = CATransform3DIdentity
                    self._layerOrigin.hidden = false
            })
        } else {
            self._layerShape.hidden = true
            self._layerOrigin.transform = CATransform3DIdentity
            self._layerMove.hidden = true
            self._layerMove.transform = CATransform3DIdentity
        }
    }
    
    func _update(link: CADisplayLink){
        if offset != offsetOld{
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        _computePoints()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        print("scale = \(_scale)")
        _layerOrigin.transform = CATransform3DMakeScale(_scale, _scale, 0)
        let path = UIBezierPath()
        if offset != CGPointZero {
            let t = CATransform3DMakeTranslation(offset.x, offset.y, 0)
            _layerMove.transform = CATransform3DScale(t, 1 - _scale, 1 - _scale, 1)
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

    func _computePoints() {
        let distance = sqrt(offset.x * offset.x + offset.y * offset.y)
//        _scale = max(0.2, 1 -  distance / viscid)
        _scale = 0.3 + (1 - sqrt(distance / viscid)) * 0.7
        _radiusChange = _radius * _scale

        var cosDegree : CGFloat = 1
        var sinDegree : CGFloat = 0
        if distance != 0{
            cosDegree = offset.y / distance
            sinDegree = offset.x / distance
        }

        //origin left
        let r1 = _radius * _scale
        let r2 = _radius - r1
        _points[0] = CGPointMake(_center.x - r1 * cosDegree, _center.y + r1 * sinDegree)
        //origin right
        _points[1] = CGPointMake(_center.x + r1 * cosDegree, _center.y - r1 * sinDegree)
        //now left
        _points[2] = CGPointMake(_center.x + offset.x - r2 * cosDegree, _center.y + offset.y + self.height * 0.5 + r2 * sinDegree)
        //now right
        _points[3] = CGPointMake(_center.x + offset.x + r2 * cosDegree, _center.y + offset.y + self.height * 0.5 - r2 * sinDegree)
        //control left
        _points[4] = DMPointAdd(DMPointMiddle(_points[0], _points[2]), CGPointMake((r2) * cosDegree, (r2) * sinDegree))
        //control right
        _points[5] = DMPointMinus(DMPointMiddle(_points[1], _points[3]), CGPointMake((r2) * cosDegree, (r2) * sinDegree))
    }
}
