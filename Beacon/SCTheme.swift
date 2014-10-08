//
//  SCTheme.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

/** 
 * This is mainly a "populator" class 
 */
class SCTheme: NSObject {
   
    class var logoImageView:UIImageView {
        get {
            let image = UIImage(named: "logo")
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            return imageView
        }
    }
    
    class func clearNavigation(bar:UINavigationBar) {
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.translucent = true
    }
}
