//
//  AppDelegate.swift
//  Gabb
//
//  Created by Evan Waters on 3/25/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

var deviceToken:String!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil))
        application.registerForRemoteNotifications()
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Adding functions for notifications
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken token:NSData) {
        
        let tokenChars = UnsafePointer<CChar>(token.bytes)
        var tokenString = ""
        
        for i in 0 ..< token.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        deviceToken = tokenString
        print(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationWithError error: NSError) {
        print("We couldn't register for remote notifications...")
        print("\(error), \(error.localizedDescription)")
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void ) {
        NSNotificationCenter.defaultCenter().postNotificationName("ReceivedNotification", object: self, userInfo: userInfo)
        completionHandler(UIBackgroundFetchResult.NewData)
    }

    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject: AnyObject], comletionHandler completionHandler: () -> Void ) {
    }


}

