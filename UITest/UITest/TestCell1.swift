//
//  TestCell1.swift
//  UITest
//
//  Created by MiloDu on 16/1/2.
//  Copyright © 2016年 Milo. All rights reserved.
//

import UIKit

class TestCell1: UITableViewCell {
    var label1 : UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _config()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _config(){
        //使分割线靠左边
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
        
        label1 = UILabel(frame: CGRectMake(0,30,100,12))
        label1.font = UIFont.systemFontOfSize(12)
        self.contentView.addSubview(label1)
    }
}
