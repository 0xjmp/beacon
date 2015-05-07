//
//  SCPinControl.swift
//  Beacon
//
//  Created by Jake Peterson on 5/6/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit

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