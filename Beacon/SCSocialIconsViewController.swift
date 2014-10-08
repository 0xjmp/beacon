//
//  SCSocialIconsViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/8/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

enum SocialType {
    case Facebook
    case Twitter
    case Instagram
    case LinkedIn
    case Tumblr
}

class SCSwitchButton:UIButton {
    
    var defaultImage:UIImage!
    var clickedImage:UIImage!
    var on:Bool {
        didSet {
            let image = self.on ? self.clickedImage : self.defaultImage
            self.setImage(image, forState: UIControlState.Normal)
        }
    }
    
    required init(on: Bool, defaultImage:UIImage!, clickedImage:UIImage!) {
        self.defaultImage = defaultImage
        self.clickedImage = clickedImage
        self.on = on
    
        var image = self.defaultImage
        super.init(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        
        image = self.on ? self.clickedImage : self.defaultImage
        
        self.addTarget(self, action: "pressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.setImage(image, forState: UIControlState.Normal)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pressed() {
        self.on = !self.on
    }
    
}

class SCSocialIconsViewController: UIViewController {
    
    var facebookButton:UIButton! {
        get {
            let facebookImage = UIImage(named: "facebook_icon")
            let facebookClickedImage = UIImage(named: "facebook_clicked_icon")
            return SCSwitchButton(on: false, defaultImage: facebookImage, clickedImage: facebookClickedImage)
        }
    }
    
    var twitterButton:UIButton! {
        get {
            let twitterImage = UIImage(named: "twitter_icon")
            let twitterClickedImage = UIImage(named: "twitter_clicked_icon")
            return SCSwitchButton(on: false, defaultImage: twitterImage, clickedImage: twitterClickedImage)
        }
    }
    
    var instagramButton:UIButton! {
        get {
            let instagramImage = UIImage(named: "instagram_icon")
            let instagramClickedImage = UIImage(named: "instagram_clicked_icon")
            return SCSwitchButton(on: false, defaultImage: instagramImage, clickedImage: instagramClickedImage)
        }
    }
    
    var linkedinButton:UIButton! {
        get {
            let linkedInImage = UIImage(named: "linkedIn_icon")
            let linkedInClickedImage = UIImage(named: "linkedIn_clicked_icon")
            return SCSwitchButton(on: false, defaultImage: linkedInImage, clickedImage: linkedInClickedImage)
        }
    }
    
    var tumblrButton:UIButton! {
        get {
            let tumblrImage = UIImage(named: "tumblr_icon")
            let tumblrClickedImage = UIImage(named: "tumblr_clicked_icon")
            return SCSwitchButton(on: false, defaultImage: tumblrImage, clickedImage: tumblrClickedImage)
        }
    }
    
    var socialButtons:NSArray {
        get {
            return [facebookButton, twitterButton, instagramButton, linkedinButton, tumblrButton]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: Actions
    
    func clearButtons() {
        for button in self.socialButtons {
            if let actionButton = button as? SCSwitchButton {
                actionButton.on = false
            }
        }
    }
    
    func selectButton(index:Int!) {
        let button:SCSwitchButton = self.socialButtons.objectAtIndex(index) as SCSwitchButton
        button.pressed()
    }

}
