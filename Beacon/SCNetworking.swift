//
//  SCUser.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/29/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit
import Alamofire

typealias SCRequestResultsBlock = (response:Any?, error:NSError?)->Void

public class SCNetworking: NSObject {
    
    private class var apiVersion:NSString {
        get {
            return "v1"
        }
    }
    
    class var baseUrl:NSString {
        get {
            return "http://localhost:3000/"
        }
    }
    
    class func request(method:Alamofire.Method, path:NSString, params:[String: AnyObject]?, completion:SCRequestResultsBlock?) {
        let url = "\(self.baseUrl)\(apiVersion)/\(path)"
        let encoding = method.rawValue == "GET" ? ParameterEncoding.URL : ParameterEncoding.JSON
        Alamofire.request(method, url, parameters: params, encoding: encoding)
            .responseJSON { (request, response, json, error) in
                var url:NSString? = request.URL?.absoluteString
                
                if let code:Int = response?.statusCode {
                    println("(\(code)) \(url)")
                    
                    switch code {
                    case 401:
                        NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
//                        let locale = SCLocale.InvalidUser
//                        SCNetworking.presentUserError(locale)
                        return
                    
                    case 500:
//                        SCNetworking.presentUserError(SCLocale.ServerFailure)
                        return

                    default:
                        break
                    }
                } else {
                    println(url)
                }
                
                if error != nil {
                    if let info:NSDictionary = error?.userInfo! {
                        if let code = info["_kCFStreamErrorDomainKey"] as? NSNumber {
                            switch code.integerValue {
                            case 1:
                                NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
//                                SCNetworking.presentUserError(SCLocale.NoInternet)
                                return
                                
                            default:
                                break
                            }
                        }
                    }
                    
                    if let block = completion {
                        block(response: json, error: error)
                    }
                } else {
                    if response?.statusCode < 300 && response?.statusCode >= 200 {
                        if let block = completion {
                            block(response: json, error: nil)
                        }
                    } else {
                        var serverErrorString = json?.objectForKey("error") as? String
                        if let message = json?.objectForKey("error") as? String {
                            UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "Ok").show()
                        }
                        
                        // Build the error
                        var error:NSError?
                        if let code = response?.statusCode {
                            error = NSError(domain: "General Error", code: code, userInfo: nil)
                        }
                        
                        if let block = completion {
                            block(response: nil, error: error)
                        }
                    }
                }
            }
    }
}
