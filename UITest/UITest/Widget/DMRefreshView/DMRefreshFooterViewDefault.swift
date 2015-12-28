//
//  DMRefreshFooterView.swift
//  UITest
//
//  Created by Milo on 15/12/25.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMRefreshFooterViewDefault: DMRefreshFooterViewBase {
    var label : UILabel!
    var arrow : ArrowView!
    var activityIndicator : UIActivityIndicatorView!
    
    internal override func config(){
        super.config()
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
        super.onNormalFromRefreshing()
        label.text = strPullToRefresh
        activityIndicator.stopAnimating()
        arrow.transform =  CGAffineTransformMakeRotation(CGFloat(M_PI))
        arrow.hidden = false
    }
    
    override func onNormalFromRelease() {
        super.onNormalFromRelease()
        label.text = strPullToRefresh
        UIView.animateWithDuration(DMAnimationDuraiton) { () -> Void in
            self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }
    override func onRefreshing() {
        super.onRefreshing()
        label.text = strRefreshing
        activityIndicator.startAnimating()
        arrow.hidden = true
        
    }
    
    override func onReleaseFromNormal() {
        super.onReleaseFromNormal()
        label.text = strReleaseToRefresh
        UIView.animateWithDuration(DMAnimationDuraiton) { () -> Void in
            self.arrow.transform = CGAffineTransformIdentity
        }
    }
}