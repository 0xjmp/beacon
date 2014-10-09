//
//  SCInvisibleArea.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCInvisibleArea: NSObject {
   
    var name:NSString?
    var location:NSString?
    
    init(json:NSDictionary) {
        super.init()
        self.name = json.valueForKey("name") as NSString?
        self.location = json.valueForKey("location") as NSString?
    }
    
}
