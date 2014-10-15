//
//  SCFacebookManager.swift
//  Beacon
//
//  Created by Jake Peterson on 10/11/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCFacebookManager: NSObject {
    
    class var appId:NSString! {
        get {
            var path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            var plistInfo = NSDictionary(contentsOfFile: path!)
            return plistInfo["FacebookAppID"] as NSString
        }
    }
    
    class var permissions:[NSString] {
        get {
            return ["public_profile"]
        }
    }
    
    class func startSession(completion:(NSString? -> Void)) {
        var session = FBSession(appID: self.appId, permissions: self.permissions, urlSchemeSuffix: nil, tokenCacheStrategy:nil)
        FBSession.setActiveSession(session)
        session.openWithCompletionHandler { (session, state, error) -> Void in
            if error != nil {
                println("Facebook returned an error: \(error)")
                completion(nil)
            } else if session.isOpen {
                println(session)
                FBRequestConnection.startWithGraphPath("me", completionHandler: { (connection, userInfo, error) -> Void in
                    if error != nil {
                        println("Facebook returned an error: \(error)")
                        completion(nil)
                    } else {
                        completion(userInfo["link"] as? NSString)
                    }
                })
            } else {
                fatalError("fatal error w/ Facebook")
            }
        }
    }
}
