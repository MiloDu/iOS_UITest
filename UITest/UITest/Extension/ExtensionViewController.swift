//
//  ViewController+.swift
//  UITest
//
//  Created by MiloDu on 15/12/26.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

extension UIViewController {
    private struct _ParamKey {
        static var TapGesture = "TapGesture"
        static var DictView = "DictView"
    }

    var heightStatusBar : CGFloat{
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    var heightNavBar : CGFloat {
        if(self.navigationController != nil){
            return self.navigationController!.navigationBar.frame.size.height
        }
        return 0
    }
    
    var heightTabBar : CGFloat {
        if(self.tabBarController != nil){
            return self.tabBarController!.tabBar.frame.size.height
        }
        return 0
    }

    var frameView : CGRect{
        var y : CGFloat = 0
        var height : CGFloat = self.view.frame.size.height
        if(self.navigationController == nil && self.tabBarController == nil){
            y = heightStatusBar
            height -= heightStatusBar
        }else if(self.edgesForExtendedLayout == UIRectEdge.None){
            height -= (heightStatusBar + heightNavBar + heightTabBar)
            if(self.navigationController == nil){
                y = heightStatusBar
            }
        }
        return CGRectMake(0, y, self.view.frame.width, height)
    }
    
    var frameFull : CGRect{
        return UIScreen.mainScreen().bounds
    }
    
    func showHudLoading(){
        DMNoticeView.showHud(DMNoticeType.Loading,text: "数据加载中...",isTouchToDismiss: true)
    }
    
    func showHudOK(){
        DMNoticeView.showHud(DMNoticeType.OK,text: "", isTouchToDismiss:  true)
    }
    
    func showHudError(){
        DMNoticeView.showHud(DMNoticeType.Error, text: "", isTouchToDismiss: true)
    }
    
    func showHudCustom(){
        DMNoticeView.showHud(DMNoticeType.Custom, text: "", isTouchToDismiss: true)
    }
    
    func toast(text: String){
        DMNoticeView.toast(text)
    }
    
    func hideHud(){
        DMNoticeView.hideHud()
    }
    
    //MARK:- Keyboard Manager
    var arrayViews: Array<UIView>? {
        get {
            return objc_getAssociatedObject(self, &_ParamKey.DictView) as? Array<UIView>
        }
        set (array) {
            objc_setAssociatedObject(self, &_ParamKey.DictView, array, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var tapGesture: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &_ParamKey.TapGesture) as? UITapGestureRecognizer
        }
        set (tap) {
            objc_setAssociatedObject(self, &_ParamKey.TapGesture, tap, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func registerKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_onKeyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_onKeyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_onEditEnd", name: UITextFieldTextDidEndEditingNotification, object: nil)
    }
    
    func unregisterKeyboardObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func _onKeyboardShow(notification : NSNotification){
//        let keyboardInfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
//        let height = keyboardInfo?.CGRectValue.size.height
        if(tapGesture == nil){
            tapGesture = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        }
        self.view.addGestureRecognizer(tapGesture!)
    }
    
    func _onKeyboardHide(notification : NSNotification){
//        print("onKeyboardHide")
    }
    
    func _onEditEnd(){
     print("_onEditEnd")
    }
    
    func registerView(view: UIView, changedView: UIView){
        
    }
    
    func hideKeyboard(){
        self.view.removeGestureRecognizer(tapGesture!)
        self.view.endEditing(true)
        self.view.becomeFirstResponder()
    }
}
