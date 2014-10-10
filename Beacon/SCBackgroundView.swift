//
//  SCBackgroundView.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import CoreGraphics

class SCBackgroundView: UIView {

    override func drawRect(rect: CGRect) {
        
        let context : CGContextRef = UIGraphicsGetCurrentContext()
        let locations :[CGFloat] = [ 0.0, 0.25, 0.5, 0.75 ]
        let lightPurple = UIColor(red: 127.0/255.0, green: 58.0/255.0, blue: 94.0/255.0, alpha: 1.0).CGColor
        let darkPurple = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 65.0/255.0, alpha: 1.0).CGColor
        let colors:CFArray = [lightPurple, darkPurple]
        let colorspace : CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        var gradient:CGGradient = CGGradientCreateWithColors(colorspace, colors, locations)
        let startPoint : CGPoint = CGPointMake(0, 0)
        let endPoint : CGPoint = CGPointMake(750, 1400)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
    }

}
