//
//  SCNewInvisibleAreaView.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import MapKit

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
}

protocol SCNewZoneDelegate {
    func didFinishCreatingZone()
}


class SPinControl: UIControl {
    
    var dottedLine:CAShapeLayer!
    var track:CAShapeLayer!
    var currentRadius:CGFloat
    var minimumRadius:CGFloat
    var maximumRadius:CGFloat
    
    override init(frame:CGRect) {
        self.minimumRadius = 100.0
        self.maximumRadius = 5000.0
        self.currentRadius = 500.0
        
        super.init(frame: frame)
        
        self.hidden = true
    
        self.dottedLine = CAShapeLayer()
        self.dottedLine.position = self.center
        self.dottedLine.fillColor = UIColor.clearColor().CGColor
        self.dottedLine.strokeColor = UIColor.blackColor().CGColor
        self.dottedLine.lineWidth = 2.0
        self.dottedLine.lineJoin = kCALineJoinRound
        self.dottedLine.lineDashPattern = [NSNumber(int: 5)]
        self.layer.addSublayer(self.dottedLine)
        
        self.track = CAShapeLayer()
        self.track.position = self.center
        self.track.fillColor = UIColor.blackColor().CGColor
        self.track.strokeColor = UIColor.blackColor().CGColor
        self.track.lineWidth = 1.0
        self.track.lineJoin = kCALineJoinRound
        self.layer.addSublayer(self.track)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let trackSize = CGFloat(20.0)
        self.track.frame = CGRectMake(self.bounds.size.width - trackSize * 1.5, (self.bounds.size.height - trackSize) / 2, trackSize, trackSize)
        self.track.path = UIBezierPath(roundedRect: self.track.bounds, cornerRadius: self.track.bounds.size.width / 2).CGPath
        
        self.dottedLine.frame = CGRectMake(0, self.bounds.size.height / 2, CGRectGetMinX(self.track.frame), self.dottedLine.lineWidth)
        var path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, self.dottedLine.bounds.size.width, 0)
        self.dottedLine.path = path
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        self.sendActionsForControlEvents(UIControlEvents.TouchDragExit)
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let prevLocation = touch.previousLocationInView(touch.view)
        let location = touch.locationInView(touch.view)
        let xChange = location.x - prevLocation.x
        self.currentRadius += xChange * 4
        
        // Guard rails for min/max values of scale
        if self.currentRadius < self.minimumRadius {
            self.currentRadius = self.minimumRadius
        } else if self.currentRadius > self.maximumRadius {
            self.currentRadius = self.maximumRadius
        }
        
        self.sendActionsForControlEvents(.ValueChanged)
        
        return super.continueTrackingWithTouch(touch, withEvent: event)
    }
    
    // MARK: - Actions
    
    func resetAnimation() {
        self.hidden = true
    }
    
    func animate() {
        self.hidden = false
    }
}