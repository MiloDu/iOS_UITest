//
//  ScrollView+Refresh.swift
//  UITest
//
//  Created by Milo on 15/12/25.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

extension UIScrollView {
    private struct RefreshKey {
        static var Delegate = "Delegate"
        static var Header = "Header"
        static var Footer = "Footer"
    }
    
    var delegateRefresh: RefreshDelegate? {
        get {
            return objc_getAssociatedObject(self, &RefreshKey.Delegate) as? RefreshDelegate
        }
        set (delegate) {
            objc_setAssociatedObject(self, &RefreshKey.Delegate, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var refreshHeader : RefreshHeaderView? {
        get{
            return objc_getAssociatedObject(self, &RefreshKey.Header) as? RefreshHeaderView
        }
        set(view){
            objc_setAssociatedObject(self, &RefreshKey.Header, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var refreshFooter : RefreshFooterView? {
        get{
            return objc_getAssociatedObject(self, &RefreshKey.Footer) as? RefreshFooterView
        }
        set(view){
            objc_setAssociatedObject(self, &RefreshKey.Footer, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    public func addRefreshHeader(frame frame: CGRect){
        let header = RefreshBaseView.createHeaderView(frame: frame)
        self.refreshHeader = header
        self.addSubview(header)
    }
    
    public func removeRefreshHeader(){
        self.refreshHeader?.removeFromSuperview()
    }
    
    public func beginRefresh(){
        self.refreshHeader?.beginRefresh()
    }
    
    public func endRefresh(){
        self.refreshHeader?.endRefresh()
    }
    
    public func addRefreshFooter(frame :  CGRect){
        let footer = RefreshBaseView.createFooterView(frame: frame)
        self.refreshFooter = footer
        self.addSubview(footer)
    }
    
    public func removeRefreshFooter(){
        self.refreshFooter?.removeFromSuperview()
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        print("===============touch began================")
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("======================Touchend===================")
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        print("===========cancel==============")
    }
//    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("================move=================")
//    }
}
