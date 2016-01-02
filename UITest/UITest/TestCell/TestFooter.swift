//
//  TestHeader.swift
//  UITest
//
//  Created by MiloDu on 16/1/2.
//  Copyright © 2016年 Milo. All rights reserved.
//

import UIKit

class TestFooter: UITableViewHeaderFooterView {
    var label : UILabel!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        _config()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _config(){
        self.contentView.backgroundColor = UIColor.greenColor()
        label = UILabel(frame: CGRectMake(0,0,320,20))
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.redColor()
        self.contentView.addSubview(label)
    }
}
