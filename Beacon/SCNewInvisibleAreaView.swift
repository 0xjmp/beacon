//
//  SCNewInvisibleAreaView.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import MapKit

class SCInvisibleAreaButton:UIButton {
    var plusImageView:UIImageView!
    var plusImageContainerView:UIView!
    var myTitleLabel:UILabel!
    var closeLabel:UILabel!
    var defaultTitleText = "New Invisible Area"
    var active:Bool!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        let image = UIImage(named: "pluswhite")!
        self.plusImageView = UIImageView(image: image)
        self.plusImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.plusImageView.userInteractionEnabled = false
        self.plusImageView.contentMode = UIViewContentMode.Center

        self.plusImageContainerView = UIView(frame: CGRectZero)
        self.plusImageContainerView.backgroundColor = UIColor.clearColor()
        self.plusImageContainerView.addSubview(self.plusImageView)
        self.addSubview(self.plusImageContainerView)
        
        self.myTitleLabel = UILabel()
        self.myTitleLabel.font = SCTheme.primaryFont(27)
        self.myTitleLabel.textColor = SCTheme.primaryTextColor
        self.myTitleLabel.text = self.defaultTitleText
        self.myTitleLabel.userInteractionEnabled = false
        self.addSubview(self.myTitleLabel)
        
        self.closeLabel = UILabel()
        self.closeLabel.font = SCTheme.primaryFont(27)
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

protocol SCNewInvisibleAreaDelegate {
    func didCreateNew(invisibleArea:SCInvisibleArea!)
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
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        println("begin tracking")
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        self.sendActionsForControlEvents(UIControlEvents.TouchDragExit)
        
        println("end tracking")
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        println("continue tracking")
        
        let prevLocation = touch.previousLocationInView(touch.view)
        let location = touch.locationInView(touch.view)
        let xChange = location.x - prevLocation.x
        self.currentRadius += xChange
        
        // Guard rails for min/max values of scale
        if self.currentRadius < self.minimumRadius {
            self.currentRadius = self.minimumRadius
        } else if self.currentRadius > self.maximumRadius {
            self.currentRadius = self.maximumRadius
        }
        
        self.sendActionsForControlEvents(.ValueChanged)
        
        return super.continueTrackingWithTouch(touch, withEvent: event)
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        println("cancelTracking")
        super.cancelTrackingWithEvent(event)
    }
    
    // MARK: - Actions
    
    func resetAnimation() {
        self.hidden = true
    }
    
    func animate() {
        self.hidden = false
    }
}

class SCNewInvisibleAreaView: UIToolbar {

    var nameField:UITextField!
    var mapView:MKMapView!
    var addButton:UIButton!
    var actionDelegate:SCNewInvisibleAreaDelegate?
    var locationManager:CLLocationManager!
    var userLocationAnnotation:MKPointAnnotation?
    var pinControl:SPinControl!
    var circle:MKCircle?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.barTintColor = UIColor.blackColor()
        
        self.nameField = UITextField()
        self.nameField.textColor = UIColor.blackColor()
        var gray:CGFloat = 200.0/255.0
        self.nameField.backgroundColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.nameField.layer.cornerRadius = 5.0
        self.nameField.attributedPlaceholder = NSAttributedString(string: "Name goes here...", attributes: [ NSForegroundColorAttributeName : UIColor.blackColor() ])
        self.nameField.font = SCTheme.primaryFont(25)
        self.nameField.layer.borderColor = UIColor.whiteColor().CGColor
        self.nameField.layer.borderWidth = 1.0
        self.nameField.leftViewMode = UITextFieldViewMode.Always
        let leftView = UIView(frame: CGRectMake(0, 0, 15, 0))
        self.nameField.leftView = leftView
        self.addSubview(self.nameField)
        
        self.locationManager = CLLocationManager()
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        self.mapView = MKMapView()
        self.mapView.opaque = true
        self.mapView.layer.cornerRadius = 5
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true
        self.mapView.rotateEnabled = false
        self.addSubview(self.mapView)
        
        self.pinControl = SPinControl(frame: CGRectMake(0, 0, 100, 45))
        self.pinControl.addTarget(self, action: "pinDragged:", forControlEvents: UIControlEvents.ValueChanged)
        self.pinControl.addTarget(self, action: "resetPin:", forControlEvents: UIControlEvents.TouchDragExit)
        self.mapView.addSubview(self.pinControl)
        
