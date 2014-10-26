//
//  SCSocialManager.swift
//  Beacon
//
//  Created by Jake Peterson on 10/26/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import Social
import Accounts
import Alamofire

enum SCSocialType {
    case Facebook
    case Twitter
    case Instagram
    case LinkedIn
    case Tumblr
    
    func getDescription() -> NSString {
        switch self {
        case .Facebook:
            return "facebook"
        case .Twitter:
            return "twitter"
        case .Instagram:
            return "instagram"
        case .LinkedIn:
            return "linkedIn"
        case .Tumblr:
            return "tumblr"
        }
    }
    
}

typealias SCSocialCompletionBlock = (NSString?) -> Void

class SCSocialManager: NSObject {
    
    var completionBlock:SCSocialCompletionBlock?
    
    class func isSetup(type:SCSocialType) -> Bool {
        if let socialUrls = SCUser.currentUser?.socialUrls {
            return socialUrls.objectForKey(type.getDescription()) != nil
        }
        
        return false
    }
    
    class var shared : SCSocialManager {
    struct Static {
        static let instance : SCSocialManager = SCSocialManager()
        }
        return Static.instance
    }
    
    func attemptOAuth(type:SCSocialType, completion:SCSocialCompletionBlock) {
        self.completionBlock = completion
        
        let url = NSURL(string: "\(SCNetworking().baseUrl)/user/auth/\(type.getDescription())")
        UIApplication.sharedApplication().openURL(url)
    }
    
    func handleOpenUrl(url:NSURL, sourceApplication:NSString) -> Bool {
        
        
        return true
    }
    
    func applicationDidBecomeActive() {
        
    }
    
}
