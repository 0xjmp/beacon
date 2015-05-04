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
    
    func url(serviceType:SCOAuthService) {
        // TODO: add functionality in back-end for urls
    }
}

extension SCUser: JSONDecodable {
    
    static func create(id:Int)(zones:[SCZone]?)(visible:Bool) -> SCUser {
        return SCUser(id: id, zones: zones, visible: visible)
    }
    
    static func decode(d: JSONValue) -> SCUser? {
        return SCUser.create
        <^> d <| "id"
        <*> d <||? "zones"
        <*> d <| "visible"
    }
}
