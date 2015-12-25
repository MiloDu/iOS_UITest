//
//  RefreshBaseView.swift
//  UITest
//
//  Created by Milo on 15/12/25.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

enum RefreshState{
    case Normal             //普通
    case ReleaseToRefresh   //松开刷新
    case Refreshing         //刷新中
}

enum RefreshViewType{
    case Header
    case Footer
}

public protocol RefreshDelegate : NSObjectProtocol{
    func onRefresh()
    func onLoad()
}

let kContentOffset = "contentOffset"
let AnimationDuraiton = 0.2

class RefreshBaseView: UIView {
    static func createHeaderView(frame frame : CGRect) -> RefreshHeaderView{
        return RefreshHeaderView(frame: frame)
    }
    
    static func createFooterView(frame frame : CGRect) -> RefreshFooterView{
        return RefreshFooterView(frame: frame)
    }

    var scrollView : UIScrollView!
    var scrollViewOriginalInset : UIEdgeInsets!
    var originalHeight : CGFloat = 0
    var state = RefreshState.Normal
    var isRefreshing : Bool{
        return self.state == RefreshState.Refreshing
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
            self.superview?.removeObserver(self, forKeyPath: kContentOffset)
        }
        
        if(newSuperview != nil){
            newSuperview?.addObserver(self, forKeyPath: kContentOffset, options: NSKeyValueObservingOptions.New, context: nil)
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
        if(keyPath == kContentOffset){
            self.onContentOffsetChanged()
        }
    }
    
    internal func onContentOffsetChanged(){
        //子类实现
    }
    
    func beginRefresh(){
        if(self.window != nil){
            self.state = RefreshState.Refreshing
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
            self.state = RefreshState.Normal
        }
        
//        let delayInSeconds:Double = 0.3
//        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds));
//        
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.State = RefreshState.Normal;
//        })
    }
}
