//
//  DMRefreshHeaderView.swift
//  UITest
//
//  Created by Milo on 15/12/25.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMRefreshHeaderViewDollar : DMRefreshHeaderViewBase {

    var label : UILabel!
    var dollarView : UIDollarView!
    
    internal override func config(){
        super.config()
        let width : CGFloat = 24
        let x = self.frame.size.width * 0.47
        let y = self.frame.size.height * 0.5
        dollarView = UIDollarView(frame: CGRectMake(x - 3 - width, y - width * 0.5, width, width))
//        dollarView.setStrokeEnd(0)
        self.addSubview(dollarView)
        
        label = UILabel(frame: CGRectMake(x + 3, 0, self.frame.size.width * 0.5, self.frame.size.height))
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.grayColor()
        label.textAlignment = NSTextAlignment.Left
        label.text = strPullToRefresh
        self.addSubview(label)
    }

    override func onNormalFromRefreshing() {
        label.text = strPullToRefresh
    }
    
    override func onNormalFromRelease() {
        label.text = strPullToRefresh
    }
    override func onRefreshing() {
        label.text = strRefreshing
        dollarView.addAnimationRotate()
    }
    
    override func onReleaseFromNormal() {
        label.text = strReleaseToRefresh
    }
    
    override func onStateChangeWithOffset(offset: CGPoint) {
        print("y = \(offset.y),origin = \(originalHeight)")
        let end = min(1, offset.y / originalHeight)
        dollarView.setStrokeEnd(end)
    }
}
