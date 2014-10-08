//
//  SCUser.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/30/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCUser: NSObject {
    
    var id:Int?
    var profileUrl:NSString?
    
    init(json:AnyObject!) {
        self.id = json.valueForKey("id") as? Int
        self.profileUrl = json.valueForKey("url") as? NSString
    }
    
    class var currentUser:SCUser? {
        get {
            return nil
        }
    }
    
    class func getUserProfile(userId:Int!, completionHandler:SCRequestResultsBlock) {
        let path = "users/\(String(userId))"
        SCNetworking.shared.request(.GET, path: path, params: ["" : ""], completionHandler: { (responseObject, error) -> Void in
            if error != nil {
                println("An error occurred \(error)")
                completionHandler(responseObject: nil, error: error)
            } else {
                let user = SCUser(json: responseObject)
                completionHandler(responseObject: user, error: nil)
            }
        })
    }
    
    class func toggleBeacon(completionHandler:SCRequestResultsBlock) {
        var on:Bool = SCBeacon().beaconIsOn()
        if let userId = self.currentUser?.id {
            let path = "users/\(String(userId))/\(!on)"
            SCNetworking.shared.request(.POST, path: path, params: ["" : ""], completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    println("An error occurred: \(error)")
                    completionHandler(responseObject: nil, error: error)
                } else {
                    on = responseObject as Bool
                    SCBeacon().updateBeaconState(on)
                    completionHandler(responseObject: on, error: nil)
                }
            })
        }
    }
   
}
