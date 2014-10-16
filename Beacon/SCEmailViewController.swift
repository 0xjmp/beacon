//
//  SCEmailViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/15/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCEmailViewController: UIViewController {
    
    var logoImageView:UIImageView
    var emailField:UITextField
    var continueButton:UIButton
    
    override init() {
        let logo = UIImage(named: "loadinglogo")
        self.logoImageView = UIImageView(image: logo)
        self.logoImageView.frame = CGRectMake(0, 0, logo.size.width, logo.size.height)
        
        self.emailField = UITextField()
        self.emailField.returnKeyType = UIReturnKeyType.Go
        self.emailField.textColor = UIColor.blackColor()
        var gray:CGFloat = 200.0/255.0
        self.emailField.backgroundColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.emailField.attributedPlaceholder = NSAttributedString(string: "Email goes here...", attributes: [ NSForegroundColorAttributeName : UIColor.blackColor() ])
        self.emailField.font = SCTheme.primaryFont(18)
        self.emailField.leftViewMode = UITextFieldViewMode.Always
        let leftView = UIView(frame: CGRectMake(0, 0, 15, 0))
        self.emailField.leftView = leftView
        
        self.continueButton = UIButton()
        self.continueButton.setTitle("Get Started", forState: UIControlState.Normal)
        self.continueButton.setBackgroundImage(UIImage(named: "overlaybutton"), forState: UIControlState.Normal)
        self.continueButton.titleLabel?.font = SCTheme.primaryFont(25)
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.continueButton)
        
        self.emailField.delegate = self
        
        self.continueButton.addTarget(self, action: "continuePressed", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("background", ofType: "jpg")!)
        let imageView = UIImageView(image: image)
        imageView.userInteractionEnabled = true
        self.view = imageView
        
        self.view = SCBackgroundView()
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.logoImageView.center = CGPointMake(self.view.center.x, self.view.bounds.size.height / 5)
        self.emailField.frame = CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame) + 100, self.view.bounds.size.width, 45)
        
        let buttonMargin:CGFloat = 15.0
        self.continueButton.frame = CGRectMake(buttonMargin, CGRectGetMaxY(self.emailField.frame) + buttonMargin, self.view.bounds.size.width - (buttonMargin * 2), 45)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.emailField.becomeFirstResponder()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func continuePressed() {
        if self.emailField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            UIAlertView(title: "You must provide an email", message: nil, delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            SCUser.getUserState(self.emailField.text, completionHandler: { (responseObject, error) -> Void in
                var viewController:UIViewController? = nil
                if error == nil {
                    viewController = SCLoginViewController(email: self.emailField.text)
                } else {
                    viewController = SCLoginViewController(email: self.emailField.text)
                }
                self.navigationController?.pushViewController(viewController!, animated: true)
            })
        }
    }
}

extension SCEmailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.continuePressed()

        return true
    }

    
}
