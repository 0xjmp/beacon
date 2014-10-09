//
//  SCObject.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCObject: NSObject {
   
    func json() -> NSData {
        var error:NSError?
        let data = NSJSONSerialization.dataWithJSONObject(self, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        assert(error == nil, "Serious error")
        return data!
    }
    
}
