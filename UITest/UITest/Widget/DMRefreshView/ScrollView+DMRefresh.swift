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
    
    var refreshHeader : DMRefreshHeaderViewBase? {
        get{
            return objc_getAssociatedObject(self, &RefreshKey.Header) as? DMRefreshHeaderViewBase
        }
        set(view){
            objc_setAssociatedObject(self, &RefreshKey.Header, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var refreshFooter : DMRefreshFooterViewBase? {
        get{
            return objc_getAssociatedObject(self, &RefreshKey.Footer) as? DMRefreshFooterViewBase
        }
        set(view){
            objc_setAssociatedObject(self, &RefreshKey.Footer, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //注意：添加header或者footer必须在设置UIScrollView的contentInset属性之后
    func addRefreshHeader(frame frame: CGRect, type : DMRefreshHeaderViewType = DMRefreshHeaderViewType.Default){
        let header = DMRefreshBaseView.createHeaderView(frame: frame, type: type)
        self.refreshHeader = header
        self.addSubview(header)
    }
    
    func removeRefreshHeader(){
        self.refreshHeader?.removeFromSuperview()
    }
    
    func beginRefresh(){
        self.refreshHeader?.beginRefresh()
    }
    
    func endRefresh(type : DMRefreshViewType){
        if(type == DMRefreshViewType.Header){
            self.refreshHeader?.endRefresh()
        }else{
            self.refreshFooter?.endRefresh()
        }
    }
    
    func addRefreshFooter(frame frame :  CGRect){
        let footer = DMRefreshBaseView.createFooterView(frame: frame)
        self.refreshFooter = footer
        self.addSubview(footer)
    }
    
    func removeRefreshFooter(){
        self.refreshFooter?.removeFromSuperview()
    }
}
