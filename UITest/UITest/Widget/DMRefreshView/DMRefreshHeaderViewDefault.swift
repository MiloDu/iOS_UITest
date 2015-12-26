//
//  DMRefreshHeaderView.swift
//  UITest
//
//  Created by Milo on 15/12/25.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMRefreshHeaderViewDefault : DMRefreshHeaderViewBase {
    let strPullToRefresh = "下拉刷新"
    let strRefreshing = "加载中..."
    let strReleaseToRefresh = "松开刷新"
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
        arrow.transform = CGAffineTransformIdentity
        arrow.hidden = false
    }
    
    override func onNormalFromRelease() {
        label.text = strPullToRefresh
        UIView.animateWithDuration(DMAnimationDuraiton) { () -> Void in
            self.arrow.transform = CGAffineTransformIdentity
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
            self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }
}

class ArrowView : UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let pointStart = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.2)
        let pointEnd = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.8)
        let pointLeft = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * 0.6)
        let pointRight = CGPointMake(self.frame.size.width * 0.7, self.frame.size.height * 0.6)
        let path = UIBezierPath()
        path.moveToPoint(pointStart)
        path.addLineToPoint(pointEnd)
        
        path.moveToPoint(pointLeft)
        path.addLineToPoint(CGPointMake(pointEnd.x + 0.9, pointEnd.y))
        
        path.moveToPoint(pointRight)
        path.addLineToPoint(CGPointMake(pointEnd.x - 0.9, pointEnd.y))
        
        UIColor.lightGrayColor().set()
        path.lineWidth = 2
        path.lineJoinStyle = CGLineJoin.Round
        path.stroke()
    }
}