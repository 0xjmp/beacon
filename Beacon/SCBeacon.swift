//
//  SCBeacon.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCBeacon: SCObject {
    
    private var beaconKey:NSString {
        get {
            return "com.beacon.beacon_key"
        }
    }
    
    func beaconIsOn() -> Bool {
        let beaconState: NSNumber? = NSUserDefaults.standardUserDefaults().objectForKey(self.beaconKey) as? NSNumber
        return beaconState?.integerValue == 1
    }
    
    func updateBeaconState(on:Bool) {
        NSUserDefaults.standardUserDefaults().setObject(NSNumber(bool: on), forKey: self.beaconKey)
    }
    
}
