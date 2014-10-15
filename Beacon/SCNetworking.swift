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
                
                if let code:Int! = response?.statusCode {
                    println("(\(code)) \(url)")

                    if code == 401 {
                        println("User is not logged in.")
                        NSNotificationCenter.defaultCenter().postNotificationName(SCUserLoggedOutNotification, object: nil)
                        let error = NSError(domain: "You need to sign in or sign up before continuing.", code: code, userInfo: nil)
                        completionHandler(responseObject: nil, error: error)
                        return // TODO: mend the relationship between server and 401
                    }
                } else {
                    println(url)
                }
                
                if error != nil {
                    println(error)
                    completionHandler(responseObject: nil, error: error!)
                } else {
                    var jsonError: NSError?
                    if let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data as NSData, options: NSJSONReadingOptions(0), error: &jsonError) {
                        completionHandler(responseObject: jsonObject, error: nil)
                    } else {
                        println(jsonError)
                        completionHandler(responseObject: nil, error: jsonError)
                    }
                }
            }
    }
   

}
