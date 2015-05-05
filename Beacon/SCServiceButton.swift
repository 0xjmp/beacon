//
//  SCServiceButton.swift
//  Beacon
//
//  Created by Jake Peterson on 4/15/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit

class SCServiceButton:UIButton {
    
    var defaultImage:UIImage
    var clickedImage:UIImage
    var on:Bool {
        didSet {
            let image = self.on ? self.clickedImage : self.defaultImage
            self.setImage(image, forState: UIControlState.Normal)
        }
    }
    
    required init(on: Bool, defaultImage:UIImage, clickedImage:UIImage) {
        self.on = on
        self.defaultImage = defaultImage
        self.clickedImage = clickedImage
        
        var image = defaultImage
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
