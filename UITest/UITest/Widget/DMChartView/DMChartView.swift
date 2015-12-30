//
//  DMChart.swift
//  UITest
//
//  Created by Milo on 15/12/28.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMChartView: UIView {
    static func createBarView(frame frame : CGRect)-> DMChartBarView{
        return DMChartBarView(frame : frame)
    }
    static func createLineView(frame frame : CGRect)-> DMChartLineView{
        return DMChartLineView(frame : frame)
    }

    var valueMax : CGFloat = 10
    var valueInterval : CGFloat = 1
    
    var arrayData = Array<DMDataItem>()
    var arrayXString = Array<String>()
}

class DMDataItem {
    var value : CGFloat = 0
}