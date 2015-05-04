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
        if let userInfo = userActivity.userInfo {
            if let userId:Int = userInfo["user_id"] as? Int {
                SCUsersManager.show(userId, completionHandler: { (user, error) -> Void in
                    if error == nil {
                        if let url:String = userInfo["url"] as? String {
                            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        }
                    }
                })
            }
        }
    }
    
}
