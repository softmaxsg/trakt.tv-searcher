//
//  AppDelegate.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = MainViewController()
        self.window = window
        
        window.makeKeyAndVisible()

        return true
    }
}

