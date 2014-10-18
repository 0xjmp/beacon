//
//  SCInstagramManager.swift
//  Beacon
//
//  Created by Jake Peterson on 10/17/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCInstagramManager: NSObject {
   
    var clientId = "3e9dcad4b66a469e9ba7bbe019919d7d"
    var clientSecret = "58dd170fded5461a9178cde7f2630a87"
    var clientRedirect = "beacon://"
    
    func startSession(completion:(NSString? -> Void)) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(self.clientId)&client=touch&redirect_uri=\(self.clientRedirect)&response_type=code"))
    }
}
