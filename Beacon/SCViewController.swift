//
//  GGViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/12/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCViewController: UIViewController {
    
    lazy var beaconSwitch:UISwitch = { [unowned self] in
        var beaconSwitch = UISwitch()
        beaconSwitch.onTintColor = UIColor(red: 26.0/255.0, green: 23.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        beaconSwitch.backgroundColor = UIColor.blackColor()
        beaconSwitch.layer.cornerRadius = 16.0;
        beaconSwitch.tintColor = UIColor.blackColor()
        beaconSwitch.thumbTintColor = UIColor.whiteColor()
        return beaconSwitch
    }()
    
    lazy var beaconBarButtonItem:UIBarButtonItem = { [unowned self] in
        let padding:CGFloat = 25.0
        var customView = UIView(frame: CGRectMake(0, 0, self.beaconSwitch.bounds.size.width, self.beaconSwitch.bounds.size.height + padding))
        
        if self.beaconSwitch.superview != nil {
            self.beaconSwitch.removeFromSuperview()
        }
        customView.addSubview(self.beaconSwitch)
        
        self.beaconSwitch.frame = CGRectMake(0, customView.bounds.size.height - self.beaconSwitch.bounds.size.height, self.beaconSwitch.bounds.size.width, self.beaconSwitch.bounds.size.height)
        
        return UIBarButtonItem(customView: customView)
    }()
    
    lazy var logoBarButtonItem:UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(customView: SCTheme.logoImageView)
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.startWatchingForLogoutEvents()
        
        beaconSwitch.addTarget(self, action: "toggleBeacon", forControlEvents: UIControlEvents.ValueChanged)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.leftBarButtonItem = logoBarButtonItem
        navigationItem.rightBarButtonItem = beaconBarButtonItem
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.endWatchingForLogoutEvents()
    }
    
    // MARK: - Getters
    
    class func getTopViewController() -> UIViewController? {
        if let navigationController:UINavigationController = UIApplication.sharedApplication().keyWindow!.rootViewController as? UINavigationController {
            if navigationController.isKindOfClass(UINavigationController) {
                return navigationController.topViewController
            } else if navigationController.isKindOfClass(UIViewController) {
                return navigationController
            }
        }
        
        return nil
    }
    
    // MARK: - Actions
    
    func toggleBeacon() {
        //        var on:Bool = SCBeacon().beaconIsOn()
        //        self.beaconSwitch.setOn(on, animated: true)
        
        //        SCUser.toggleBeacon { (responseObject, error) -> Void in
        //            on = responseObject as Bool
        //            if self.beaconSwitch.on != on {
        //                self.beaconSwitch.setOn(on, animated: false)
        //            }
        //        }
    }
}

extension SCViewController {
    
    func startWatchingForLogoutEvents() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "presentLoginScreen", name: SCUserLoggedOutNotification, object: nil)
    }
    
    func endWatchingForLogoutEvents() {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: SCUserLoggedOutNotification, object: nil)
    }
    
    func presentLoginScreen() {
        var viewController = SCEmailViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
}
