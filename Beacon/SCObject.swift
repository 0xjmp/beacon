//
//  SCObject.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCObject: NSObject {
   
    func toJSON() -> NSString {
        var error:NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(self.toDictionary(), options: NSJSONWritingOptions.allZeros, error: &error)
        if error != nil { fatalError("Serious error") }
        return NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
    }
    
    func toDictionary() -> NSDictionary {
        return self.dictionaryWithValuesForKeys(self.dynamicType.jsonMapping().allKeys)
    }
    
    class func jsonMapping() -> NSDictionary {
        fatalError("Unimplemented -jsonMapping")
        return NSDictionary()
    }
    
    init(json:NSDictionary?) {
        super.init()
        self.dynamicType.jsonMapping().enumerateKeysAndObjectsUsingBlock { (key, value, stop) -> Void in
            if value != nil {
                if let jsonValue:AnyObject = json?.valueForKey(key as String) {
                    self.setValue(jsonValue, forKey: value as String)
                }
            }
        }
    }
    
}