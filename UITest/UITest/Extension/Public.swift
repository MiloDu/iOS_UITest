//
//  Public.swift
//  UITest
//
//  Created by MiloDu on 16/1/3.
//  Copyright © 2016年 Milo. All rights reserved.
//

import UIKit

func DMPointAdd(a: CGPoint, _ b:CGPoint)-> CGPoint{
    return CGPointMake(a.x + b.x, a.y + b.y)
}

func DMPointMinus(a: CGPoint, _ b:CGPoint)-> CGPoint{
    return CGPointMake(a.x - b.x, a.y - b.y)
}

func DMPointMiddle(a: CGPoint, _ b:CGPoint)-> CGPoint{
    return CGPointMake((a.x + b.x) * 0.5, (a.y + b.y) * 0.5)
}
