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

class SCNewInvisibleAreaView: UIToolbar {

    var nameField:UITextField!
    var mapView:MKMapView!
    var addButton:UIButton!
    var actionDelegate:SCNewInvisibleAreaDelegate?
    var locationManager:CLLocationManager!
    
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
        self.mapView.layer.cornerRadius = 5
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true
        self.addSubview(self.mapView)
        
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
        println("location?: \(self.locationManager.location)")
        
        if CLLocationManager.locationServicesEnabled() == true {
            if self.locationManager.location == nil {
                self.locationManager.requestAlwaysAuthorization()
//                self.locationManager.startUpdatingLocation()
            }
        }
        
    }

}

extension SCNewInvisibleAreaView: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        println("mapView: didUpdateUserLocation: \(userLocation)")
    }
    
    func mapView(mapView: MKMapView!, didFailToLocateUserWithError error: NSError!) {
        println("An error occurred while locating the current user: \(error)")
    }
    
}

extension SCNewInvisibleAreaView : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Location updates failed: \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager!) {
        
    }
    
}
