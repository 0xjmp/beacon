//
//  SCNewInvisibleAreaView.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import MapKit

protocol SCNewZoneDelegate {
    
    func didFinishCreatingZone()
    
}

class SCNewZoneButton:UIButton {
    var plusImageView:UIImageView!
    var plusImageContainerView:UIView!
    var myTitleLabel:UILabel!
    var closeLabel:UILabel!
    var zoneType:SCZoneType!
    var defaultTitleText:String {
        get {
            return "New \(zoneType.rawValue) Zone"
        }
    }
    var active:Bool!
    
    required init(frame:CGRect, zoneType:SCZoneType!) {
        super.init(frame: frame)
        
        self.zoneType = zoneType
        
        let image = UIImage(named: "pluswhite")!
        self.plusImageView = UIImageView(image: image)
        self.plusImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.plusImageView.userInteractionEnabled = false
        self.plusImageView.contentMode = UIViewContentMode.Center

        self.plusImageContainerView = UIView(frame: CGRectZero)
        self.plusImageContainerView.backgroundColor = UIColor.clearColor()
        self.plusImageContainerView.addSubview(self.plusImageView)
        self.addSubview(self.plusImageContainerView)
        
        let fontSize:CGFloat = 22.0
        
        self.myTitleLabel = UILabel()
        self.myTitleLabel.font = SCTheme.primaryFont(fontSize)
        self.myTitleLabel.textColor = SCTheme.primaryTextColor
        self.myTitleLabel.text = defaultTitleText
        self.myTitleLabel.userInteractionEnabled = false
        self.addSubview(self.myTitleLabel)
        
        self.closeLabel = UILabel()
        self.closeLabel.font = SCTheme.primaryFont(fontSize)
        self.closeLabel.textColor = SCTheme.primaryTextColor
        self.closeLabel.text = "Cancel"
        self.closeLabel.userInteractionEnabled = false
        self.closeLabel.layer.opacity = 0.0
        self.addSubview(self.closeLabel)
        
        self.active = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin:CGFloat = 16
        
        self.plusImageContainerView.frame = CGRectMake(margin, 0, self.plusImageView.bounds.size.width, self.plusImageView.bounds.size.height)
        var center = self.plusImageContainerView.center
        center.y = self.bounds.size.height / 2
        self.plusImageContainerView.center = center
        
        var frame = self.myTitleLabel.frame
        frame.origin.x = CGRectGetMaxX(self.plusImageContainerView.frame) + 10
        frame.size.width = self.bounds.size.width - CGRectGetMinX(frame)
        frame.size.height = self.plusImageContainerView.bounds.size.height
        self.myTitleLabel.frame = frame
        center = self.myTitleLabel.center
        center.y = self.bounds.size.height / 2
        self.myTitleLabel.center = center
        
        self.closeLabel.frame = self.myTitleLabel.frame
    }
    
    func openZone(completion:((Bool) -> Void)?) {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.plusImageView.transform = CGAffineTransformMakeRotation(-0.8)
            self.myTitleLabel.layer.opacity = 0.0
            self.layer.opacity = 1.0
            self.closeLabel.layer.opacity = 1.0
        }, completion: completion)
    }
    
    func closeZone(completion:((Bool) -> Void)?) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.plusImageView.transform = CGAffineTransformMakeRotation(0)
            
            self.layer.opacity = 0.0
            self.closeLabel.layer.opacity = 0.0
            
            self.myTitleLabel.layer.opacity = 1.0
        }, completion:completion)
    }
    
    func toggleZone(completion:((Bool) -> Void)?) {
        if active == true {
            closeZone(completion)
        } else {
            openZone(completion)
        }
        
        active = !active
    }
}