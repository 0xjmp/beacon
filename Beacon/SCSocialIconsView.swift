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
    
    func description() -> NSString {
        switch self {
        case .Facebook:
            return "facebook"
        case .Twitter:
            return "twitter"
        case .Instagram:
            return "instagram"
        case .LinkedIn:
            return "linkedIn"
        case .Tumblr:
            return "tumblr"
        }
    }
}

class SCSwitchButton:UIButton {
    
    var socialType:SocialType!
    var defaultImage:UIImage!
    var clickedImage:UIImage!
    var on:Bool {
        didSet {
            let image = self.on ? self.clickedImage : self.defaultImage
            self.setImage(image, forState: UIControlState.Normal)
        }
    }
    
    required init(on: Bool, defaultImage:UIImage!, clickedImage:UIImage!, type:SocialType!) {
        self.defaultImage = defaultImage
        self.clickedImage = clickedImage
        self.on = on
        self.socialType = type
    
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

class SCSocialIconsView: UIView {
    
    var facebookButton:SCSwitchButton! {
        get {
            let facebookImage = UIImage(named: "facebookoff")
            let facebookClickedImage = UIImage(named: "facebookon")
            return SCSwitchButton(on: false, defaultImage: facebookImage, clickedImage: facebookClickedImage, type:SocialType.Facebook)
        }
    }
    
    var twitterButton:SCSwitchButton! {
        get {
            let twitterImage = UIImage(named: "twitteroff")
            let twitterClickedImage = UIImage(named: "twitteron")
            return SCSwitchButton(on: false, defaultImage: twitterImage, clickedImage: twitterClickedImage, type:SocialType.Twitter)
        }
    }
    
    var instagramButton:SCSwitchButton! {
        get {
            let instagramImage = UIImage(named: "instagramoff")
            let instagramClickedImage = UIImage(named: "instagramon")
            return SCSwitchButton(on: false, defaultImage: instagramImage, clickedImage: instagramClickedImage, type:SocialType.Instagram)
        }
    }
    
    var linkedinButton:SCSwitchButton! {
        get {
            let linkedInImage = UIImage(named: "linkedinoff")
            let linkedInClickedImage = UIImage(named: "linkedinon")
            return SCSwitchButton(on: false, defaultImage: linkedInImage, clickedImage: linkedInClickedImage, type:SocialType.LinkedIn)
        }
    }
    
    var tumblrButton:SCSwitchButton! {
        get {
            let tumblrImage = UIImage(named: "tumblroff")
            let tumblrClickedImage = UIImage(named: "tumblron")
            return SCSwitchButton(on: false, defaultImage: tumblrImage, clickedImage: tumblrClickedImage, type:SocialType.Tumblr)
        }
    }
    
    var socialButtons:NSArray {
        get {
            return [facebookButton, twitterButton, instagramButton, linkedinButton, tumblrButton]
        }
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        
        self.view.frame = CGRectMake(0, 0, 0, 50)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in self.socialButtons {
            if let actionButton = button as? SCSwitchButton {
                actionButton.addTarget(self, action: "pressWithButton:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(actionButton)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // We're assuming that each icon is an equal shape
        
        if let buttonRef = self.socialButtons.firstObject as? SCSwitchButton {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.bounds.size.width, buttonRef.bounds.size.height)
        }
        
        
        for (var i = 0; i < self.socialButtons.count; i++) {
            if let actionButton = self.socialButtons[i] as? SCSwitchButton {
                let margin:CGFloat = 10.0
                let x:CGFloat = ((self.view.bounds.size.width - (CGFloat(self.socialButtons.count) * (actionButton.bounds.size.width + margin) - margin)) / CGFloat(2)) + (CGFloat(i) * actionButton.bounds.size.width + margin)
                actionButton.frame = CGRectMake(x, margin, actionButton.bounds.size.width, actionButton.bounds.size.height)
            }
        }
    }
    
    // MARK: Actions
    
    func clearButtons() {
        for button in self.socialButtons {
            if let actionButton = button as? SCSwitchButton {
                actionButton.on = false
            }
        }
    }
    
    func updateButton(index:Int) {
        // Call networking functions (or others similar) that 
        // represent this button.
    }
    
    func press(button:SCSwitchButton!) {
        if button.on == true {
            button.pressed()
        } else {
            self.clearButtons()
            button.pressed()
        }
        
        let index = self.socialButtons.indexOfObject(button)
        assert(index != NSNotFound, "Serious error with index")
        self.updateButton(index)
    }

}
