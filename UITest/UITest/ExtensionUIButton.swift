//
//  ExtensionUIButton.swift
//  UITest
//
//  Created by MiloDu on 16/1/2.
//  Copyright © 2016年 Milo. All rights reserved.
//

import UIKit

extension UIButton {

    func setBackgroundColor(color: UIColor, forState state: UIControlState){
        setBackgroundImage(UIView.imageWithColor(color), forState: state)
    }
}
