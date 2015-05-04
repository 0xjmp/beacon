//
//  SCUsersManager.swift
//  Beacon
//
//  Created by Jake Peterson on 4/16/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit
import Argo
import Alamofire

public enum SCOAuthService: String {
    case FACEBOOK = "facebook"
    case LINKEDIN = "linkedin"
    case TUMBLR = "tumblr"
    case INSTAGRAM = "instagram"
    case GITHUB = "github"
    case BITBUCKET = "bitbucket"
}

class SCUsersManager: NSObject {
    
    class func create(serviceType:SCOAuthService, presentingViewController:UIViewController, delegate:SCOAuthDelegate?) {
        let viewController = SCOAuthViewController()
        viewController.delegate = delegate
        viewController.serviceType = serviceType
        presentingViewController.presentViewController(viewController, animated: true, completion: nil)
    }
    
    class func show(userId:Int, completionHandler:SCRequestResultsBlock) {
        let path = "users/\(userId)"
        SCNetworking.request(Method.GET, path: path, params: nil, completion: { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(response: nil, error: error)
            } else {
                var user:SCUser?
                if let response = responseObject as? NSDictionary {
                    if let userInfo: AnyObject = response["user"] {
                        user = SCUser.decode(JSONValue.parse(userInfo))
                    }
                }
                
                completionHandler(response: user as? AnyObject, error: nil)
            }
        })
    }
    
    class func update(userId:Int, visible:Bool, completionHandler:SCRequestResultsBlock) {
        SCNetworking.request(Method.PUT, path: "users/\(userId)", params: ["user" : ["visible" : visible]], completion: { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(response: nil, error: error)
            } else {
                var user:SCUser? = nil
                if let response = responseObject as? NSDictionary {
                    if let userInfo = response["user"] as? NSDictionary {
                        user = SCUser.decode(JSONValue.parse(userInfo))
                    }
                }
                
                completionHandler(response: user as? AnyObject, error: nil)
            }
        })
    }
}
