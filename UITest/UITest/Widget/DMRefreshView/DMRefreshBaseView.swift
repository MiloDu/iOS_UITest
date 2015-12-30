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
    static func fromRawValue(rawValue : Int) -> DMRefreshViewType{
        if(rawValue == 2){
            return .Footer
        }
        return .Header
    }
}

enum DMRefreshHeaderViewType{
    case Default
    case Dollar
}

protocol DMRefreshDelegate : NSObjectProtocol{
    func onRefresh(viewType : DMRefreshViewType)
}

let kDMContentOffset = "contentOffset"
let kDMContentSize = "contentSize"

class DMRefreshBaseView: UIView {
    static func createHeaderView(frame frame : CGRect, type: DMRefreshHeaderViewType = DMRefreshHeaderViewType.Default) -> DMRefreshHeaderViewBase{
        switch type{
        case .Dollar:
            return DMRefreshHeaderViewDollar(frame: frame)
        default:
            return DMRefreshHeaderViewDefault(frame: frame)
        }
    }
    
    static func createFooterView(frame frame : CGRect) -> DMRefreshFooterViewBase{
        return DMRefreshFooterViewDefault(frame: frame)
    }

    @IBInspectable var viewTypeRawValue : Int = 1            //用于nib文件中与ViewType对应，1 = Header, 2 = Footer
    let animationDuraiton = 0.2
    var viewType : DMRefreshViewType = DMRefreshViewType.Header
    var scrollView : UIScrollView!
    var scrollViewOriginalInset : UIEdgeInsets!
    var originalHeight : CGFloat = 0
    var state = DMRefreshState.Normal
    var isRefreshing : Bool{
        return self.state == DMRefreshState.Refreshing
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        _config()
//    }
//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewType = DMRefreshViewType.fromRawValue(self.viewTypeRawValue)
        _config()
    }
    
    init(frame: CGRect, viewType : DMRefreshViewType) {
        super.init(frame: frame)
        self.viewType = viewType
        _config()
    }
    
    internal func _config(){
        originalHeight = frame.size.height
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
            self._onContentOffsetChanged()
        }
    }
    
    internal func _onContentOffsetChanged(){} //子类实现，用于监听UIScrollView contentOffset变化以改变状态
    //状态切换，在子类中实现各种效果
    internal func _onStateChangeWithOffset(offset : CGPoint){}       //contentOffset发生变化且Header或Footer显示出来
    internal func _onNormalFromRefreshing(){}
    internal func _onNormalFromRelease(){}
    internal func _onReleaseFromNormal(){}
    internal func _onRefreshing(){}
    
    //开始刷新
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
    //结束刷新
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

/*
* HeaderView的基类，具体效果在子类中实现
*/
class DMRefreshHeaderViewBase: DMRefreshBaseView {
    let strPullToRefresh = "下拉刷新"
    let strRefreshing = "加载中..."
    let strReleaseToRefresh = "松开刷新"
    //状态改变
    override var state : DMRefreshState{
        didSet{
            if(oldValue != DMRefreshState.Refreshing){
                scrollViewOriginalInset = scrollView.contentInset
            }
            if(self.state == oldValue){
                return
            }
            switch self.state{
            case DMRefreshState.Normal:
                if(oldValue == DMRefreshState.Refreshing){
                    //Refresh End
                    _onNormalFromRefreshing()
                    UIView.animateWithDuration(animationDuraiton, animations: { () -> Void in
                        var contentInset = self.scrollView.contentInset
                        contentInset.top = self.scrollViewOriginalInset.top
                        self.scrollView.contentInset = contentInset
                    })
                }else{
                    //Drag change
                    _onNormalFromRelease()
                }
                break
            case DMRefreshState.ReleaseToRefresh:
                //Drag change
                _onReleaseFromNormal()
                break
            case DMRefreshState.Refreshing:
                _onRefreshing()
                UIView.animateWithDuration(animationDuraiton, animations: { () -> Void in
                    var contentInset = self.scrollView.contentInset
                    contentInset.top = self.scrollViewOriginalInset.top + self.originalHeight
                    self.scrollView.contentInset = contentInset
                    //                    print("offset 2 = \(self.scrollView.contentOffset.y)")
                    //                    var offset:CGPoint = self.scrollView.contentOffset
                    //                    offset.y = -top
                    //                    self.scrollView.contentOffset = offset
                })
                
                if(self.scrollView.delegateRefresh != nil){
                    self.scrollView.delegateRefresh!.onRefresh(self.viewType)
                }
                break
            }
        }
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, viewType: DMRefreshViewType.Header)
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        _adjustFrame()
    }
    
    internal func _adjustFrame(){
        var rect = self.frame
        rect.origin.y = -rect.size.height - scrollViewOriginalInset.top
        self.frame = rect
    }
    
    override func _onContentOffsetChanged() {
        super._onContentOffsetChanged()
        if(self.hidden){
            return
        }
        
        if(isRefreshing){
            return
        }
        
        self._changeStateWithOffset()
    }
    
    private func _changeStateWithOffset(){
        let offsetY = self.scrollView.contentOffset.y
        let threshold = -scrollViewOriginalInset.top //标识是否显示出header
        if(offsetY >= threshold){
            return
        }
//        print("offset header = \(offsetY)")
        if(self.scrollView.dragging){
            if(self.state == DMRefreshState.Normal && offsetY < threshold - originalHeight){
                // Normal -> ReleaseToRefresh
                self.state = DMRefreshState.ReleaseToRefresh
            }else if(self.state == DMRefreshState.ReleaseToRefresh && offsetY >= threshold - originalHeight){
                // ReleaseToRefresh -> Normal
                self.state = DMRefreshState.Normal
            }
        }else{
            if(self.state == DMRefreshState.ReleaseToRefresh){
                self.state = DMRefreshState.Refreshing
            }
        }
        self._onStateChangeWithOffset(CGPointMake(self.scrollView.contentOffset.x, threshold - offsetY))
    }
}

