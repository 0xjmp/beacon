//
//  SCZonesManager.swift
//  Beacon
//
//  Created by Jake Peterson on 4/16/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit
import Alamofire
import Argo

class SCZonesManager: NSObject {
    
    class func create(name:String, radius:Int, latitude:Float, longitude:Float, completion:SCRequestResultsBlock?) {
        let zone = ["name" : name, "radius" : radius, "latitude" : latitude, "longitude" : longitude]
        SCNetworking.request(Method.POST, path: "zones", params: ["zone" : zone], completion: {(json, error) in
            if error != nil {
                if let block = completion {
                    block(response: nil, error: error)
                }
            } else {
                if let zoneInfo = json as? NSDictionary {
                    let newZone = SCZone.decode(JSONValue.parse(zoneInfo["zone"]!))
                    if let block = completion {
                        block(response: newZone, error: nil)
                    }
                }
            }
        })
    }
   
    class func delete(zone:SCZone, completion:SCRequestResultsBlock) {
        SCNetworking.request(Method.DELETE, path: "zones/\(zone.id)", params: nil, completion: completion)
    }
}
