//
//  SCObject.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCObject: NSObject {
   
    func json(myClass:AnyClass) -> NSDictionary {
        var dict = NSMutableDictionary()
        
        var count:UInt32 = 0
        var properties:UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(myClass, &count)
        for (var i = 0; i < Int(count); i++) {
            var key = NSString.stringWithUTF8String(property_getName(properties[i]))
            if let value:AnyObject = self.valueForKey(key) {
                dict.setObject(value, forKey: key)
            }
        }
        
        free(properties)
        
        return NSDictionary(dictionary: dict)
    }
    
}
