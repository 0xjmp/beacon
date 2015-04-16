//
//  SCLoginViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/15/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCLoginViewController: UIViewController {

    var logoImageView:UIImageView
    var passwordField:UITextField
    var continueButton:UIButton
    var email:NSString!
    
    required init(email:NSString!) {
        self.email = email
        
        let logo = UIImage(named: "loadinglogo")!
        self.logoImageView = UIImageView(image: logo)
        self.logoImageView.frame = CGRectMake(0, 0, logo.size.width, logo.size.height)
        
        self.passwordField = UITextField()
        self.passwordField.secureTextEntry = true
        self.passwordField.returnKeyType = UIReturnKeyType.Go
        self.passwordField.textColor = UIColor.blackColor()
        var gray:CGFloat = 200.0/255.0
        self.passwordField.backgroundColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.passwordField.layer.cornerRadius = 5
        self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password goes here...", attributes: [ NSForegroundColorAttributeName : UIColor.blackColor() ])
//        self.passwordField.font = SCTheme.primaryFont(18)
        self.passwordField.leftViewMode = UITextFieldViewMode.Always
        let leftView = UIView(frame: CGRectMake(0, 0, 15, 0))
        self.passwordField.leftView = leftView
        
        self.continueButton = UIButton()
        self.continueButton.setTitle("Get Started", forState: UIControlState.Normal)
        self.continueButton.setBackgroundImage(UIImage(named: "overlaybutton"), forState: UIControlState.Normal)
//        self.continueButton.titleLabel?.font = SCTheme.primaryFont(25)
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.continueButton)
        
        self.passwordField.delegate = self
        
        self.continueButton.addTarget(self, action: "continuePressed", forControlEvents: UIControlEvents.TouchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
//        self.view = SCBackgroundView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let buttonMargin:CGFloat = 15.0
        
        self.logoImageView.center = CGPointMake(self.view.center.x, self.view.bounds.size.height / 5)
        self.passwordField.frame = CGRectMake(buttonMargin, CGRectGetMaxY(self.logoImageView.frame) + 100, self.view.bounds.size.width - (buttonMargin * 2), 45)
        
        self.continueButton.frame = CGRectMake(self.passwordField.frame.origin.x, CGRectGetMaxY(self.passwordField.frame) + buttonMargin, self.passwordField.frame.size.width, 45)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.passwordField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Actions
    
    func continuePressed() {
        if self.passwordField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
//            SCNetworking.presentUserError(SCLocale.InvalidPassword)
        } else {
            SCUser.login(self.email, password: self.passwordField.text, completionHandler: { (responseObject, error) -> Void in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }

}

extension SCLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.continuePressed()
        return true
    }
    
}
