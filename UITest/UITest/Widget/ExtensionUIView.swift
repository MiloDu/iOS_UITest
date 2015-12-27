//
//  ExtensionUIView.swift
//  UITest
//
//  Created by MiloDu on 15/12/27.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

extension UIView {
    var originX : CGFloat{
        return self.frame.origin.x
    }
    
    var originY : CGFloat {
        return self.frame.origin.y
    }
    
    var width :  CGFloat{
        return self.frame.size.width
    }
    
    var height : CGFloat{
        return self.frame.size.height
    }
}