        let image = UIImage(named: "overlaybutton")!
        self.addButton = UIButton()
        self.addButton.setBackgroundImage(image, forState: UIControlState.Normal)
        self.addButton.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.addButton.setTitle("Add Invisible Area", forState: UIControlState.Normal)
        self.addButton.titleLabel?.font = SCTheme.primaryFont(25)
        self.addButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.addButton.addTarget(self, action: "createNewArea", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.addButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin:CGFloat = 25.0
        
        self.nameField.frame = CGRectMake(margin, margin, self.bounds.size.width - (margin * 2), 55)
        self.mapView.frame = CGRectMake(margin, CGRectGetMaxY(self.nameField.frame) + 10, self.nameField.bounds.size.width, 200)
        self.pinControl.frame = CGRectMake(self.pinControl.frame.origin.x, self.pinControl.frame.origin.y, self.pinControl.currentRadius / 5 + 20, 45)
        self.addButton.frame = CGRectMake(self.nameField.frame.origin.x, CGRectGetMaxY(self.mapView.frame) + 10, self.nameField.bounds.size.width, 50)
        
        self.startUpdatingLocation()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func createNewArea() {
        if let actionDelegate = self.actionDelegate {
            if self.nameField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                var invisibleArea = SCInvisibleArea(json: nil)
                invisibleArea.location = self.nameField.text
                actionDelegate.didCreateNew(invisibleArea)
            } else {
                var alertView = UIAlertView(title: "Please fill in the required fields", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() == true {
            if self.locationManager.location == nil {
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func clearMapView(mapView:MKMapView!) {
        if mapView.overlays != nil {
            for overlay in mapView.overlays {
                mapView.removeOverlay(overlay as MKOverlay)
            }
        }
        
        if mapView.annotations != nil {
            for annotation in mapView.annotations {
                if annotation as? MKPointAnnotation != self.userLocationAnnotation {
                    mapView.removeAnnotation(annotation as MKAnnotation)
                }
            }
        }
    }
    
    func pinDragged(pin:SPinControl!) {
        self.mapView.delegate.mapView!(self.mapView, regionDidChangeAnimated: true)
    }
    
    func resetPin(pin:UIControl!) {
        
    }

}

extension SCNewInvisibleAreaView: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKPointAnnotation) {
            let reuse = NSStringFromClass(MKPointAnnotation)
            var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(reuse) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuse)
            }
            
            annotationView!.pinColor = MKPinAnnotationColor.Red
            
            return annotationView!
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        if let annotationView = mapView.viewForAnnotation(mapView.userLocation) {
            annotationView.hidden = true
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if userLocation != nil {
            if self.circle == nil {
                self.circle = MKCircle(centerCoordinate: userLocation.coordinate, radius: CLLocationDistance(self.pinControl.currentRadius))
                self.mapView.addOverlay(self.circle)
                
                var region = MKCoordinateRegionForMapRect(self.circle!.boundingMapRect)
                region = mapView.regionThatFits(region)
                mapView.setRegion(region, animated: false)
                
                self.pinControl.animate()
            }
        }
    }
    
    func mapView(mapView: MKMapView!, didFailToLocateUserWithError error: NSError!) {
        println("An error occurred while locating the current user: \(error)")
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay.isKindOfClass(MKCircle) {
            var circleView = MKCircleRenderer(overlay: overlay)
            let color:UIColor = SCTheme.beaconPurple
            circleView.strokeColor = color
            circleView.fillColor = color.colorWithAlphaComponent(0.4)
            circleView.lineWidth = 3.0
            return circleView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        self.pinControl.resetAnimation()
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        if let location = self.locationManager.location {
            if self.userLocationAnnotation == nil {
                self.userLocationAnnotation = MKPointAnnotation()
                self.userLocationAnnotation!.setCoordinate(location.coordinate)
                mapView.addAnnotation(self.userLocationAnnotation!)
            }
            
            let userPoint = self.mapView.convertCoordinate(location.coordinate, toPointToView: self.mapView)
            self.pinControl.frame = CGRectMake(userPoint.x, userPoint.y - (self.pinControl.bounds.size.height / 2), self.pinControl.bounds.size.width, self.pinControl.bounds.size.height)
            self.pinControl.animate()
        }
    }
    
}

extension SCNewInvisibleAreaView : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Location updates failed: \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager!) {
        
    }
    
}
