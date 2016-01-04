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
    var viscidView : UIViscidView!
    internal override func _config(){
        super._config()
        let width = CGRectGetWidth(self.frame)
        let height = CGRectGetHeight(self.frame)
        let frame = CGRectMake(width * 0.5 - 12, height - 24 * 1.5, 24, 24)
        print("y = \(frame.origin.y)")
//        let width : CGFloat = 24
//        let x = self.frame.size.width * 0.47
//        let y = self.frame.size.height * 0.5
//        dollarView = UIDollarView(frame: CGRectMake(x - 3 - width, y - width * 0.5, width, width))
//        dollarView.setStrokeEnd(0)
//        self.addSubview(dollarView)
        
//        label = UILabel(frame: CGRectMake(x + 3, 0, self.frame.size.width * 0.5, self.frame.size.height))
//        label.font = UIFont.systemFontOfSize(13)
//        label.textColor = UIColor.grayColor()
//        label.textAlignment = NSTextAlignment.Left
//        label.text = strPullToRefresh
//        self.addSubview(label)
        viscidView = UIViscidView(frame: frame, color: UIColor.greenColor())
        self.addSubview(viscidView)
    }

    override func _onNormalFromRefreshing() {
//        label.text = strPullToRefresh
        viscidView.end()
    }
    
    override func _onNormalFromRelease() {
//        label.text = strPullToRefresh
    }
    
    override func _onRefreshing() {
//        label.text = strRefreshing
//        dollarView.addAnimationRotate()
        viscidView.reset()
    }
    
    override func _onReleaseFromNormal() {
//        label.text = strReleaseToRefresh
    }
    
    override func _onStateChangeWithOffset(offset: CGPoint) {
        super._onStateChangeWithOffset(offset)
//        print("y = \(offset.y),origin = \(originalHeight)")
//        let end = min(1, offset.y / originalHeight)
//        dollarView.setStrokeEnd(end)
        let height = viscidView.frame.size.height
        let offsetY = offset.y - height * 1.5
        if offsetY > 0{
            var frame = viscidView.frame
            frame.origin.y = CGRectGetHeight(self.frame) - height * 1.5 - (offsetY)
            viscidView.frame = frame
            viscidView.start()
//            let a : CGFloat = offset.y - height
//            let b : CGFloat = CGRectGetHeight(self.frame) - height
//            print("a = \(a)")
//            print("b = \(b)")
//            print("c = \(b - a)")
            viscidView.offset = CGPointMake(0, offsetY)
        } else {
            viscidView.end()
        }
    }
}
