//
//  SCSocialAccountSetupViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCSocialAccountSetupViewController: UIViewController {

    class func setup(type:SocialType) -> Bool {
        if let user = SCUser.currentUser {
            var isSetup = false
            for (var i = 0; i < user.socialUrls?.count; i++) {
                let url: NSString? = user.socialUrls?.objectAtIndex(i) as? NSString
                if (url?.isEqualToString(type.description()) != nil) {
                    isSetup = true
                    i = user.socialUrls!.count
                }
            }
            
            return isSetup
        }
        
        return false
    }

}
