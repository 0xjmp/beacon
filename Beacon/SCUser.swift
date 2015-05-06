//
//  SCUser.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/30/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import Argo
import Runes
import Alamofire

var SCUserLoggedOutNotification = "SCUserLoggedOutNotification"
var SCCurrentUserKey = "com.beacon.current_user"
var SCCookieName = "_session_id"

struct SCUser {
    let id:Int
    let zones:[SCZone]?
    let visible:Bool
    let identities:[SCIdentity]?
}

extension SCUser: JSONDecodable {
    
    static func create(id:Int)(zones:[SCZone]?)(visible:Bool)(identities:[SCIdentity]?) -> SCUser {
        return SCUser(id: id, zones: zones, visible: visible, identities: identities)
    }
    
    static func decode(d: JSONValue) -> SCUser? {
        return SCUser.create
        <^> d <| "id"
        <*> d <||? "zones"
        <*> d <| "visible"
        <*> d <||? "identities"
    }
}

class SCUsersManager: NSObject {
    
    deinit {
        self.stopWatchingForCookieUpdates()
    }
    
    static let sharedManager = SCUsersManager()
    
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
    
    var currentUser:SCUser?
    
    private var _cookieToken:String?
    private var cookieToken:String? {
        get {
            if _cookieToken == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                if let token = defaults.valueForKey(SCCookieName) as? String {
                    _cookieToken = token
                }
            }
            
            return _cookieToken
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(newValue, forKey: SCCookieName)
            
            _cookieToken = newValue
        }
    }
    
    func startWatchingForCookieUpdates() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateSession", name: NSHTTPCookieManagerCookiesChangedNotification, object: nil)
    }
    
    func stopWatchingForCookieUpdates() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: NSHTTPCookieManagerCookiesChangedNotification, object: nil)
    }
    
    func updateSession() {
        if cookieToken == nil {
            if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
                for cookie in cookies {
                    if cookie.name == SCCookieName {
                        cookieToken = cookie.name
                    }
                }
            }
        }
    }
}
