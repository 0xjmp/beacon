//
//  SCIdentityButton.swift
//  Beacon
//
//  Created by Jake Peterson on 4/15/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit

class SCIdentityButton:UIButton {
    
    var viewControllerDelegate:SCViewControllerProtocol?
    
    var defaultImage:UIImage?
    var clickedImage:UIImage!
    var on:Bool {
        didSet {
            self.update()
        }
    }
    
    var identityType:SCIdentityType {
        didSet {
            self.update()
        }
    }
    
    required init(on: Bool, identityType:SCIdentityType) {
        self.on = on
        self.identityType = identityType
        
        super.init(frame: CGRectZero)
        
        addTarget(self, action: "pressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        update()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let image = defaultImage {
            frame = CGRectMake(0, 0, image.size.width, image.size.height)
        }
    }
    
    func pressed() {
        on = !on
    }
    
    func update() {
        let images:(UIImage, UIImage) = identityType.getImages()
        defaultImage = images.0
        clickedImage = images.1
        
        let image = on ? clickedImage : defaultImage
        setImage(image, forState: UIControlState.Normal)
        
        if on && identityType.getUrl() == nil {
            if let delegate = self.viewControllerDelegate {
                let viewController = SCOAuthViewController(identityType: identityType)
                viewController.delegate = self
                let navController = UINavigationController(rootViewController: viewController)
                delegate.present(self, viewController: navController)
            }
        }
    }
    
}

extension SCIdentityButton: SCOAuthDelegate {
    
    func didFinishAuthentication(authViewController: SCOAuthViewController, user: SCUser) {
        
    }
    
    func didFailAuthentication(authViewController: SCOAuthViewController, error: NSError) {
        on = false
    }
    
}
