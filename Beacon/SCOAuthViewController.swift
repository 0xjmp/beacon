//
//  SCOAuthViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 4/16/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit

protocol SCOAuthDelegate {
    func didFinishAuthentication(authViewController:SCOAuthViewController, user:SCUser)
    func didFailAuthentication(authViewController:SCOAuthViewController, error:NSError)
}

class SCOAuthViewController: UIViewController {
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSHTTPCookieManagerCookiesChangedNotification, object: nil)
    }
    
    lazy private var webView:UIWebView = {
        return UIWebView()
    }()
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var identityType:SCIdentityType
    
    var delegate:SCOAuthDelegate?
    
    init(identityType:SCIdentityType) {
        self.identityType = identityType
        
        super.init(nibName: nil, bundle: nil)
        
        webView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkForDismissal", name: NSHTTPCookieManagerCookiesChangedNotification, object: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        loadRequest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPressed:")
        
        webView.frame = view.bounds
        activityIndicator.center = view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadRequest() {
        activityIndicator.startAnimating()
        
        let url = NSURL(string: "\(SCNetworking.baseUrl)auth/\(identityType.rawValue)")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func checkForDismissal() {
        if let identities = SCUsersManager.sharedManager.currentUser?.identities {
            for identity in identities {
                if identity.provider == identityType.rawValue {
                    self.dismiss()
                }
            }
        }
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelPressed(sender:AnyObject?) {
        if let del = delegate {
            del.didFailAuthentication(self, error: NSError(domain: "Cancelled OAuth", code: 0, userInfo: nil))
        }
        
        self.dismiss()
    }
}

extension SCOAuthViewController : UIWebViewDelegate {
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        if let del = delegate {
            del.didFailAuthentication(self, error: error)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
}
