//
//  SCConstants.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/29/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

struct SCConstants {
    
    static var handOffActivityType:NSString = "com.WFIO.hand-off-message"
    
}

enum SCLocale {
    
    case NoInternet
    case ServerFailure
    case InvalidUser
    case InvalidPassword
    
    func description() -> (NSString, NSString?) {
        switch self {
        case .NoInternet:
            return ("Beacon requires you to be connected to the internet.", nil)
            
        case .ServerFailure:
            return ("We're having some technical difficulties", "We'll be back in a sec!")
            
        case .InvalidUser:
            return ("You must sign in or sign up before continuing.", nil)
            
        case .InvalidPassword:
            return ("You must fill out the password field", nil)
        }
    }
    
}
