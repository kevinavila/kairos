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
import FirebaseDatabase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseRef:FIRDatabaseReference!
    var user:FIRUser!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if #available(iOS 8, *) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.darkText
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
                
                user = FIRAuth.auth()?.currentUser
                scheduleReminder()
            } else {
                let loginController = storyboard.instantiateViewController(withIdentifier: "loginController")
                window.rootViewController = loginController
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let notificationAlert = UIAlertController(title: "Kairos", message: notification.alertBody!, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        notificationAlert.addAction(defaultAction)
        
        self.window?.rootViewController?.present(notificationAlert, animated: true, completion: nil)
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
    
    // Schedule log reminder
    func scheduleReminder() {
        let database = FIRDatabase.database()
        databaseRef = database.reference()
        
        databaseRef.child(user.uid+"/reminder_time").observeSingleEvent(of: .value, with: { (snapshot) in
            let text = snapshot.value as? String
            if (text != nil) {
                if (text != "REMINDERS_DISABLED") {
                    // Set date picker to date from database
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"
                    let date = dateFormatter.date(from: text!)
                    
                    
                    UIApplication.shared.cancelAllLocalNotifications()
                    
                    let fullNameArr = self.user.displayName?.characters.split{$0 == " "}.map(String.init)
                    let firstName = fullNameArr?[0]
                    
                    let notification = UILocalNotification()
                    notification.alertBody = "Hey \(firstName!), don't forget to log for the day!"
                    notification.alertAction = "log"
                    notification.repeatInterval = NSCalendar.Unit.day
                    notification.fireDate = date
                    
                    UIApplication.shared.scheduleLocalNotification(notification)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }


}

