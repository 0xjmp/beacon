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

struct SCUser {
    let id:Int
    let zones:[SCZone]?
    let visible:Bool
}

import Argo

extension SCUser: JSONDecodable {
    static func create(id:Int)(zones:[SCZone])(visible:Bool) -> SCUser {
        return SCUser(id: id, zones: zones, visible: visible)
    }
    
    static func decode(json: JSON) -> SCUser? {
        return _JSONParse(json) >>- { (d: JSONObject) in
            SCUser.create
                <^> d <| "id"
                <*> d <| "visible"
                <*> d <|| "zones"
        }
    }
}

extension SCUser {
    
    static var currentUser:SCUser? {
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(value, forKey: SCCurrentUserKey)
        
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
                if let user = SCUser.decode(userInfo!) {
                    if user.id == nil {
                        NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
                    } else {
                        // Set the cookie. This just serves for a bug that only exists in debuggging.
                        if let cookieInfo = NSUserDefaults.standardUserDefaults().objectForKey(SCCookieName) as? NSDictionary {
                            let cookie = NSHTTPCookie(properties: cookieInfo)!
                            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
                        }
                        
                        return user
                    }
                }
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
                println("User isn't logged in. Logging out...")
            }
            
            return nil
        }
    }
    
    static func getProfile(completionHandler:SCRequestResultsBlock) {
        let path = "users/"
        SCNetworking.shared.request(.GET, path: path, params: ["" : ""], completionHandler: { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: error)
            } else {
                var user:SCUser? = nil
                if let response = responseObject as? NSDictionary {
                    user = SCUser.decode(response["user"] as NSDictionary)
                    if user != nil {
                        self.currentUser = user
                    }
                }
                
                completionHandler(responseObject: user, error: nil)
            }
        })
    }
    
    static func delete(invisibleArea:SCInvisibleArea!, completionHandler:SCRequestResultsBlock) {
        if let user = self.currentUser {
            if let areas:NSMutableArray = NSArray(array: user.invisibleAreas!).mutableCopy() as? NSMutableArray {
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
    
    static func toggleBeacon(completionHandler:SCRequestResultsBlock) {
        var on:Bool = SCBeacon.decode(json: nil).beaconIsOn()
        if let user = self.currentUser {
            let path = "users/\(user.id.stringValue)"
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
    
    static func create(invisibleArea:SCInvisibleArea!, completionHandler:SCRequestResultsBlock) {
        SCNetworking.shared.request(.POST, path: "invisible_areas", params: ["invisible_area" : invisibleArea.toDictionary()], completionHandler: { (responseObject, error) -> Void in
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
    
    static func update(type:SCSocialType!, link:NSString!, completionHandler:SCRequestResultsBlock) {
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
   
    static func login(email:NSString, password:NSString, completionHandler:SCRequestResultsBlock) {
        SCNetworking.shared.request(.POST, path: "sessions", params: ["email" : email, "password" : password]) { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: error)
            } else {
                var user:SCUser? = nil
                if let response:NSDictionary = responseObject as? NSDictionary {
                    if let userInfo = response["user"] as? NSDictionary {
                        user = SCUser.decode(userInfo)
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
    
    static func signUp(email:NSString, password:NSString, passwordConfirmation:NSString, completionHandler:SCRequestResultsBlock) {
        let params = ["email" : email, "password" : password, "password_confirmation" : passwordConfirmation]
        SCNetworking.shared.request(.POST, path: "registrations", params: ["user" : params]) { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: nil)
            } else {
                var user:SCUser? = nil
                if let response = responseObject as? NSDictionary {
                    user = SCUser.decode(response["user"] as NSDictionary)
                    if user != nil {
                        self.currentUser = user
                    }
                }
                
                completionHandler(responseObject: user, error: nil)
            }
        }
    }
    
    static func getUserState(email:NSString, completionHandler:SCRequestResultsBlock) {
        SCNetworking.shared.request(.GET, path: "email/new", params: ["email" : email], completionHandler: completionHandler)
    }
}
