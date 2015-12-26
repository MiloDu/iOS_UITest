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
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
    }
    
    override func onNormalFromRefreshing() {
        label.text = "上拉加载"
    }
    override func onNormalFromRelease() {
        label.text = "上拉加载"
    }
    override func onRefreshing() {
        label.text = "加载中"
    }
    override func onReleaseFromNormal() {
        label.text = "松开加载"
    }
}
