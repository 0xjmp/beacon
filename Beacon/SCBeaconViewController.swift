//
//  SCBeaconViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCBeaconViewController: UIViewController {
    
    var beaconSwitch:UISwitch!
    var beaconBarButtonItem:UIBarButtonItem {
        get {
            let padding:CGFloat = 25.0
            var customView = UIView(frame: CGRectMake(0, 0, self.beaconSwitch.bounds.size.width, self.beaconSwitch.bounds.size.height + padding))
            
            if self.beaconSwitch.superview != nil {
                self.beaconSwitch.removeFromSuperview()
            }
            customView.addSubview(self.beaconSwitch)
            
            self.beaconSwitch.frame = CGRectMake(0, customView.bounds.size.height - self.beaconSwitch.bounds.size.height, self.beaconSwitch.bounds.size.width, self.beaconSwitch.bounds.size.height)
            
            return UIBarButtonItem(customView: customView)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.beaconSwitch = UISwitch()
        self.beaconSwitch.onTintColor = UIColor(red: 26.0/255.0, green: 23.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.beaconSwitch.backgroundColor = UIColor.blackColor()
        self.beaconSwitch.layer.cornerRadius = 16.0;
        self.beaconSwitch.tintColor = UIColor.blackColor()
        self.beaconSwitch.addTarget(self, action: "toggleBeacon", forControlEvents: UIControlEvents.ValueChanged)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//        var on:Bool = SCBeacon().beaconIsOn()
//        self.beaconSwitch.setOn(on, animated: true)
        
        self.updateSwitch()
        
//        SCUser.toggleBeacon { (responseObject, error) -> Void in
//            on = responseObject as Bool
//            if self.beaconSwitch.on != on {
//                self.beaconSwitch.setOn(on, animated: false)
//            }
//        }
    }

}
