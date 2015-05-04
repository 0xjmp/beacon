//
//  SCInvisibleArea.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

enum SCZoneType:String {
    case Visible = "Visible"
    case Invisible = "Invisible"
}

struct SCZone {
    let id:Int
    let name:String
    let latitude:Float
    let longitude:Float
    let radius:Int
    var userId:Int
    var visible:Bool
}

import Argo
import Runes

extension SCZone: JSONDecodable {
    
    static func create(id:Int)(name:String)(latitude:Float)(longitude:Float)(radius:Int)(userId:Int)(visible:Bool) -> SCZone {
        return SCZone(id: id, name: name, latitude: latitude, longitude: longitude, radius: radius, userId: userId, visible: visible)
    }
    
    static func decode(d: JSONValue) -> SCZone? {
        return SCZone.create
        <^> d <| "id"
        <*> d <| "name"
        <*> d <| "latitude"
        <*> d <| "longitude"
        <*> d <| "radius"
        <*> d <| "user_id"
        <*> d <| "visible"
    }
}