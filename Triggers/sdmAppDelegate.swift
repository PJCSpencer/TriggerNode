//
//  AppDelegate.swift
//  Triggers
//
//  Created by Peter Spencer on 20/10/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - Property(s)
    
    var window: UIWindow?


    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = GameController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

