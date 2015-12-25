//
//  MyProgressView.swift
//  UITest
//
//  Created by Milo on 15/12/21.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

enum ProgressType{
    case Loading
    case OK
    case Error
    case Custom
}

class MyProgressView : UIView{
    private static var window : UIWindow!
    private static var dic = Dictionary<ProgressType, MyProgressView>()
    private static var currentView : MyProgressView!
    static func showHud(type : ProgressType = ProgressType.Loading, text : String = "", isTouchToDismiss : Bool = false){
        if(window == nil){
            window = UIWindow()
            window.windowLevel = UIWindowLevelAlert
            window.backgroundColor = UIColor.clearColor()
        }
        
        while(true){
            if(currentView == nil){
                print("currentView = \(currentView)")
                break
            }
            if(currentView.type != type){
                print("target = \(type) and now type = \(currentView.type)")
                currentView.removeFromSuperview()
                currentView = nil
                break
            }
            break
        }
        
        if(currentView == nil){
            if(dic[type] != nil){
                print("has cache")
                currentView = dic[type]
                window.addSubview(currentView)
            } else {
                print("no cache")
                currentView = MyProgressView(frame: window.bounds, type: type)
                dic[type] = currentView
                window.addSubview(currentView)
            }
        }
        currentView.start(text)
        currentView.isTouchToDismiss = isTouchToDismiss
//        print("current = \(currentView)")
//        print("touch to dismiss = \(currentView.isTouchToDismiss)")
        window.hidden = false
//        print("count ==== \(window.subviews.count)")
    }
    
    static func hideHud(){
        window.hidden = true
    }
    
//    private static var hudView : MyProgressView!
//    static func showHud(isTouchToDismiss : Bool = false){
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let window = appDelegate.window! as UIWindow
//        if(hudView == nil){
//            hudView = MyProgressView(frame: UIScreen.mainScreen().bounds)
//            window.addSubview(hudView!)
//        }
//        window.bringSubviewToFront(hudView!)
//        hudView?.isTouchToDismiss = isTouchToDismiss
//        hudView?.show()
//    }
    
    
    let sWidth : CGFloat = UIScreen.mainScreen().bounds.width
    let sHeight : CGFloat = UIScreen.mainScreen().bounds.height
    
    let width : CGFloat = 120
    let height :CGFloat = 120
    var centerFrame : CGRect!
    
    @IBInspectable var isTouchToDismiss = false
    @IBInspectable var type : ProgressType = ProgressType.Loading
    @IBInspectable var text : String = ""
    private var label : UILabel!
    private var shapeLayer : CAShapeLayer!
    private var animStrokeEnd : CABasicAnimation!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame : CGRect, type : ProgressType, text : String = "", isTouchToDismiss : Bool = false) {
        self.init(frame:frame)
        self.type = type
        self.text = text
        self.isTouchToDismiss = isTouchToDismiss
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
    }
    
    override func drawRect(rect: CGRect) {
        //draw background
        print("drawrect")
        let path = UIBezierPath(roundedRect: centerFrame, cornerRadius: 20)
        
//        let path = UIBezierPath(roundedRect: self.bounds,cornerRadius: 30)
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).set()
        path.fill()
    }
    
    private func config(){
        print("config")
        self.backgroundColor = UIColor.clearColor()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "onTap")
        self.addGestureRecognizer(tapRecognizer)
        centerFrame = CGRectMake(sWidth * 0.5 - width * 0.5, sHeight * 0.5 - height * 0.5, width, height)
        
        switch self.type{
        case .Loading:
            configLoading()
            break
        case .OK:
            configOK()
            break
        case .Error:
            configError()
            break
        case .Custom:
            configCustom()
            break
        }
    }
    
    private func configLoading(){
        //Add ActivityIndicatorView
        let indicator = UIActivityIndicatorView(frame: centerFrame)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicator.startAnimating()
        self.addSubview(indicator)
        
        //Add Label
        label = UILabel(frame: CGRectMake(centerFrame.origin.x, centerFrame.origin.y + centerFrame.size.height * 0.7, centerFrame.size.width,centerFrame.size.height * 0.2))
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = self.text
        self.addSubview(label)
    }
    
    private func configOK(){
        let center = CGPointMake(centerFrame.origin.x + centerFrame.size.width * 0.5, centerFrame.origin.y + centerFrame.size.height * 0.5)
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: center.x - 35, y: center.y - 5))
        path.addLineToPoint(CGPoint(x: center.x - 5, y: center.y + 35))
        path.addLineToPoint(CGPoint(x: center.x + 40, y: center.y - 35))
        configShapeLayer()
        shapeLayer.path = path.CGPath
        self.layer.addSublayer(shapeLayer)
    }
    
    private func configError(){
        let center = CGPointMake(centerFrame.origin.x + centerFrame.size.width * 0.5, centerFrame.origin.y + centerFrame.size.height * 0.5)
        let path = UIBezierPath()
        let l : CGFloat = 30
        path.moveToPoint(CGPoint(x: center.x - l, y: center.y - l))
        path.addLineToPoint(CGPoint(x: center.x + l, y: center.y + l))
        path.moveToPoint(CGPoint(x: center.x + l, y: center.y - l))
        path.addLineToPoint(CGPoint(x: center.x - l, y: center.y + l))
        configShapeLayer()
        shapeLayer.path = path.CGPath
        self.layer.addSublayer(shapeLayer)
    }
    
    private func configCustom(){
        let pi = CGFloat(M_PI)
        let middle = CGPointMake(centerFrame.origin.x + centerFrame.size.width * 0.5, centerFrame.origin.y + centerFrame.size.height * 0.5)
        let center = CGPointMake(middle.x, middle.y - centerFrame.size.height * 0.16)
        let center2 = CGPointMake(middle.x, middle.y + centerFrame.size.height * 0.16)
        let radius = centerFrame.size.height * 0.16
        let path = UIBezierPath()
        path.addArcWithCenter(center, radius: radius, startAngle: -0.1 * pi , endAngle: -1.5 * pi, clockwise: false)
        path.addArcWithCenter(center2, radius: radius, startAngle: -0.5 * pi, endAngle: 0.9 * pi, clockwise: true)
        path.moveToPoint(CGPointMake(middle.x, middle.y - centerFrame.size.height * 0.4))
        path.addLineToPoint(CGPointMake(middle.x, middle.y + centerFrame.size.height * 0.4))
        configShapeLayer()
        shapeLayer.path = path.CGPath
        self.layer.addSublayer(shapeLayer)
    }
    
    private func configShapeLayer(){
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    private func createAnim() -> CABasicAnimation{
        if(animStrokeEnd == nil){
            animStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            animStrokeEnd.duration = 0.4
            animStrokeEnd.fromValue = 0.0
            animStrokeEnd.toValue = 1.0
        }
        return animStrokeEnd
    }
    
    private func start(text : String){
        if(label != nil){
            label.text = text
        }
        if(shapeLayer != nil){
            let anim = createAnim()
            if(self.type == .Custom){
                anim.duration = 3
                anim.toValue = 1.5
                anim.repeatCount = HUGE
            }
            shapeLayer.addAnimation(anim, forKey: "StrokeEnd")
        }
    }

    func onTap(){
        if(isTouchToDismiss){
            MyProgressView.hideHud()
        }
    }

}
