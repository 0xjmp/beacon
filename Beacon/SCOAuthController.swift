//
//  SCSocialAccountSetupViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

typealias SCOAuthCompletionBlock = () -> Void

protocol SCOAuthDelegate {
    
}

class SCOAuthController: NSObject {
    
    var delegate:SCOAuthDelegate?
    var completionBlock:SCOAuthCompletionBlock?
    
    // MARK: - Getters

    class func isSetup(type:SCSocialType) -> Bool {
        var isSetup = false
        
        if let user = SCUser.currentUser {
            for (var i = 0; i < user.socialUrls?.count; i++) {
                let url: NSString? = user.socialUrls?.objectAtIndex(i) as? NSString
                if (url?.isEqualToString(type.description()) != nil) {
                    isSetup = true
                    i = user.socialUrls!.count
                }
            }
        }
        
        return isSetup
    }
    
    // MARK: - Actions
    
    func attemptOAuth(type:SCSocialType, completion:SCOAuthCompletionBlock) {
        
        self.completionBlock = completion
        
        switch type {
        case .Facebook:
            self.setupFacebook()
            break
            
        case .Twitter:
            self.setupTwitter()
            break
            
        case .Instagram:
            self.setupInstagram()
            break
            
        case .LinkedIn:
            self.setupLinkedIn()
            break
            
        case .Tumblr:
            self.setupTumblr()
            break
        }
    }
    
    private
    
    func setupFacebook() {
        SCFacebookManager.startSession({ (profileUrl) in
            SCUser.update(SCSocialType.Facebook, link:profileUrl, completionHandler:{ (user, error) in
                if error != nil {
                    self.presentError(SCSocialType.Facebook)
                } else if let block = self.completionBlock {
                    block()
                }
            })
        })
    }
    
    func setupTwitter() {
        SCTwitterManager().startSession({ (profileUrl) in
            SCUser.update(SCSocialType.Twitter, link:profileUrl, completionHandler:{ (user, error) in
                if error != nil {
                    self.presentError(SCSocialType.Twitter)
                } else if let block = self.completionBlock {
                    block()
                }
            })
        })
    }
    
    func setupInstagram() {
        SCInstagramManager().startSession({ (profileUrl) in
            SCUser.update(SCSocialType.Instagram, link: profileUrl, completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    self.presentError(SCSocialType.Instagram)
                } else if let block = self.completionBlock {
                    block()
                }
            })
        })
    }
    
    func setupLinkedIn() {
        
    }
    
    func setupTumblr() {
        
    }
    
    func presentError(type:SCSocialType) {
        UIAlertView(title: "\(type.description().capitalizedString) didn't respond.", message: "Please try again in a few minutes", delegate:nil, cancelButtonTitle: "OK").show()
    }
}
