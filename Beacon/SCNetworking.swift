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
                return "localhost:3000/\(self.apiVersion)/"
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
        Alamofire.request(method, url, parameters: params, encoding:ParameterEncoding.JSON)
            .response { (request, response, data, error) in
                println("(\(response?.statusCode)) \(request.URL.absoluteString)")
//                var jsonError:NSErrorPointer
                println(data)
//                if (jsonError != nil) {
//                    println("A JSON error occurred: \(error)")
//                    completionHandler(responseObject: nil, error: jsonError.memory!)
//                    return;
//                }
            
                if error != nil {
                    completionHandler(responseObject: nil, error: error!)
                } else {
                    completionHandler(responseObject: data, error: nil)
                }
            }
    }
   

}
