//
//  ViewController.swift
//  UITest
//
//  Created by MiloDu on 15/12/14.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RefreshDelegate {

    var circleView : MyView!
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
        let width = UIScreen.mainScreen().bounds.size.width
        let margin : CGFloat = 40
        circleView = MyView(frame: CGRectMake(margin,100, width - margin * 2,width - margin * 2))
        self.view.addSubview(circleView)
        tableView = UITableView(frame: self.view.bounds)
        tableView.addRefreshHeader(frame: CGRectMake(0 , 0, 320, 64))
        tableView.delegateRefresh = self
//        tableView.addSubview(RefreshBaseView.createHeaderView(frame : CGRectMake(0,0,320,64)))
        self.view.addSubview(tableView)
    }
    
    func generateAnim() -> CABasicAnimation{
        //        CATransaction.begin()
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.duration = 5
        anim.fromValue = 0
        anim.toValue = 1
        //        CATransaction.commit()
        return anim
    }
    
    func generateAnim2() -> CABasicAnimation{
        CATransaction.begin()
        let anim = CABasicAnimation(keyPath: "position")
        anim.duration = 5
        anim.fromValue = NSValue(CGPoint: CGPointMake(0, 0))
        anim.toValue = NSValue(CGPoint: CGPointMake(20, 60))
        CATransaction.commit()
        return anim
    }
    @IBAction func onButtonClicked(sender: UIButton) {
        print("onbutton clicked")
//        if(circleView.progress >= 0.9){
//            circleView.progress -= 0.1
//        }else{
//            circleView.progress += 0.1
//        }
        if(sender.tag == 1){
            showHudLoading()
        }else if(sender.tag == 2){
            showHudOK()
        }else if(sender.tag == 3){
            showHudError()
        }
    }
    
    //#prama RefreshDelegate
    func onRefresh(){
        print("onRefresh")
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "refreshEnd", userInfo: nil, repeats: false)
    }
    func onLoad(){
        
    }
    
    func refreshEnd(){
        self.tableView.endRefresh()
    }

}


var AssociatedObjectHandle : UInt8 = 0

extension UIViewController{
    
    var hudView : MyProgressView?{
        get{
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? MyProgressView
        }
        set{
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showHudLoading(){
        MyProgressView.showHud(ProgressType.Loading,text: "数据加载中...",isTouchToDismiss: true)
    }
    
    func showHudOK(){
        MyProgressView.showHud(ProgressType.OK,text: "", isTouchToDismiss:  true)
    }

    func showHudError(){
        MyProgressView.showHud(ProgressType.Custom, text: "", isTouchToDismiss: true)
    }

    
    func hideHud(){
        
    }
    
    //    func associatedObject<ValueType: AnyObject>(
    //        base: AnyObject,
    //        key: UnsafePointer<UInt8>,
    //        initialiser: () -> ValueType)
    //        -> ValueType {
    //            if let associated = objc_getAssociatedObject(base, key)
    //                as? ValueType { return associated }
    //            let associated = initialiser()
    //            objc_setAssociatedObject(base, key, associated,
    //                .OBJC_ASSOCIATION_RETAIN)
    //            return associated
    //    }
    //    func associateObject<ValueType: AnyObject>(
    //        base: AnyObject,
    //        key: UnsafePointer<UInt8>,
    //        value: ValueType) {
    //            objc_setAssociatedObject(base, key, value,
    //                .OBJC_ASSOCIATION_RETAIN)
    //    }

}
