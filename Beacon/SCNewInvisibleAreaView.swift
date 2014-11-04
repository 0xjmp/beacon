//
//  SCNewInvisibleAreaView.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import MapKit

protocol SCNewInvisibleAreaDelegate {
    func didCreateNew(invisibleArea:SCInvisibleArea!)
}

class SCNewInvisibleAreaView: UIToolbar {

    var nameField:UITextField!
    var mapView:MKMapView!
    var addButton:UIButton!
    var actionDelegate:SCNewInvisibleAreaDelegate?
    
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
        
        self.mapView = MKMapView()
        self.mapView.layer.cornerRadius = 5
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Standard
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

}

extension SCNewInvisibleAreaView: MKMapViewDelegate {
    
}
