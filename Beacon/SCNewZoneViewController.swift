//
//  SCNewZoneViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 5/6/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit
import Foundation

class SCNewZoneViewController: UIViewController {
    
    var newZoneButton:SCNewZoneButton?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
