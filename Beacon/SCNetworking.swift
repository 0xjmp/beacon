//
//  SCUser.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/29/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import Alamofire

typealias SCRequestResultsBlock = (responseObject:AnyObject?, error:NSError?)->Void

class SCNetworking: NSObject {
    
    var apiVersion:NSString! {
        get {
            return "v1"
        }
    }
    
    var OAuthEnabled:Bool?
    var baseUrl:NSString! {
        get {
#if DEBUG
    if self.OAuthEnabled == true {
        return "http://localhost:3000/user/auth/"
    }
    
        return "http://localhost:3000/\(self.apiVersion)/"
#else
    if self.OAuthEnabled == true {
        return "http://api.sce.ne/user/auth/"
    }
                return "http://api.sce.ne/\(self.apiVersion)/"
#endif
        }
    }
    
    class var shared : SCNetworking {
    struct Static {
        static let instance : SCNetworking = SCNetworking()
        }
        return Static.instance
    }
    
    func request(method:Alamofire.Method, path:NSString!, params:[String: AnyObject], completionHandler:SCRequestResultsBlock) {
        let url = "\(self.baseUrl)\(path)"
        let encoding = method.toRaw() == "GET" ? ParameterEncoding.URL : ParameterEncoding.JSON
        Alamofire.request(method, url, parameters: params, encoding:encoding)
            .response { (request, response, data, error) in
                let url:NSString! = request.URL.absoluteString
                
                if let code:Int = response?.statusCode {
                    println("(\(code)) \(url)")
                    
                    switch code {
                    case 401:
                        NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
                        let locale = SCLocale.InvalidUser
                        SCNetworking.presentUserError(locale)
                        return
                    
                    case 500:
                        SCNetworking.presentUserError(SCLocale.ServerFailure)
                        return

                    default:
                        break
                    }
                } else {
                    println(url)
                }
                
                if error != nil {
                    if let info:NSDictionary = error?.userInfo! {
                        let code = info["_kCFStreamErrorDomainKey"] as NSNumber
                        switch code.integerValue {
                        case 1:
                            NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
                            SCNetworking.presentUserError(SCLocale.NoInternet)
                            return
                            
                            default:
                                break
                        }
                    }
                    completionHandler(responseObject: nil, error: error!)
                } else {
                    var jsonError: NSError?
                    var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data as NSData, options: NSJSONReadingOptions(0), error: &jsonError)
                    if jsonError != nil {
                        println("Error parsing response to JSON: \(jsonError)")
                        SCNetworking.presentUserError(SCLocale.ServerFailure)
                    } else {
                        if response?.statusCode == 200 || response?.statusCode == 204 {
                            completionHandler(responseObject: jsonObject, error: nil)
                        } else {
                            var serverErrorString = jsonObject?.objectForKey("error") as? NSString
                            if serverErrorString != nil {
                                UIAlertView(title: serverErrorString, message: nil, delegate: nil, cancelButtonTitle: "Ok").show()
                            }
                            
                            var code = response!.statusCode as Int
                            completionHandler(responseObject: nil, error: NSError(domain: "General Error", code: code, userInfo: nil))
                        }
                    }
                }
            }
    }
   

}

extension SCNetworking {
    
    class func presentUserError(locale:SCLocale) {
        let (title, message) = locale.description()
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
}

extension SCNetworking {
    
    func OAuthRequest(method:Alamofire.Method, authPath:NSString!, params:[String: AnyObject], completionHandler:SCRequestResultsBlock) {
        self.OAuthEnabled = true
        self.request(method, path: authPath, params: params, completionHandler: completionHandler)
        self.OAuthEnabled = false
    }
    
}
