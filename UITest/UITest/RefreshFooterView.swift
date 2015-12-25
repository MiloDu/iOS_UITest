//
//  RefreshFooterView.swift
//  UITest
//
//  Created by Milo on 15/12/25.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class RefreshFooterView: RefreshBaseView {

    var label : UILabel!
    override var state : RefreshState{
        didSet{
            if(oldValue != RefreshState.Refreshing){
                scrollViewOriginalInset = scrollView.contentInset
            }
            if(self.state == oldValue){
                return
            }
            print("state = \(self.state)")
            switch self.state{
            case RefreshState.Normal:
                label.text = "下拉刷新"
                if(oldValue == RefreshState.Refreshing){
                    //Refresh End
                    UIView.animateWithDuration(AnimationDuraiton, animations: { () -> Void in
                        var contentInset = self.scrollView.contentInset
                        contentInset.top = self.scrollViewOriginalInset.top
                        self.scrollView.contentInset = contentInset
                    })
                }else{
                    //Drag change
                }
                break
            case RefreshState.ReleaseToRefresh:
                label.text = "松开刷新"
                //Drag change
                break
            case RefreshState.Refreshing:
                label.text = "刷新中..."
                UIView.animateWithDuration(AnimationDuraiton, animations: { () -> Void in
                    var contentInset = self.scrollView.contentInset
                    contentInset.top = self.scrollViewOriginalInset.top + self.originalHeight
                    self.scrollView.contentInset = contentInset
                    
                    //                    var offset:CGPoint = self.scrollView.contentOffset
                    //                    offset.y = -top
                    //                    self.scrollView.contentOffset = offset
                })
                
                if(self.scrollView.delegateRefresh != nil){
                    self.scrollView.delegateRefresh!.onRefresh()
                }
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        self.backgroundColor = UIColor.greenColor()
        label = UILabel(frame: self.bounds)
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.blackColor()
        label.text = "loading"
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        var rect = self.frame
        rect.origin.y = -rect.size.height
        self.frame = rect
    }
    
    override func onContentOffsetChanged() {
        super.onContentOffsetChanged()
        if(self.hidden){
            return
        }
        
        if(isRefreshing){
            return
        }
        
        self.changeStateWithOffset()
    }
    
    private func changeStateWithOffset(){
        let offsetY = self.scrollView.contentOffset.y
        let maxOffsetY = self.scrollView.contentSize.height - (self.scrollView.frame.size.height + self.scrollViewOriginalInset.top + scrollViewOriginalInset.bottom)
        let threthold : CGFloat = 0 //标识是否显示出
        print("dragging = \(scrollView.dragging)")
        if(offsetY >= threthold){
            return
        }
        if(self.scrollView.dragging){
            if(self.state == RefreshState.Normal && offsetY < threthold - originalHeight){
                // Normal -> ReleaseToRefresh
                self.state = RefreshState.ReleaseToRefresh
            }else if(self.state == RefreshState.ReleaseToRefresh && offsetY >= threthold - originalHeight){
                // ReleaseToRefresh -> Normal
                self.state = RefreshState.Normal
            }
        }else{
            if(self.state == RefreshState.ReleaseToRefresh){
                self.state = RefreshState.Refreshing
            }
        }
    }
}
