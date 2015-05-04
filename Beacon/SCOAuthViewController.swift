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
    
    lazy private var webView:UIWebView = { [unowned self] in
        return UIWebView()
    }()
    var delegate:SCOAuthDelegate?
    var serviceType:SCOAuthService? {
        didSet {
            let url = NSURL(string: "\(SCNetworking.baseUrl)/auth/\(serviceType?.rawValue)")
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
