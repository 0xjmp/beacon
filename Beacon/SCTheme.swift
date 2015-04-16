//
//  SCTheme.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

struct SCTheme {
   
    static var logoImageView:UIImageView {
        get {
            let image = UIImage(named: "mainlogo")
            var imageView = UIImageView(image: image)
            let heightPadding:CGFloat = 15.0
            imageView.frame = CGRectMake(0, 0, image!.size.width, image!.size.height + heightPadding)
            imageView.contentMode = UIViewContentMode.Bottom
            return imageView
        }
    }
    
//    static var beaconPurple:UIColor {
//        get {
//            return UIColor(red: CGFloat(53.0/255.0), green: CGFloat(25.0/255.0), blue: CGFloat(59.0/255.0), alpha: CGFloat(1.0))
//        }
//    }

    // MARK: - Getters
    
    static var defaultBackgroundImageView:UIImageView {
        get {
            let image = UIImage(named: "background.jpg")
            var imageView = UIImageView(image: image)
            imageView.userInteractionEnabled = true
            imageView.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
            return imageView
        }
    }

    static func clearNavigation(bar:UINavigationBar) {
        bar.shadowImage = UIImage()
        bar.translucent = true
        
        let height:CGFloat = 80.0
        
        var frame = bar.frame
        frame.size.height = height
        bar.frame = frame
        
        let imageView = UIImageView(image: UIImage())
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        imageView.frame = CGRectMake(0, 0, bar.bounds.size.width, height)
        
        bar.setBackgroundImage(imageView.image, forBarMetrics: UIBarMetrics.Default)
    }

    static var primaryTextColor:UIColor {
        get {
            return UIColor.whiteColor()
        }
    }

    static func primaryFont(size:CGFloat!) -> UIFont {
        return UIFont(name: "MavenProLight300-Regular", size: size)!
    }
    
}
