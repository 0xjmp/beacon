//
//  SCSocialIconsViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCSwitchButton:UIButton {
    
    var socialType:SCSocialType!
    var defaultImage:UIImage!
    var clickedImage:UIImage!
    var on:Bool {
        didSet {
            let image = self.on ? self.clickedImage : self.defaultImage
            self.setImage(image, forState: UIControlState.Normal)
        }
    }
    
    required init(on: Bool, defaultImage:UIImage!, clickedImage:UIImage!, type:SCSocialType!) {
        self.defaultImage = defaultImage
        self.clickedImage = clickedImage
        self.on = on
        self.socialType = type
    
        var image = self.defaultImage
        super.init(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        
        image = self.on ? self.clickedImage : self.defaultImage
        
        self.setImage(image, forState: UIControlState.Normal)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pressed() {
        self.on = !self.on
    }
    
}

class SCSocialIconsToolbar: UIToolbar {
    
    var facebookButton:SCSwitchButton! {
        get {
            let facebookImage = UIImage(named: "facebookoff")
            let facebookClickedImage = UIImage(named: "facebookon")
            return SCSwitchButton(on: false, defaultImage: facebookImage, clickedImage: facebookClickedImage, type:SCSocialTypeFacebook)
        }
    }
    
    var twitterButton:SCSwitchButton! {
        get {
            let twitterImage = UIImage(named: "twitteroff")
            let twitterClickedImage = UIImage(named: "twitteron")
            return SCSwitchButton(on: false, defaultImage: twitterImage, clickedImage: twitterClickedImage, type:SCSocialTypeTwitter)
        }
    }
    
    var instagramButton:SCSwitchButton! {
        get {
            let instagramImage = UIImage(named: "instagramoff")
            let instagramClickedImage = UIImage(named: "instagramon")
            return SCSwitchButton(on: false, defaultImage: instagramImage, clickedImage: instagramClickedImage, type:SCSocialTypeInstagram)
        }
    }
    
    var linkedinButton:SCSwitchButton! {
        get {
            let linkedInImage = UIImage(named: "linkedinoff")
            let linkedInClickedImage = UIImage(named: "linkedinon")
            return SCSwitchButton(on: false, defaultImage: linkedInImage, clickedImage: linkedInClickedImage, type:SCSocialTypeLinkedIn)
        }
    }
    
    var tumblrButton:SCSwitchButton! {
        get {
            let tumblrImage = UIImage(named: "tumblroff")
            let tumblrClickedImage = UIImage(named: "tumblron")
            return SCSwitchButton(on: false, defaultImage: tumblrImage, clickedImage: tumblrClickedImage, type:SCSocialTypeTumblr)
        }
    }
    
    var defaultSeparator:UIBarButtonItem! {
        get {
            var barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
            barButton.width = 12.0;
            return barButton
        }
    }
    
    var socialButtons:NSArray {
        get {
            return [facebookButton, twitterButton, instagramButton, linkedinButton, tumblrButton]
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        self.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.TopAttached, barMetrics: UIBarMetrics.Default)
        self.clipsToBounds = true

        var barButtons = NSMutableArray()
        for (var i = 0; i < self.socialButtons.count; i++) {
            let button:AnyObject = self.socialButtons.objectAtIndex(i)
            button.addTarget(self, action: "press:", forControlEvents: UIControlEvents.TouchUpInside)
            
            if i != 0 {
                // Put a spacer in-between each button for customizability
                barButtons.addObject(self.defaultSeparator)
            }
            
            let barButtonItem = UIBarButtonItem(customView: button as UIView)
            barButtons.addObject(barButtonItem)
        }
        self.setItems(barButtons, animated: false)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    func clearButtons() {
        for button in self.socialButtons {
            if let actionButton = button as? SCSwitchButton {
                actionButton.on = false
            }
        }
    }
    
    func press(button:SCSwitchButton!) {
        var block:(Void -> Void) = {
            if button.on == false {
                self.clearButtons()
            }

            button.pressed()
            println(button.on)
        }
        
        if SSocialManager.isSetup(button.socialType) {
            block()
        } else {
            SSocialManager.singleton().attemptOAuth(button.socialType, completionBlock: { (success) -> Void in
                SCUser.getProfile({ (responseObject, error) -> Void in
                    block()
                })
            })
        }
    }

}
