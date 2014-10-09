//
//  SCNewInvisibleAreaView.swift
//  Beacon
//
//  Created by Jake Peterson on 10/9/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCNewInvisibleAreaView: UIView {

    var nameField:UITextField!
    var distanceSlider:UISlider!
    var addButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.nameField = UITextField()
        self.nameField.textColor = UIColor.darkGrayColor()
        self.nameField.backgroundColor = UIColor.lightGrayColor()
        self.nameField.layer.cornerRadius = 5.0
        self.nameField.placeholder = "Name goes here..."
        self.nameField.font = SCTheme.primaryFont(25)
        self.addSubview(self.nameField)
    }

}
