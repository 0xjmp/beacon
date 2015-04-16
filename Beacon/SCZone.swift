//
//  SCInvisibleArea.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

struct SCZone {
    let id:Int
    let name:String
    let latitude:Float
    let longitude:Float
    let radius:Int
    var userId:Int
}

extension SCZone: JSONDecodable {
    
    static func create(id:Int)(name:String)(latitude:Float)(longitude:Float)(radius:Int)(userId:Int) -> SCZone {
        return SCZone(id: id, name: name, latitude: latitude, longitude: longitude, radius: radius, userId: userId)
    }
    
    static func decode(json: JSON) -> SCZone? {
        return _JSONParse(json) >>- { (d: JSONObject) in
            SCZone.create
                <^> d <| "id"
                <*> d <| "name"
                <*> d <| "latitude"
                <*> d <| "longitude"
                <*> d <| "radius"
                <*> d <| "user_id"
        }
    }
}