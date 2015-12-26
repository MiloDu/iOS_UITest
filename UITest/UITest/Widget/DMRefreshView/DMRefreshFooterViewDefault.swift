//
//  DMRefreshFooterView.swift
//  UITest
//
//  Created by Milo on 15/12/25.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMRefreshFooterViewDefault: DMRefreshFooterViewBase {
    let strPullToRefresh = "上拉加载"
    let strRefreshing = "加载中..."
    let strReleaseToRefresh = "松开加载"
    var label : UILabel!
    var arrow : ArrowView!
    var activityIndicator : UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    convenience init(frame: CGRect, viewType : DMRefreshViewType) {
        self.init(frame : frame)
        self.viewType = viewType
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        if(self.subviews.count > 0){
            return
        }
        
        let width : CGFloat = 24
        let x = self.frame.size.width * 0.47
        let y = self.frame.size.height * 0.5
        arrow = ArrowView(frame: CGRectMake(x - 3 - width, y - width * 0.5, width, width))
        arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        self.addSubview(arrow)
        
        activityIndicator = UIActivityIndicatorView(frame: arrow.frame)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.addSubview(activityIndicator)
        
        label = UILabel(frame: CGRectMake(x + 3, 0, self.frame.size.width * 0.5, self.frame.size.height))
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.grayColor()
        label.textAlignment = NSTextAlignment.Left
        label.text = strPullToRefresh
        self.addSubview(label)
    }
    
    override func onNormalFromRefreshing() {
        label.text = strPullToRefresh
        activityIndicator.stopAnimating()
        arrow.transform =  CGAffineTransformMakeRotation(CGFloat(M_PI))
        arrow.hidden = false
    }
    
    override func onNormalFromRelease() {
        label.text = strPullToRefresh
        UIView.animateWithDuration(DMAnimationDuraiton) { () -> Void in
            self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }
    override func onRefreshing() {
        label.text = strRefreshing
        activityIndicator.startAnimating()
        arrow.hidden = true
        
    }
    
    override func onReleaseFromNormal() {
        label.text = strReleaseToRefresh
        UIView.animateWithDuration(DMAnimationDuraiton) { () -> Void in
            self.arrow.transform = CGAffineTransformIdentity
        }
    }
}