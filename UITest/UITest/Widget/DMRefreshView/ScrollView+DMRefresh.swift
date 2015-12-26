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
    
    var delegateRefresh: DMRefreshDelegate? {
        get {
            return objc_getAssociatedObject(self, &RefreshKey.Delegate) as? DMRefreshDelegate
        }
        set (delegate) {
            objc_setAssociatedObject(self, &RefreshKey.Delegate, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var refreshHeader : DMRefreshHeaderView? {
        get{
            return objc_getAssociatedObject(self, &RefreshKey.Header) as? DMRefreshHeaderView
        }
        set(view){
            objc_setAssociatedObject(self, &RefreshKey.Header, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var refreshFooter : DMRefreshFooterView? {
        get{
            return objc_getAssociatedObject(self, &RefreshKey.Footer) as? DMRefreshFooterView
        }
        set(view){
            objc_setAssociatedObject(self, &RefreshKey.Footer, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    public func addRefreshHeader(frame frame: CGRect){
        let header = DMRefreshBaseView.createHeaderView(frame: frame)
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
    
    public func addRefreshFooter(frame frame :  CGRect){
        let footer = DMRefreshBaseView.createFooterView(frame: frame)
        self.refreshFooter = footer
        self.addSubview(footer)
    }
    
    public func removeRefreshFooter(){
        self.refreshFooter?.removeFromSuperview()
    }
}
