//
//  AppDelegate.swift
//  TrollQuiz
//
//  Created by NguyenThanhLuan on 27/07/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

import UIKit
import GoogleMobileAds

//App: DoVui (iOS)
//App ID: ca-app-pub-4039533744360639~8046092120
//
//Ad unit(s):
//
//Name: TrollBanner
//Format: Banner
//ID: ca-app-pub-4039533744360639/9922458186
//
//Name: Trollinterstitial
//Format: Interstitial
//ID: ca-app-pub-4039533744360639/8581456350
//
//Name: Trollvideo
//Format: Rewarded video
//ID: ca-app-pub-4039533744360639/3137557984

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4039533744360639~8046092120")
        
        var mainstoryBoard: UIStoryboard!
        if UIDevice.current.userInterfaceIdiom == .phone{
            mainstoryBoard  = UIStoryboard.init(name: "Main", bundle: nil)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            mainstoryBoard  = UIStoryboard.init(name: "Main_ipad", bundle: nil)
        }
        
        let viewcontroller = mainstoryBoard.instantiateViewController(withIdentifier: "idstartview") 
        self.window?.rootViewController = viewcontroller
        
        UserDefaults.standard.register(defaults: ["MUSIC_ON":true])
        UserDefaults.standard.register(defaults: ["HIGH_SCORE":0])
        UserDefaults.standard.register(defaults: ["RATED":false])
        
        UserDefaults.standard.register(defaults: ["START_INDEX":0])
        UserDefaults.standard.register(defaults: ["START_INDEX_DTV":0])
        UserDefaults.standard.register(defaults: ["START_INDEX_KTTD":0])
        UserDefaults.standard.register(defaults: ["START_INDEX_DDLS":0])
        
        //register notification access
        let noticategory = UIUserNotificationCategory.init()
        let notiset = NSSet.init(object: noticategory)
        
        let notisetting = UIUserNotificationSettings.init(types: UIUserNotificationType.alert, categories: notiset as? Set<UIUserNotificationCategory>)
        UIApplication.shared.registerUserNotificationSettings(notisetting)
        
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let state = UIApplication.shared.applicationState
        
        if (state == UIApplicationState.active) {
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("Application will terminate")
        print("Register notification 2h later")
        
        //UIApplication.shared.cancelAllLocalNotifications()
        //UIApplication.shared.applicationIconBadgeNumber = 0
    }


}

