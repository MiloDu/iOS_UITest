//
//  MyProgressView.swift
//  UITest
//
//  Created by Milo on 15/12/21.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

enum DMNoticeType{
    case Loading
    case OK
    case Error
    case Custom
    case Toast
}

class DMNoticeView : UIView{
    private static var _window : UIWindow!
    private static var _dic = Dictionary<DMNoticeType, DMNoticeView>()
    private static var _currentView : DMNoticeView!
    private static var timer: NSTimer!
//    static func toast(text: String){
//        if timer != nil{
//            timer.invalidate()
//            print("invalidate")
//        }
//        showHud(DMNoticeType.Toast, text: text, isTouchToDismiss: false)
//        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hideHud", userInfo: nil, repeats: false)
//    }
    
    static func showHud(type : DMNoticeType = DMNoticeType.Loading, text : String = "", isTouchToDismiss : Bool = false){
        if(_window == nil){
            _window = UIWindow()
            _window.windowLevel = UIWindowLevelAlert
            _window.backgroundColor = UIColor.clearColor()
        }
        
        while(true){
            if(_currentView == nil){
                break
            }
            if(_currentView._type != type){
                _currentView.removeFromSuperview()
                _currentView = nil
                break
            }
            break
        }
        
        if(_currentView == nil){
            if(_dic[type] != nil){
                print("has cache")
                _currentView = _dic[type]
                _window.addSubview(_currentView)
            } else {
                print("no cache")
                _currentView = DMNoticeView(frame: _window.bounds, type: type)
                _dic[type] = _currentView
                _window.addSubview(_currentView)
            }
        }
        _currentView.start(text)
        _currentView.isTouchToDismiss = isTouchToDismiss
//        print("current = \(currentView)")
//        print("touch to dismiss = \(currentView.isTouchToDismiss)")
        _window.hidden = false
//        print("count ==== \(window.subviews.count)")
    }
    
    static func hideHud(){
        _window.hidden = true
    }
    
