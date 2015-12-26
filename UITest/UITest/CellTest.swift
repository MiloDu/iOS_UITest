//
//  CellTest.swift
//  UITest
//
//  Created by MiloDu on 15/12/26.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class CellTest: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.grayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
}
