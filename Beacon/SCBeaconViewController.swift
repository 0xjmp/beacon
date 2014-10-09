//
//  SCBeaconViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCBeaconViewController: UIViewController {
    
    var beaconSwitch:UISwitch {
        get {
            var newSwitch = UISwitch()
            newSwitch.onTintColor = UIColor(red: 26.0/255.0, green: 23.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            newSwitch.backgroundColor = UIColor.blackColor()
            newSwitch.layer.cornerRadius = 16.0;
            newSwitch.tintColor = UIColor.blackColor()
            newSwitch.addTarget(self, action: "toggleBeacon", forControlEvents: UIControlEvents.ValueChanged)
            return newSwitch
        }
    }

    var beaconBarButtonItem:UIBarButtonItem {
        get {
            return UIBarButtonItem(customView: self.beaconSwitch)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateSwitch()
        
        self.navigationItem.rightBarButtonItem = self.beaconBarButtonItem
    }
    
    // MARK: - Actions
    
    func updateSwitch() {
        if self.beaconSwitch.on == true {
            self.beaconSwitch.thumbTintColor = UIColor.whiteColor()
        } else {
            self.beaconSwitch.thumbTintColor = UIColor(red: 81.0/255.0, green: 47.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        }
        
        self.beaconSwitch.setNeedsDisplay()
    }
    
    func toggleBeacon() {
        var on:Bool = SCBeacon().beaconIsOn()
        self.beaconSwitch.setOn(on, animated: true)
        
        self.updateSwitch()
        
        SCUser.toggleBeacon { (responseObject, error) -> Void in
            on = responseObject as Bool
            if self.beaconSwitch.on != on {
                self.beaconSwitch.setOn(on, animated: false)
            }
        }
    }

}
