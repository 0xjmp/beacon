//
//  GGViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/12/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.startWatchingForLogoutEvents()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.endWatchingForLogoutEvents()
    }
    
}

extension SCViewController {
    
    func startWatchingForLogoutEvents() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "presentLoginScreen", name: SCUserLoggedOutNotification, object: nil)
    }
    
    func endWatchingForLogoutEvents() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: SCUserLoggedOutNotification, object: nil)
    }
    
    func presentLoginScreen() {
        var viewController = SCEmailViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
}
