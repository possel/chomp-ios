//
//  AppDelegate.swift
//  Chomp
//
//  Created by Sky Welch on 03/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appController: AppController?
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.appController = AppController()
        
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.appController?.window = window
        
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController = self.appController?.rootNavigationManager.rootNavigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

