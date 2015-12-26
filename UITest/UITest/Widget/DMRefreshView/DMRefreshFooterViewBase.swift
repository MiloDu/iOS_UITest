////
////  RefreshFooterView.swift
////  UITest
////
////  Created by Milo on 15/12/25.
////  Copyright © 2015年 Milo. All rights reserved.
////
//
//import UIKit
//
//class DMRefreshFooterViewBase: DMRefreshBaseView {
//
//    var label : UILabel!
//    override var state : DMRefreshState{
//        didSet{
//            if(oldValue != DMRefreshState.Refreshing){
//                scrollViewOriginalInset = scrollView.contentInset
//            }
//            if(self.state == oldValue){
//                return
//            }
//            print("state = \(self.state)")
//            switch self.state{
//            case DMRefreshState.Normal:
//                label.text = "上拉加载"
//                if(oldValue == DMRefreshState.Refreshing){
//                    //Refresh End
//                    UIView.animateWithDuration(DMAnimationDuraiton, animations: { () -> Void in
//                        var contentInset = self.scrollView.contentInset
//                        contentInset.bottom = self.scrollViewOriginalInset.bottom
//                        self.scrollView.contentInset = contentInset
//                    })
//                }else{
//                    //Drag change
//                }
//                break
//            case DMRefreshState.ReleaseToRefresh:
//                label.text = "松开加载"
//                //Drag change
//                break
//            case DMRefreshState.Refreshing:
//                label.text = "加载中..."
//                UIView.animateWithDuration(DMAnimationDuraiton, animations: { () -> Void in
//                    var bottom:CGFloat = self.frame.size.height + self.scrollViewOriginalInset.bottom
//                    let maxOffsetY = self.computeMaxOffsetY()
//                    if maxOffsetY < 0 {
//                        bottom = bottom - maxOffsetY
//                    }
//                    var contentInset = self.scrollView.contentInset;
//                    contentInset.bottom = bottom;
//                    self.scrollView.contentInset = contentInset;
//                })
//                
//                if(self.scrollView.delegateRefresh != nil){
//                    self.scrollView.delegateRefresh!.onLoad()
//                }
//                break
//            }
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        config()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func config(){
//        self.backgroundColor = UIColor.redColor()
//        label = UILabel(frame: self.bounds)
//        label.font = UIFont.systemFontOfSize(12)
//        label.textColor = UIColor.blackColor()
//        label.textAlignment = NSTextAlignment.Center
//        self.addSubview(label)
//    }
//    
//    override func willMoveToSuperview(newSuperview: UIView?) {
//        super.willMoveToSuperview(newSuperview)
//        adjustFrame()
//        if(self.superview != nil){
//            self.superview?.removeObserver(self, forKeyPath: kDMContentSize)
//        }
//        
//        if(newSuperview != nil){
//            newSuperview?.addObserver(self, forKeyPath: kDMContentSize, options: NSKeyValueObservingOptions.New, context: nil)
//        }
//    }
//    
//    internal func adjustFrame(){
//        let y = max(self.scrollView.contentSize.height, self.scrollView.frame.size.height) + scrollViewOriginalInset.bottom
//        var rect = self.frame
//        rect.origin.y = y + self.scrollViewOriginalInset.bottom
//        self.frame = rect
//    }
//    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//        if(keyPath == kDMContentSize){
//            onContentSizeChanged()
//        }
//    }
//    
//    internal func onContentSizeChanged(){
//        adjustFrame()
//    }
//    
//    override func onContentOffsetChanged() {
//        super.onContentOffsetChanged()
//        if(self.hidden){
//            return
//        }
//        
//        if(isRefreshing){
//            return
//        }
//        
//        self.changeStateWithOffset()
//    }
//    
//    private func changeStateWithOffset(){
//        let offsetY = self.scrollView.contentOffset.y
//        let maxOffsetY = computeMaxOffsetY()
//        var threshold : CGFloat = 0 //标识是否显示出
//        if(maxOffsetY > 0){
//            threshold = maxOffsetY
//        }
//        if(offsetY <= threshold){
//            return
//        }
//        if(self.scrollView.dragging){
//            if(self.state == DMRefreshState.Normal && offsetY > threshold + originalHeight){
//                // Normal -> ReleaseToRefresh
//                self.state = DMRefreshState.ReleaseToRefresh
//            }else if(self.state == DMRefreshState.ReleaseToRefresh && offsetY <= threshold + originalHeight){
//                // ReleaseToRefresh -> Normal
//                self.state = DMRefreshState.Normal
//            }
//        }else{
//            if(self.state == DMRefreshState.ReleaseToRefresh){
//                self.state = DMRefreshState.Refreshing
//            }
//        }
//    }
//    
//    private func computeMaxOffsetY() ->CGFloat{
//        let maxOffsetY = self.scrollView.contentSize.height - (self.scrollView.frame.size.height + self.scrollViewOriginalInset.top + scrollViewOriginalInset.bottom)
//        return maxOffsetY
//    }
//}
