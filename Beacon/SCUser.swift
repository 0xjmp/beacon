//
//  SCUser.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/30/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

var SCUserLoggedOutNotification = "SCUserLoggedOutNotification"
var SCCurrentUserKey = "com.beacon.current_user"
var SCCookieName = "_session_id"

class SCUser: SCObject {
    
    var objectId:NSNumber!
    var profileUrl:NSString?
    var invisibleAreas:NSArray?
    var defaultSocialType:NSString?
    var socialUrls:NSDictionary?
    var email:NSString?
    
    override class func jsonMapping() -> NSDictionary {
        return [
            "id" : "objectId",
            "default_social_type" : "defaultSocialType",
            "social_urls" : "socialUrls",
            "email" : "email"
        ]
    }
    
    class var currentUser:SCUser? {
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue!.toDictionary(), forKey: SCCurrentUserKey)
            println("Setting new currentUser: \(newValue!.toDictionary())")
            if let cookies:[AnyObject] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
                for cookie in cookies {
                    if cookie.name == "_beacon-ruby-session" {
                        defaults.setObject(cookie.userInfo, forKey: SCCookieName)
                    }
                }
            }
        }
        get {
            var userInfo:NSDictionary? = NSUserDefaults.standardUserDefaults().objectForKey(SCCurrentUserKey) as? NSDictionary
            if userInfo?.allKeys.count > 0 {
                var user:SCUser = SCUser(json: userInfo!)
                if user.objectId == nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
                } else {
                    // Set the cookie. This just serves for a bug that only exists in debuggging.
                    if let cookieInfo = NSUserDefaults.standardUserDefaults().objectForKey(SCCookieName) as? NSDictionary {
                        let cookie = NSHTTPCookie(properties: cookieInfo)!
                        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
                    }
                    
                    return user
                }
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
                println("User isn't logged in. Logging out...")
            }
            
            return nil
        }
    }
    
    class func getProfile(completionHandler:SCRequestResultsBlock) {
        let path = "users/"
        SCNetworking.shared.request(.GET, path: path, params: ["" : ""], completionHandler: { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: error)
            } else {
                var user:SCUser? = nil
                if let response = responseObject as? NSDictionary {
                    user = SCUser(json: response["user"] as? NSDictionary)
                    if user != nil {
                        self.currentUser = user
                    }
                }
                
                completionHandler(responseObject: user, error: nil)
            }
        })
    }
    
    class func delete(invisibleArea:SCInvisibleArea!, completionHandler:SCRequestResultsBlock) {
        if let user = self.currentUser {
            if let areas:NSMutableArray = user.invisibleAreas?.mutableCopy() as? NSMutableArray {
                areas.removeObject(invisibleArea)
            } else {
                fatalError("Serious error")
            }
            
            let path = "users/\(user.objectId.stringValue)/"
            SCNetworking.shared.request(.DELETE, path: path, params: ["user" : user.toJSON()], completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    completionHandler(responseObject: nil, error: error)
                } else {
                    var user:SCUser? = nil
                    if let response = responseObject as? NSDictionary {
                        user = SCUser(json: response["user"] as? NSDictionary)
                        if user != nil {
                            self.currentUser = user
                        }
                    }
                    
                    completionHandler(responseObject: user, error: nil)
                }
            })
        }
    }
    
    class func toggleBeacon(completionHandler:SCRequestResultsBlock) {
        var on:Bool = SCBeacon(json: nil).beaconIsOn()
        if let user = self.currentUser {
            let path = "users/\(user.objectId.stringValue)"
            SCNetworking.shared.request(.PUT, path: path, params: ["user" : ["beacon" : on]], completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    completionHandler(responseObject: nil, error: error)
                } else {
                    if let response = responseObject as? NSDictionary {
                        on = response["on"] as Bool
                        SCBeacon(json: nil).updateBeaconState(on)
                    }
                    
                    completionHandler(responseObject: on, error: nil)
                }
            })
        }
    }
    
    class func changeDefaultSocial(type:SCSocialType, completionHandler:SCRequestResultsBlock) {
        if let user = self.currentUser {
            user.defaultSocialType = SSocialManager.nameForSocialType(type)
            
            let path = "users/\(user.objectId.stringValue)"
            SCNetworking.shared.request(.PUT, path: path, params: ["user" : user.toJSON()], completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    completionHandler(responseObject: nil, error: error)
                } else {
                    var user:SCUser? = nil
                    if let response = responseObject as? NSDictionary {
                        user = SCUser(json: response["user"] as? NSDictionary)
                        if user != nil {
                            self.currentUser = user
                        }
                    }
                    
                    completionHandler(responseObject: user, error: nil)
                }
            })
        }
    }
    
    class func create(invisibleArea:SCInvisibleArea!, completionHandler:SCRequestResultsBlock) {
        SCNetworking.shared.request(.POST, path: "invisible_areas", params: ["invisible_area" : invisibleArea.toJSON()], completionHandler: { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: error)
            } else {
                var user:SCUser? = nil
                if let response = responseObject as? NSDictionary {
                    user = SCUser(json: response["user"] as? NSDictionary)
                    if user != nil {
                        self.currentUser = user
                    }
                }
                
                completionHandler(responseObject: user, error: nil)
            }
        })
    }
    
    class func update(type:SCSocialType!, link:NSString!, completionHandler:SCRequestResultsBlock) {
        if let user = SCUser.currentUser {
            SCNetworking.shared.request(.PUT, path: "users/\(user.objectId)/social", params: ["type" : [SSocialManager .nameForSocialType(type)], "link" : link]) { (responseObject, error) -> Void in
                if error != nil {
                    completionHandler(responseObject: nil, error: error)
                } else {
                    var user:SCUser? = nil
                    if let response = responseObject as? NSDictionary {
                        user = SCUser(json: response["user"] as? NSDictionary)
                        if user != nil {
                            self.currentUser = user
                        }
                    }
                    
                    completionHandler(responseObject: user, error: nil)
                }
            }
        }
    }
   
    class func login(email:NSString, password:NSString, completionHandler:SCRequestResultsBlock) {
        SCNetworking.shared.request(.POST, path: "sessions", params: ["email" : email, "password" : password]) { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: error)
            } else {
                var user:SCUser? = nil
                if let response:NSDictionary = responseObject as? NSDictionary {
                    if let userInfo = response["user"] as? NSDictionary {
                        user = SCUser(json: userInfo)
                    }
                }
                
                if user != nil {
                    self.currentUser = user
                }
                
                var beaconCookie:NSHTTPCookie?
                if let cookies:[AnyObject] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
                    for cookie in cookies {
                        if cookie.name == SCCookieName {
                            beaconCookie = cookie as? NSHTTPCookie
                        }
                    }
                }
                
                if beaconCookie != nil {
                    NSUserDefaults.standardUserDefaults().setObject(beaconCookie?.properties, forKey: SCCookieName)
                }

                completionHandler(responseObject: user, error: nil)
            }
        }
    }
    
    class func signUp(email:NSString, password:NSString, passwordConfirmation:NSString, completionHandler:SCRequestResultsBlock) {
        let params = ["email" : email, "password" : password, "password_confirmation" : passwordConfirmation]
        SCNetworking.shared.request(.POST, path: "registrations", params: ["user" : params]) { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: nil)
            } else {
                var user:SCUser? = nil
                if let response = responseObject as? NSDictionary {
                    user = SCUser(json: response["user"] as? NSDictionary)
                    if user != nil {
                        self.currentUser = user
                    }
                }
                
                completionHandler(responseObject: user, error: nil)
            }
        }
    }
    
    class func getUserState(email:NSString, completionHandler:SCRequestResultsBlock) {
        SCNetworking.shared.request(.GET, path: "email/new", params: ["email" : email], completionHandler: completionHandler)
    }
}
