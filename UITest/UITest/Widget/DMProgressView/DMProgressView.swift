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

class DMProgressView : UIView{
    private static var window : UIWindow!
    private static var dic = Dictionary<ProgressType, DMProgressView>()
    private static var currentView : DMProgressView!
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
                currentView = DMProgressView(frame: window.bounds, type: type)
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
    
    let B_WIDTH : CGFloat = 120
    let B_HEIGHT :CGFloat = 120
    var centerFrame : CGRect!
    
    @IBInspectable var isTouchToDismiss = false
    @IBInspectable var text : String = ""
    private var type : ProgressType = ProgressType.Loading
    private var label : UILabel!
    private var shapeLayer : CAShapeLayer!
    private var animStrokeEnd : CABasicAnimation!;

    init(frame : CGRect, type : ProgressType, text : String = "", isTouchToDismiss : Bool = false) {
        super.init(frame:frame)
        self.type = type
        self.text = text
        self.isTouchToDismiss = isTouchToDismiss
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    override func drawRect(rect: CGRect) {
        //draw background
        let path = UIBezierPath(roundedRect: centerFrame, cornerRadius: 20)
        
//        let path = UIBezierPath(roundedRect: self.bounds,cornerRadius: 30)
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).set()
        path.fill()
    }
    
    private func config(){
        self.backgroundColor = UIColor.clearColor()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "onTap")
        self.addGestureRecognizer(tapRecognizer)
        centerFrame = CGRectMake(sWidth * 0.5 - B_WIDTH * 0.5, sHeight * 0.5 - B_HEIGHT * 0.5, B_WIDTH, B_HEIGHT)
        
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
        shapeLayer = CAShapeLayer()
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
        shapeLayer = CAShapeLayer()
        configShapeLayer()
        shapeLayer.path = path.CGPath
        self.layer.addSublayer(shapeLayer)
    }
    
    private func configCustom(){
        let path = DMPathUtils.pathDollar(centerFrame)
        shapeLayer = CAShapeLayer()
        configShapeLayer()
        shapeLayer.path = path.CGPath
        self.layer.addSublayer(shapeLayer)
    }
    
    private func configShapeLayer(){
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    private func createAnim() -> CABasicAnimation{
        if(animStrokeEnd == nil){
            animStrokeEnd = DMAnimationUtils.createAnimStrokeEnd(0.4)
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
            shapeLayer.addAnimation(anim, forKey: DMAnimationUtils.kAnimStroekEnd)
        }
    }

    func onTap(){
        if(isTouchToDismiss){
            DMProgressView.hideHud()
        }
    }
}