    static func toast(text: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let _window = appDelegate.window! as UIWindow
        if _dic[DMNoticeType.Toast] == nil {
            let view = DMNoticeView(frame: _window.bounds, type: DMNoticeType.Toast)
            _dic[DMNoticeType.Toast] = view
        }
        if _dic[DMNoticeType.Toast]?.superview == nil{
            _window.addSubview(_dic[DMNoticeType.Toast]!)
        }
        _window.bringSubviewToFront(_dic[DMNoticeType.Toast]!)
        _dic[DMNoticeType.Toast]?.start(text)
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "_hideToast", userInfo: nil, repeats: false)
    }
    
    static func _hideToast(){
        _dic[DMNoticeType.Toast]?.removeFromSuperview()
    }
    
    let sWidth : CGFloat = UIScreen.mainScreen().bounds.width
    let sHeight : CGFloat = UIScreen.mainScreen().bounds.height
    
    let B_WIDTH : CGFloat = 120
    let B_HEIGHT :CGFloat = 120
    var centerFrame : CGRect!
    
    @IBInspectable var isTouchToDismiss = false
    @IBInspectable var text : String = ""
    private var _type : DMNoticeType = DMNoticeType.Loading
    private var _label : UILabel!
    private var _shapeLayer : CAShapeLayer!
    private var _animStrokeEnd : CABasicAnimation!

    init(frame : CGRect, type : DMNoticeType, text : String = "", isTouchToDismiss : Bool = false) {
        super.init(frame:frame)
        self._type = type
        self.text = text
        self.isTouchToDismiss = isTouchToDismiss
        _config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _config()
    }
    
    override func drawRect(rect: CGRect) {
        //draw background
        let path = UIBezierPath(roundedRect: centerFrame, cornerRadius: 20)
        
//        let path = UIBezierPath(roundedRect: self.bounds,cornerRadius: 30)
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).set()
        path.fill()
    }
    
    private func _config(){
        self.backgroundColor = UIColor.clearColor()
        if _type != DMNoticeType.Toast{
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "_onTap")
            self.addGestureRecognizer(tapRecognizer)
        }else{
            self.userInteractionEnabled = false
            self.window?.userInteractionEnabled = false
        }
        centerFrame = CGRectMake(sWidth * 0.5 - B_WIDTH * 0.5, sHeight * 0.5 - B_HEIGHT * 0.5, B_WIDTH, B_HEIGHT)
        
        switch self._type{
        case .Loading:
            _configLoading()
            break
        case .OK:
            _configOK()
            break
        case .Error:
            _configError()
            break
        case .Custom:
            _configCustom()
            break
        case .Toast:
            _configToast()
            break
        }
    }
    
    private func _configLoading(){
        //Add ActivityIndicatorView
        let indicator = UIActivityIndicatorView(frame: centerFrame)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicator.startAnimating()
        self.addSubview(indicator)
        
        //Add _label
        _label = UILabel(frame: CGRectMake(centerFrame.origin.x, centerFrame.origin.y + centerFrame.size.height * 0.7, centerFrame.size.width,centerFrame.size.height * 0.2))
        _label.font = UIFont.systemFontOfSize(13)
        _label.textColor = UIColor.whiteColor()
        _label.textAlignment = NSTextAlignment.Center
        _label.text = self.text
        self.addSubview(_label)
    }
    
    private func _configOK(){
        let center = CGPointMake(centerFrame.origin.x + centerFrame.size.width * 0.5, centerFrame.origin.y + centerFrame.size.height * 0.5)
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: center.x - 35, y: center.y - 5))
        path.addLineToPoint(CGPoint(x: center.x - 5, y: center.y + 35))
        path.addLineToPoint(CGPoint(x: center.x + 40, y: center.y - 35))
        _shapeLayer = CAShapeLayer()
        _configShapeLayer()
        _shapeLayer.path = path.CGPath
        self.layer.addSublayer(_shapeLayer)
    }
    
    private func _configError(){
        let center = CGPointMake(centerFrame.origin.x + centerFrame.size.width * 0.5, centerFrame.origin.y + centerFrame.size.height * 0.5)
        let path = UIBezierPath()
        let l : CGFloat = 30
        path.moveToPoint(CGPoint(x: center.x - l, y: center.y - l))
        path.addLineToPoint(CGPoint(x: center.x + l, y: center.y + l))
        path.moveToPoint(CGPoint(x: center.x + l, y: center.y - l))
        path.addLineToPoint(CGPoint(x: center.x - l, y: center.y + l))
        _shapeLayer = CAShapeLayer()
        _configShapeLayer()
        _shapeLayer.path = path.CGPath
        self.layer.addSublayer(_shapeLayer)
    }
    
    private func _configCustom(){
        let path = DMPathUtils.createPathDollar(centerFrame)
        _shapeLayer = CAShapeLayer()
        _configShapeLayer()
        _shapeLayer.path = path.CGPath
        self.layer.addSublayer(_shapeLayer)
    }
    
    private func _configToast(){
        centerFrame.origin.y += sHeight * 0.25
        _label = UILabel(frame: CGRectMake(centerFrame.origin.x + centerFrame.size.width * 0.1, centerFrame.origin.y + centerFrame.size.height * 0.1, centerFrame.size.width * 0.8, centerFrame.size.height * 0.8))
        _label.font = UIFont.systemFontOfSize(13)
        _label.textColor = UIColor.whiteColor()
        _label.textAlignment = NSTextAlignment.Center
        _label.numberOfLines = 3
        _label.text = self.text
        self.addSubview(_label)
    }
    
    private func _configShapeLayer(){
        _shapeLayer.lineWidth = 2
        _shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        _shapeLayer.fillColor = UIColor.clearColor().CGColor
        _shapeLayer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    private func _createAnim() -> CABasicAnimation{
        if(_animStrokeEnd == nil){
            _animStrokeEnd = DMAnimationUtils.createAnimStrokeEnd(0.4)
        }
        return _animStrokeEnd
    }
    
    func start(text : String){
        if(_label != nil){
            _label.text = text
        }
        if(_shapeLayer != nil){
            let anim = _createAnim()
            if(self._type == .Custom){
                anim.duration = 3
                anim.toValue = 1.5
                anim.repeatCount = HUGE
            }
            _shapeLayer.addAnimation(anim, forKey: DMAnimationUtils.kAnimStroekEnd)
        }
    }

    func _onTap(){
        if(isTouchToDismiss){
            DMNoticeView.hideHud()
        }
    }
}
