//
//  AppDelegate.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 7. 10..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit
import FacebookCore
import GoogleMaps

@UIApplicationMain //앱의 시작점을 명시. 스위프트는 따로 main이 없다.(main.swift파일은 존재)//
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    let googleMapsApiKey = "AIzaSyCGmzJbFd9yeWzS51LHd09vLfrqQ9n49hM"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Type casting in swift is "as Type", you'll need to unwrap optionals however.
        
        //GoogleMap API Key등록//
        GMSServices.provideAPIKey(googleMapsApiKey)
    
        return true
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
        print("App exit")
    }
    
    //페이스북 로그인 후 다시 콜백한다.//
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        
    }
}

