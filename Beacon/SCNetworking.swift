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
    
    var baseUrl:NSString! {
        get {
#if DEBUG
                return "http://localhost:3000/\(self.apiVersion)/"
#else
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
                        println("User is not logged in.")
                        NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
                        let error = NSError(domain: "You need to sign in or sign up before continuing.", code: code, userInfo: nil)
                        completionHandler(responseObject: nil, error: error)
                        return
                    
                    case 500:
                        UIAlertView(title: "We're having some technical difficulties.", message: "We'll be back in a sec!", delegate: nil, cancelButtonTitle: "Close").show()
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
                                UIAlertView(title: "Beacon requires you to be connected to the internet.", message: nil, delegate: nil, cancelButtonTitle: "OK").show()
                                break
                                
                            default:
                                break
                        }
                    }
                    println(error)
                    completionHandler(responseObject: nil, error: error!)
                } else {
                    var jsonError: NSError?
                    var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data as NSData, options: NSJSONReadingOptions(0), error: &jsonError)
                    if jsonError != nil {
                        println("Error parsing response to JSON: \(jsonError)")
                    } else {
                        completionHandler(responseObject: jsonObject, error: nil)
                    }
                }
            }
    }
   

}