/*
*FooterView的基类，具体效果在子类中实现
*/
class DMRefreshFooterViewBase: DMRefreshBaseView {
    let strPullToRefresh = "上拉加载"
    let strRefreshing = "加载中..."
    let strReleaseToRefresh = "松开加载"
        override var state : DMRefreshState{
        didSet{
            if(oldValue != DMRefreshState.Refreshing){
                scrollViewOriginalInset = scrollView.contentInset
            }
            if(self.state == oldValue){
                return
            }
            switch self.state{
            case DMRefreshState.Normal:
                if(oldValue == DMRefreshState.Refreshing){
                    //DMRefresh End
                    _onNormalFromRefreshing()
                    UIView.animateWithDuration(animationDuraiton, animations: { () -> Void in
                        var contentInset = self.scrollView.contentInset
                        contentInset.bottom = self.scrollViewOriginalInset.bottom
                        self.scrollView.contentInset = contentInset
                    })
                }else{
                    //Drag change
                    _onNormalFromRelease()
                }
                break
            case DMRefreshState.ReleaseToRefresh:
                //Drag change
                _onReleaseFromNormal()
                break
            case DMRefreshState.Refreshing:
                _onRefreshing()
                UIView.animateWithDuration(animationDuraiton, animations: { () -> Void in
                    var bottom:CGFloat = self.frame.size.height + self.scrollViewOriginalInset.bottom
                    let maxOffsetY = self._computeMaxOffsetY()
                    if maxOffsetY < 0 {
                        bottom = bottom - maxOffsetY
                    }
                    var contentInset = self.scrollView.contentInset;
                    contentInset.bottom = bottom;
                    self.scrollView.contentInset = contentInset;
                })
                
                if(self.scrollView.delegateRefresh != nil){
                    self.scrollView.delegateRefresh!.onRefresh(self.viewType)
                }
                break
            }
        }
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, viewType: DMRefreshViewType.Footer)
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        _adjustFrame()
        if(self.superview != nil){
            self.superview?.removeObserver(self, forKeyPath: kDMContentSize)
        }
        
        if(newSuperview != nil){
            newSuperview?.addObserver(self, forKeyPath: kDMContentSize, options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    
    internal func _adjustFrame(){
        let y = max(self.scrollView.contentSize.height, self.scrollView.frame.size.height) + scrollViewOriginalInset.bottom
        var rect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        if(keyPath == kDMContentSize){
            onContentSizeChanged()
        }
    }
    
    private func onContentSizeChanged(){
        _adjustFrame()
    }
    
    override func _onContentOffsetChanged() {
        super._onContentOffsetChanged()
        if(self.hidden){
            return
        }
        
        if(isRefreshing){
            return
        }
        
        self._changeStateWithOffset()
    }
    
    private func _changeStateWithOffset(){
        let offsetY = self.scrollView.contentOffset.y
        let maxOffsetY = _computeMaxOffsetY()
        var threshold : CGFloat = 0 //标识是否显示出
        if(maxOffsetY > 0){
            threshold = maxOffsetY
        }
        if(offsetY <= threshold){
            return
        }
        print("offset footer = \(offsetY)")
        if(self.scrollView.dragging){
            if(self.state == DMRefreshState.Normal && offsetY > threshold + originalHeight){
                // Normal -> ReleaseToDMRefresh
                self.state = DMRefreshState.ReleaseToRefresh
            }else if(self.state == DMRefreshState.ReleaseToRefresh && offsetY <= threshold + originalHeight){
                // ReleaseToDMRefresh -> Normal
                self.state = DMRefreshState.Normal
            }
        }else{
            if(self.state == DMRefreshState.ReleaseToRefresh){
                self.state = DMRefreshState.Refreshing
            }
        }
        self._onStateChangeWithOffset(CGPointMake(self.scrollView.contentOffset.x, offsetY - threshold))
    }
    
    private func _computeMaxOffsetY() ->CGFloat{
        let maxOffsetY = self.scrollView.contentSize.height - (self.scrollView.frame.size.height + self.scrollViewOriginalInset.top + scrollViewOriginalInset.bottom)
        return maxOffsetY
    }
}

