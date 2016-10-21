//
//  AppDelegate.swift
//  Kairos
//
//  Created by Kevin Avila on 10/7/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UIApplication.shared.statusBarStyle = .lightContent
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.black
        }
        
        // Uncomment to allow app to remember login info
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let window = self.window {
            if (FBSDKAccessToken.current() != nil) {
                let navController = storyboard.instantiateViewController(withIdentifier: "navController")
                let monthController = storyboard.instantiateViewController(withIdentifier: "monthController")
                let dayViewController = storyboard.instantiateViewController(withIdentifier: "dayViewController")
                
                window.rootViewController = navController
                (window.rootViewController as! UINavigationController).pushViewController(monthController, animated: false)
                (window.rootViewController as! UINavigationController).pushViewController(dayViewController, animated: false)
            } else {
                let loginController = storyboard.instantiateViewController(withIdentifier: "loginController")
                window.rootViewController = loginController
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

