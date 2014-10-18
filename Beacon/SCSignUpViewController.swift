//
//  SCSignUpViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/15/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCSignUpViewController: UIViewController {

    var logoImageView:UIImageView
    var passwordField:UITextField
    var confirmPasswordField:UITextField
    var continueButton:UIButton
    var email:NSString
    
    required init(email:NSString) {
        self.email = email
        
        let logo = UIImage(named: "loadinglogo")
        self.logoImageView = UIImageView(image: logo)
        self.logoImageView.frame = CGRectMake(0, 0, logo.size.width, logo.size.height)
        
        self.passwordField = UITextField()
        self.passwordField.secureTextEntry = true
        self.passwordField.returnKeyType = UIReturnKeyType.Next
        self.passwordField.textColor = UIColor.blackColor()
        self.passwordField.layer.cornerRadius = 5
        var gray:CGFloat = 200.0/255.0
        self.passwordField.backgroundColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.passwordField.attributedPlaceholder = NSAttributedString(string: "Choose a new password...", attributes: [ NSForegroundColorAttributeName : UIColor.blackColor() ])
        self.passwordField.font = SCTheme.primaryFont(18)
        self.passwordField.leftViewMode = UITextFieldViewMode.Always
        var leftView = UIView(frame: CGRectMake(0, 0, 15, 0))
        self.passwordField.leftView = leftView
        
        self.confirmPasswordField = UITextField()
        self.confirmPasswordField.secureTextEntry = true
        self.confirmPasswordField.returnKeyType = UIReturnKeyType.Go
        self.confirmPasswordField.layer.cornerRadius = 5
        self.confirmPasswordField.textColor = UIColor.blackColor()
        self.confirmPasswordField.backgroundColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.confirmPasswordField.attributedPlaceholder = NSAttributedString(string: "Confirm your password...", attributes: [ NSForegroundColorAttributeName : UIColor.blackColor() ])
        self.confirmPasswordField.font = SCTheme.primaryFont(18)
        self.confirmPasswordField.leftViewMode = UITextFieldViewMode.Always
        leftView = UIView(frame: CGRectMake(0, 0, 15, 0))
        self.confirmPasswordField.leftView = leftView
        
        self.continueButton = UIButton()
        self.continueButton.setTitle("Continue", forState: UIControlState.Normal)
        self.continueButton.setBackgroundImage(UIImage(named: "overlaybutton"), forState: UIControlState.Normal)
        self.continueButton.titleLabel?.font = SCTheme.primaryFont(25)
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.confirmPasswordField)
        self.view.addSubview(self.continueButton)
        
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
        
        self.continueButton.addTarget(self, action: "continuePressed", forControlEvents: UIControlEvents.TouchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let buttonMargin:CGFloat = 15.0
        
        self.logoImageView.center = CGPointMake(self.view.center.x, self.view.bounds.size.height / 5)
        self.passwordField.frame = CGRectMake(buttonMargin, CGRectGetMaxY(self.logoImageView.frame) + 100, self.view.bounds.size.width - (buttonMargin * 2), 45)
        self.confirmPasswordField.frame = CGRectMake(self.passwordField.frame.origin.x, CGRectGetMaxY(self.passwordField.frame) + buttonMargin, self.passwordField.bounds.size.width, self.passwordField.bounds.size.height)
        self.continueButton.frame = CGRectMake(self.passwordField.frame.origin.x, CGRectGetMaxY(self.confirmPasswordField.frame) + buttonMargin, self.passwordField.bounds.size.width, 45)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.passwordField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    func continuePressed() {
        if self.passwordField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || self.confirmPasswordField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            UIAlertView(title: "You must fill out the required fields", message: nil, delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            SCUser.signUp(self.email, password: self.passwordField.text, passwordConfirmation:self.confirmPasswordField.text, completionHandler: { (responseObject, error) -> Void in
                if error != nil {
                    UIAlertView(title: "An error occurred.", message: error!.domain, delegate: nil, cancelButtonTitle: "OK").show()
                } else {
                    let viewController = SCTutorialViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            })
        }
    }
    
}

extension SCSignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.passwordField {
            self.confirmPasswordField.becomeFirstResponder()
        } else if textField == self.confirmPasswordField {
            self.continuePressed()
        }
        
        return true
    }
    
}
