//
//  SCInvisibleArea.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import Argo

class SCInvisibleArea {
   
    var id:NSNumber!
    var name:NSString!
    var address:NSString!
    var latitude:NSNumber!
    var longitude:NSNumber!
    var radius:NSNumber!
    var userId:NSNumber!
    
}

extension SCInvisibleArea: JSONDecodable {
    
    class func create(id: NSNumber!)(name: NSString!)(address: NSString!)(latitude: NSNumber!)(longitude: NSNumber!)(radius: NSNumber!)(user: SCUser!) {
        return SCInvisibleArea(id: id, name: name, address: address, latitude: latitude, longitude: longitude, radius: radius, user: user)
    }
    
    class func decode(json: JSON) -> SCInvisibleArea? {
        return _JSONParse(json) >>- { d in
            SCInvisibleArea.create
                <^> d <| "id"
                <*> d <| "name"
                <*> d <| "address"
                <*> d <| "latitude"
                <*> d <| "longitude"
                <*> d <| "radius"
                <*> d <| "user" <| "id"
        }
    }
    
}
