//
//  SCInstagramManager.swift
//  Beacon
//
//  Created by Jake Peterson on 10/17/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCInstagramManager: NSObject {
   
    var clientId = "3e9dcad4b66a469e9ba7bbe019919d7d"
    var clientSecret = "58dd170fded5461a9178cde7f2630a87"
    
    func startSession(completion:(NSString? -> Void)) {
        if let viewController = SCViewController.getTopViewController() {
            let instaController = InstagramSimpleOAuthViewController(clientID: self.clientId, clientSecret: self.clientSecret, callbackURL: NSURL(string: "beacon://"), completion: { (response, error) -> Void in
                println("done: \(response) \(error)")
            })
            let navController = UINavigationController(rootViewController: instaController)
            viewController.presentViewController(navController, animated: true, completion: nil)
        }
    }
}
