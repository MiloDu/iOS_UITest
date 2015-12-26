//
//  RefreshBaseView.swift
//  UITest
//
//  Created by Milo on 15/12/25.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

enum DMRefreshState{
    case Normal             //普通
    case ReleaseToRefresh   //松开刷新
    case Refreshing         //刷新中
}

enum DMRefreshViewType{
    case Header
    case Footer
}

public protocol DMRefreshDelegate : NSObjectProtocol{
    func onRefresh()
    func onLoad()
}

let kDMContentOffset = "contentOffset"
let DMAnimationDuraiton = 0.2

class DMRefreshBaseView: UIView {
    static func createHeaderView(frame frame : CGRect) -> DMRefreshHeaderView{
        return DMRefreshHeaderView(frame: frame)
    }
    
    static func createFooterView(frame frame : CGRect) -> DMRefreshFooterView{
        return DMRefreshFooterView(frame: frame)
    }

    var scrollView : UIScrollView!
    var scrollViewOriginalInset : UIEdgeInsets!
    var originalHeight : CGFloat = 0
    var state = DMRefreshState.Normal
    var isRefreshing : Bool{
        return self.state == DMRefreshState.Refreshing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        originalHeight = frame.size.height
        //        fatalError("Please do not init this view, Use method 'createHeaderView' or 'createFooterView'")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if(self.superview != nil){
            self.superview?.removeObserver(self, forKeyPath: kDMContentOffset)
        }
        
        if(newSuperview != nil){
            newSuperview?.addObserver(self, forKeyPath: kDMContentOffset, options: NSKeyValueObservingOptions.New, context: nil)
            newSuperview?.addObserver(self, forKeyPath: "tracking", options: NSKeyValueObservingOptions.New, context: nil)
            var rect = self.frame
            rect.size.width = (newSuperview?.frame.size.width)!
            rect.origin.x = 0
            self.frame = rect
            
            self.scrollView = newSuperview as! UIScrollView
            scrollViewOriginalInset = self.scrollView.contentInset
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == kDMContentOffset){
            self.onContentOffsetChanged()
        }
    }
    
    internal func onContentOffsetChanged(){
        //子类实现
    }
    
    func beginRefresh(){
        if(self.window != nil){
            self.state = DMRefreshState.Refreshing
        }
        
//        if (self.window != nil) {
//            self.State = RefreshState.Refreshing;
//        } else {
//            //不能调用set方法
//            State = RefreshState.WillRefreshing;
//            super.setNeedsDisplay()
//        }
    }
    
    func endRefresh(){
        if(self.window != nil){
            self.state = DMRefreshState.Normal
        }
        
//        let delayInSeconds:Double = 0.3
//        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds));
//        
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.State = RefreshState.Normal;
//        })
    }
}
