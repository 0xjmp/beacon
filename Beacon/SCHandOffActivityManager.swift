//
//  SCHandOffActivityManager.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/29/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCHandOffActivityManager: NSObject {
    
    class func receive(userActivity:NSUserActivity) {
        SCUser.getProfile({ (responseObject, error) -> Void in
            if let user = responseObject as? SCUser {
                if (error == nil) {
                    if let path = user.profileUrl {
                        let url = NSURL(string: path)
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
            }
        })
    }
    
}
