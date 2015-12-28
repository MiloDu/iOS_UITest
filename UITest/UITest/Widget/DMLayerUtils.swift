//
//  DMLayerUtils.swift
//  UITest
//
//  Created by MiloDu on 15/12/27.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

class DMLayerUtils: NSObject {
    
    private static func CATransform3DMakePerspective(x x: CGFloat, y : CGFloat, zDistance : CGFloat)-> CATransform3D{
        let transToCenter = CATransform3DMakeTranslation(-x, -y, 0)
        let transBack = CATransform3DMakeTranslation(x, y, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0 / zDistance
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
    }
    
    static func CATransform3DPerspective(t : CATransform3D, center: CGPoint, zDistance : CGFloat) -> CATransform3D{
        return CATransform3DConcat(t, CATransform3DMakePerspective(x : center.x, y : center.y , zDistance: zDistance))
    }
    
    static func CATransform3DPerspective(t : CATransform3D, x : CGFloat, y : CGFloat, zDistance : CGFloat) -> CATransform3D{
        return CATransform3DConcat(t, CATransform3DMakePerspective(x: x, y: y, zDistance: zDistance))
    }
    
    static func CATransform3DPerspective(t : CATransform3D, zDistance : CGFloat = 200) -> CATransform3D{
        return CATransform3DConcat(t, CATransform3DMakePerspective(x: 0, y: 0, zDistance: zDistance))
    }
}
