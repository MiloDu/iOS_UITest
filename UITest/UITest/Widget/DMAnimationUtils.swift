//
//  DMAnimationUtils.swift
//  UITest
//
//  Created by MiloDu on 15/12/27.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMAnimationUtils: NSObject {
    static let kAnimStroekEnd = "strokeEnd"
    static func animStrokeEnd(duration : NSTimeInterval) -> CABasicAnimation{
        let animStrokeEnd = CABasicAnimation(keyPath: kAnimStroekEnd)
        animStrokeEnd.duration = duration
        animStrokeEnd.fromValue = 0.0
        animStrokeEnd.toValue = 1.0
        return animStrokeEnd
    }
}
