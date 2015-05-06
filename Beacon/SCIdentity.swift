//
//  SCService.swift
//  Beacon
//
//  Created by Jake Peterson on 5/6/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit
import Argo
import Runes
import Alamofire

enum SCIdentityType:String {
    case Facebook = "facebook"
    case Twitter = "twitter"
    case LinkedIn = "linkedin"
    case Instagram = "instagram"
    case Tumblr = "tumblr"
    
    static let allValues = [
        Facebook,
        Twitter,
        LinkedIn,
        Instagram,
        Tumblr
    ]
    
    // Returns the default (1st) & clicked (2nd) image
    func getImages() -> (UIImage, UIImage) {
        return (UIImage(named: "\(rawValue)off")!, UIImage(named: "\(rawValue)on")!)
    }
    
    func getUrl() -> NSURL? {
        if let user = SCUsersManager.sharedManager.currentUser {
            let matches = user.identities?.filter({ (identity) -> Bool in
                return identity.provider == self.rawValue
            })
            
            if let match = matches?.first {
                return NSURL(string: match.url)!
            }
        }
        
        return nil
    }
}

struct SCIdentity {
    let provider:String
    let userId:Int
    let url:String
}

extension SCIdentity: JSONDecodable {
    
    static func create(provider:String)(userId:Int)(url:String) -> SCIdentity {
        return SCIdentity(provider: provider, userId: userId, url: url)
    }
    
    static func decode(j: JSONValue) -> SCIdentity? {
        return SCIdentity.create
            <^> j <| "provider"
            <*> j <| "user_id"
            <*> j <| "url"
    }
}
