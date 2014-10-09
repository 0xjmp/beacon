//
//  SCNewInvisibleAreaView.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.minimumTrackTintColor = UIColor.whiteColor()
        self.maximumTrackTintColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 6)
    }
}

class SCInvisibleSliderView: UIView {
    
    var slider:SCSlider!
    
    var minimumText:NSString? {
        didSet {
            self.minimumLabel.text = minimumText
            self.minimumLabel.sizeToFit()
            self.setNeedsLayout()
        }
    }
    var midText:NSString? {
        didSet {
            self.midLabel.text = midText
            self.midLabel.sizeToFit()
            self.setNeedsLayout()
        }
    }
    var maximumText:NSString? {
        didSet {
            self.maximumLabel.text = maximumText
            self.maximumLabel.sizeToFit()
            self.setNeedsLayout()
        }
    }
    
    var minimumLabel:UILabel!
    var midLabel:UILabel!
    var maximumLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.slider = SCSlider(frame: CGRectZero)
        self.slider.addTarget(self, action: "sliderValueChanged", forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(self.slider)
        
        self.minimumLabel = UILabel()
        self.midLabel = UILabel()
        self.midLabel.textAlignment = NSTextAlignment.Center
        self.maximumLabel = UILabel()
        self.maximumLabel.textAlignment = NSTextAlignment.Right
        for label in [self.minimumLabel, self.midLabel, self.maximumLabel] {
            label.textColor = UIColor.whiteColor()
            label.font = SCTheme.primaryFont(23)
            self.addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin:CGFloat = 15.0
        
        self.slider.frame = CGRectMake(margin, 3, self.bounds.size.width - (margin * 2), self.slider.bounds.size.height)
        self.minimumLabel.frame = CGRectMake(self.slider.frame.origin.x, CGRectGetMaxY(self.slider.frame) + 25, self.minimumLabel.bounds.size.width, self.minimumLabel.bounds.size.height)
        self.midLabel.frame = CGRectMake(self.slider.center.x - (self.midLabel.bounds.size.width / 2), self.minimumLabel.frame.origin.y, self.midLabel.bounds.size.width, self.midLabel.bounds.size.height)
        self.maximumLabel.frame = CGRectMake(CGRectGetMaxX(self.slider.frame) - self.maximumLabel.bounds.size.width, self.minimumLabel.frame.origin.y, self.maximumLabel.bounds.size.width, self.maximumLabel.bounds.size.height)
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, CGRectGetMaxY(self.midLabel.frame) + margin)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func sliderValueChanged() {
        
    }
    
}

protocol SCNewInvisibleAreaDelegate {
    func didCreateNew(invisibleArea:SCInvisibleArea!)
}

class SCNewInvisibleAreaView: UIToolbar {

    var addressField:UITextField!
    var distanceSlider:SCInvisibleSliderView!
    var addButton:UIButton!
    var actionDelegate:SCNewInvisibleAreaDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.barTintColor = UIColor.blackColor()
        
        self.addressField = UITextField()
        self.addressField.textColor = UIColor.blackColor()
        var gray:CGFloat = 200.0/255.0
        self.addressField.backgroundColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.addressField.layer.cornerRadius = 5.0
        self.addressField.attributedPlaceholder = NSAttributedString(string: "Address goes here...", attributes: [ NSForegroundColorAttributeName : UIColor.blackColor() ])
        self.addressField.font = SCTheme.primaryFont(25)
        self.addressField.layer.borderColor = UIColor.whiteColor().CGColor
        self.addressField.layer.borderWidth = 1.0
        self.addressField.leftViewMode = UITextFieldViewMode.Always
        let leftView = UIView(frame: CGRectMake(0, 0, 15, 0))
        self.addressField.leftView = leftView
        self.addSubview(self.addressField)
        
        self.distanceSlider = SCInvisibleSliderView(frame: CGRectZero)
        self.distanceSlider.minimumText = "100ft"
        self.distanceSlider.midText = "500ft"
        self.distanceSlider.maximumText = "1000ft"
        self.addSubview(self.distanceSlider)
        
        let image = UIImage(named: "overlaybutton")
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
        
        self.addressField.frame = CGRectMake(margin, margin, self.bounds.size.width - (margin * 2), 55)
        self.distanceSlider.frame = CGRectMake(0, CGRectGetMaxY(self.addressField.frame) + margin, self.bounds.size.width, self.distanceSlider.bounds.size.height)
        self.addButton.frame = CGRectMake(self.addressField.frame.origin.x, CGRectGetMaxY(self.distanceSlider.frame) + (margin * 4.0), self.addressField.bounds.size.width, 50)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func createNewArea() {
        if let actionDelegate = self.actionDelegate {
            if self.addressField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                var invisibleArea = SCInvisibleArea(json: nil)
                invisibleArea.location = self.addressField.text
                actionDelegate.didCreateNew(invisibleArea)
            } else {
                var alertView = UIAlertView(title: "Please fill in the required fields", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }

}
