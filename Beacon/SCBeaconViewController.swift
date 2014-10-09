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
            newSwitch.offImage = UIImage(named: "off_switch")
            newSwitch.onImage = UIImage(named: "on_switch")
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
        
        self.navigationItem.rightBarButtonItem = self.beaconBarButtonItem
    }
    
    // MARK: - Actions
    
    func toggleBeacon() {
        var on:Bool = SCBeacon().beaconIsOn()
        self.beaconSwitch.setOn(on, animated: true)
        
        SCUser.toggleBeacon { (responseObject, error) -> Void in
            on = responseObject as Bool
            if self.beaconSwitch.on != on {
                self.beaconSwitch.setOn(on, animated: false)
            }
        }
    }

}
