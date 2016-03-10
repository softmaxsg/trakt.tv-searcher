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
    var moviesAssembly: MoviesAssembly?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        application.statusBarHidden = false

        self.moviesAssembly = MoviesAssembly()

        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = UINavigationController(rootViewController: moviesAssembly!.createMoviesViewController())
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}

