//
//  SCUser.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/30/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCUser: SCObject {
    
    var id:Int!
    var profileUrl:NSString?
    var invisibleAreas:NSArray?
    var defaultSocialType:NSString?
    
    init(json:AnyObject!) {
        self.id = json.valueForKey("id") as? Int
        self.profileUrl = json.valueForKey("url") as? NSString
        self.invisibleAreas = json.valueForKey("invisible_areas") as? NSArray
        self.defaultSocialType = json.valueForKey("default_social_type") as? NSString
    }
    
    class var currentUser:SCUser? {
        get {
            var invisibleAreas = NSMutableArray()
            for (var i = 1; i < 4; i++) {
                let invisibleArea = SCInvisibleArea(json: ["id" : Int(i), "name" : "My House", "location" : "Westwood, CA"])
                invisibleAreas.addObject(invisibleArea)
            }
            return SCUser(json: ["id" : 1, "url" : "http://www.google.com", "invisible_areas" : invisibleAreas]) // TODO:
        }
    }
    
    class func getUserProfile(id:Int!, completionHandler:SCRequestResultsBlock) {
        let path = "users/\(String(id))"
        SCNetworking.shared.request(.GET, path: path, params: ["" : ""], completionHandler: { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: error)
            } else {
                let user = SCUser(json: responseObject)
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
            
            let path = "users/\(String(user.id))/"
            SCNetworking.shared.request(.DELETE, path: path, params: ["user" : user.json()], completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    completionHandler(responseObject: nil, error: error)
                } else {
                    let user = SCUser(json: responseObject)
                    completionHandler(responseObject: user, error: nil)
                }
            })
        }
    }
    
    class func toggleBeacon(completionHandler:SCRequestResultsBlock) {
        var on:Bool = SCBeacon().beaconIsOn()
        
        if let user = self.currentUser {
            let path = "users/\(String(user.id))"
            SCNetworking.shared.request(.PUT, path: path, params: ["user" : ["beacon" : on]], completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    completionHandler(responseObject: nil, error: error)
                } else {
                    on = responseObject as Bool
                    SCBeacon().updateBeaconState(on)
                    completionHandler(responseObject: on, error: nil)
                }
            })
        }
    }
    
    class func changeDefaultSocial(type:SocialType, completionHandler:SCRequestResultsBlock) {
        if let user = self.currentUser {
            user.defaultSocialType = type.description()
            
            let path = "users/\(String(user.id))"
            SCNetworking.shared.request(.PUT, path: path, params: ["user" : user.json()], completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    completionHandler(responseObject: nil, error: error)
                } else {
                    var user = SCUser(json: responseObject)
                    completionHandler(responseObject: user, error: nil)
                }
            })
        }
    }
    
    class func create(invisibleArea:SCInvisibleArea!, completionHandler:SCRequestResultsBlock) {
        SCNetworking.shared.request(.POST, path: "invisible_areas", params: ["invisible_area" : invisibleArea.json()], completionHandler: { (responseObject, error) -> Void in
            if error != nil {
                completionHandler(responseObject: nil, error: error)
            } else {
                let user = SCUser(json: responseObject)
                completionHandler(responseObject: user, error: nil)
            }
        })
    }
   
}
