//
//  AppDelegate.swift
//  Hand Off Bluetooth Social Media App
//
//  Created by Jake Peterson on 9/29/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        SCUsersManager.sharedManager.startWatchingForCookieUpdates()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let homeViewController = SCHomeViewController(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        self.window!.rootViewController = navigationController
        
        self.window!.makeKeyAndVisible()
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        NSHTTPCookieStorage.sharedHTTPCookieStorage().cookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
//     MARK: - Hand off
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]!) -> Void) -> Bool {
        // Reconstruct the user's activity
        if (userActivity.activityType == SCConstants.handOffActivityType) {
            SCHandOffActivityManager.receive(userActivity) // Alternative: restorationHandler
            return true
        }
        
        return false
    }
    
    func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        // Use this to show the user what's being continued
        return (userActivityType == SCConstants.handOffActivityType)
    }
    
    func application(application: UIApplication, didUpdateUserActivity userActivity: NSUserActivity) {
        if let version:String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            userActivity.addUserInfoEntriesFromDictionary(["handoffVersion" : version])
        }
    }
    
    func application(application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: NSError) {
        if error == NSUserCancelledError {
            println("User cancelled activity type: \(userActivityType)")
        }
        
        println("An error occurred while continuing the activity type \(userActivityType): \(error)")
    }

}

