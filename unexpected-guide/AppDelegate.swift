//
//  AppDelegate.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 11..
//  Copyright (c) 2017 fail-nicely. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // to display a splash screen for a longer (1 sec) 
        //RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 1) as Date)
        
        return true
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
    }
    
}

let mainColor: UIColor = UIColor(red:0.29, green:0.09, blue:0.24, alpha:1.00)
let backgroundColor: UIColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.00) // 씀 바탕색깔 desert storm
let fontColor: UIColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00) //  폰트 색깔 mine shaft
let boldFontColor: UIColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.00) // bold 체
let textfieldColor: UIColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.00) //
