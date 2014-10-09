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
            let image = UIImage(named: "mainlogo")
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            return imageView
        }
    }
    
    // MARK: - Getters
    
    class var defaultBackgroundImageView:UIImageView {
        get {
            let image = UIImage(named: "background.jpg")
            var imageView = UIImageView(image: image)
            imageView.userInteractionEnabled = true
            imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            return imageView
        }
    }
    
    class func clearNavigation(bar:UINavigationBar) {
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.translucent = true
    }
    
    class func socialToolBar(controller:SCSocialIconsViewController) -> UIToolbar {
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, controller.view.bounds.size.height))
        let barButtonItem = UIBarButtonItem(customView: controller.view)
        toolbar.setItems([barButtonItem], animated: false)
        return toolbar
    }
    
    class var primaryTextColor:UIColor {
        get {
            return UIColor.whiteColor()
        }
    }
    
    class func primaryFont(size:CGFloat!) -> UIFont {
        return UIFont(name: "MavenProLight-300", size: size)
    }
}
