//
//  SCNewZoneView.swift
//  Beacon
//
//  Created by Jake Peterson on 5/6/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class SCNewZoneView: UIView {
    
    var nameField:UITextField!
    var mapView:MKMapView!
    var addButton:UIButton!
    var zoneDelegate:SCNewZoneDelegate?
    var locationManager:CLLocationManager!
    lazy var userLocationAnnotation:MKPointAnnotation = { [unowned self] in
        return MKPointAnnotation()
        }()
    var pinControl:SPinControl!
    var circle:MKCircle?
    var radiusLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.nameField = UITextField()
        self.nameField.textColor = UIColor.blackColor()
        var gray:CGFloat = 200.0/255.0
        self.nameField.backgroundColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.nameField.layer.cornerRadius = 5.0
        self.nameField.attributedPlaceholder = NSAttributedString(string: "Enter an address for your new zone...", attributes: [ NSForegroundColorAttributeName : UIColor.grayColor() ])
        self.nameField.font = SCTheme.primaryFont(15)
        self.nameField.layer.borderColor = UIColor.whiteColor().CGColor
        self.nameField.layer.borderWidth = 1.0
        self.nameField.leftViewMode = UITextFieldViewMode.Always
        let leftView = UIView(frame: CGRectMake(0, 0, 15, 0))
        self.nameField.leftView = leftView
        self.nameField.returnKeyType = UIReturnKeyType.Search
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
        
        self.radiusLabel = UILabel(frame: CGRectZero)
        self.radiusLabel.textColor = UIColor.whiteColor()
        self.radiusLabel.font = SCTheme.primaryFont(13)
        self.radiusLabel.textAlignment = NSTextAlignment.Center
        self.mapView.addSubview(self.radiusLabel)
        
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
        
        let margin:CGFloat = 15.0
        
        self.nameField.frame = CGRectMake(margin, margin, self.bounds.size.width - (margin * 2), 44)
        self.mapView.frame = CGRectMake(margin, CGRectGetMaxY(self.nameField.frame) + 10, self.nameField.bounds.size.width, 200)
        self.pinControl.frame = CGRectMake(self.pinControl.frame.origin.x, self.pinControl.frame.origin.y, self.pinControl.currentRadius / 5 + 20, 45)
        self.radiusLabel.frame = CGRectMake(self.pinControl.frame.origin.x, self.pinControl.frame.origin.y, self.pinControl.bounds.size.width, self.pinControl.bounds.size.height)
        self.addButton.frame = CGRectMake(self.nameField.frame.origin.x, CGRectGetMaxY(self.mapView.frame) + 10, self.nameField.bounds.size.width, 50)
        
        self.startUpdatingLocation()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func createNewArea() {
        if let delegate = self.zoneDelegate {
            if self.nameField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                delegate.didFinishCreatingZone()
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
            }
        }
    }
    
    func clearMapView(mapView:MKMapView!) {
        if mapView.overlays != nil {
            for overlay in mapView.overlays {
                mapView.removeOverlay(overlay as! MKOverlay)
            }
        }
        
        if mapView.annotations != nil {
            for annotation in mapView.annotations {
                if annotation as? MKPointAnnotation != userLocationAnnotation {
                    mapView.removeAnnotation(annotation as! MKAnnotation)
                }
            }
        }
    }
    
    func pinDragged(pin:SPinControl!) {
        if let userLocation = self.locationManager.location {
            self.resetCircle(userLocation)
        }
        
        self.mapView.delegate.mapView!(self.mapView, regionDidChangeAnimated: true)
    }
    
    func resetPin(pin:UIControl!) {
        
    }
    
    func resetCircle(userLocation:CLLocation!) {
        self.mapView.removeOverlay(self.circle)
        self.circle = MKCircle(centerCoordinate: userLocation.coordinate, radius: CLLocationDistance(self.pinControl.currentRadius))
        self.mapView.addOverlay(self.circle)
        
        let radius = NSNumber(float: Float(self.pinControl.currentRadius) * 3.0)
        self.radiusLabel.text = "\(radius.integerValue) ft."
    }
    
    func resetUserLocationAnnotation(coord:CLLocationCoordinate2D) {
        self.mapView.removeAnnotation(userLocationAnnotation)
        
        userLocationAnnotation.coordinate = coord
        mapView.addAnnotation(userLocationAnnotation)
    }
    
}

extension SCNewZoneView: MKMapViewDelegate {
    
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
                self.resetCircle(userLocation.location)
                
                mapView.delegate.mapView!(mapView, regionDidChangeAnimated: false)
                
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
            //            let color:UIColor = SCTheme.beaconPurple
            //            circleView.strokeColor = color
            //            circleView.fillColor = color.colorWithAlphaComponent(0.4)
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
            if self.circle != nil {
                var region = MKCoordinateRegionForMapRect(self.circle!.boundingMapRect)
                region = mapView.regionThatFits(region)
                mapView.setRegion(region, animated: false)
            }
            
            self.resetUserLocationAnnotation(location.coordinate)
            
            let userPoint = self.mapView.convertCoordinate(location.coordinate, toPointToView: self.mapView)
            self.pinControl.frame = CGRectMake(userPoint.x, userPoint.y - (self.pinControl.bounds.size.height / 2), self.pinControl.bounds.size.width, self.pinControl.bounds.size.height)
            self.radiusLabel.frame = CGRectMake(self.pinControl.frame.origin.x, self.pinControl.frame.origin.y - 10, self.pinControl.bounds.size.width, self.pinControl.bounds.size.height)
            self.pinControl.animate()
        }
    }
    
}

extension SCNewZoneView : CLLocationManagerDelegate {
    
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
