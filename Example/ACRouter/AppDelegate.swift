//
//  AppDelegate.swift
//  ACRouter
//
//  Created by 260732891@qq.com on 03/12/2017.
//  Copyright (c) 2017 260732891@qq.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        RouterManger.testLoadLocalRegister()
        RouterManger.testLoadRomoteRegister()
        RouterManger.testAddInterceptor()
        
        return true
    }
}

