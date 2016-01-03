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
    private var _layerShape : CAShapeLayer!
    private var _originFrame : CGRect!
    private var _radius : CGFloat = 0
    private var _radiusChange : CGFloat = 0
    private var _center : CGPoint!
    private var _points : Array<CGPoint>!
    private var offsetOld : CGPoint!
    var offset : CGPoint!
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
        _layerShape = CAShapeLayer()
        self.layer.addSublayer(_layerShape)
        _points = Array<CGPoint>(count:6, repeatedValue: CGPointZero)
        _center = CGPointMake(self.width * 0.5, self.height * 0.5)
        _radius = self.width * 0.5 - 1
        _radiusChange = _radius
        _link = CADisplayLink(target: self, selector: "_update:")
        _link.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        offset = CGPointMake(40, 40)
        print("config = \(offset)")
    }

    func _update(link: CADisplayLink){
//        offset = DMPointAdd(offset, CGPointMake(0, 1))
        if offset != offsetOld{
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        print("rect = \(rect)")
        let path1 = UIBezierPath()
        path1.addArcWithCenter(_center, radius: _radiusChange, startAngle: 0, endAngle: PI * 2, clockwise: true)
        color.setFill()
        path1.fill()
        
        let path = UIBezierPath()
        if offset == nil || offset == CGPointZero {
//            path.moveToPoint(_center)
//            path.addArcWithCenter(_center, radius: _radius, startAngle: 0, endAngle: PI * 2, clockwise: true)
        } else {
            _computePoints()
            path.moveToPoint(_points[1])
            path.addArcWithCenter(_center, radius: _radiusChange, startAngle: 0, endAngle: PI, clockwise: false)
            path.addQuadCurveToPoint(_points[2], controlPoint: _points[4])
            path.addArcWithCenter(DMPointAdd(offset, _center), radius: _radius, startAngle: PI, endAngle: 0, clockwise: false)
            path.addQuadCurveToPoint(_points[1], controlPoint: _points[5])
        }
        path.closePath()
        _layerShape.path = path.CGPath
        _layerShape.strokeColor = color.CGColor
        _layerShape.fillColor = color.CGColor
        offsetOld = offset
    }

    func _computePoints() {
        let distance = sqrt(offset.x * offset.x + offset.y * offset.y)
        let scale = max(0.1, 1 -  distance / viscid)
         _radiusChange = _radius * scale

        var cosDegree : CGFloat = 1
        var sinDegree : CGFloat = 0
        if distance != 0{
            cosDegree = offset.y / distance
            sinDegree = offset.x / distance
        }
        //    NSLog(@"%f", acosf(cosDigree));
        
//        pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
//        pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
//        pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
//        pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
//        pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
//        pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);

        //origin left
        _points[0] = CGPointMake(_center.x - _radiusChange * cosDegree, _center.y + _radiusChange * sinDegree)
        //origin right
        _points[1] = CGPointMake(_center.x + _radiusChange * cosDegree, _center.y - _radiusChange * sinDegree)
        //now left
        _points[2] = CGPointMake(_center.x + offset.x - _radius * cosDegree, _center.y + offset.y + _radius * sinDegree)
        //now right
        _points[3] = CGPointMake(_center.x + offset.x + _radius * cosDegree, _center.y + offset.y - _radius * sinDegree)
        //control left
        _points[4] = DMPointAdd(DMPointMiddle(_points[0], _points[2]), CGPointMake((_radius - _radiusChange) * cosDegree, (_radius - _radiusChange) * sinDegree))
        //control right
        _points[5] = DMPointMiddle(_points[1], _points[3])
        
    }
}
