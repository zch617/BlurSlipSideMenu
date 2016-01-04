//
//  AppDelegate.swift
//  BlurSlipSideMenuDemo
//
//  Created by 张慈航 on 15/12/1.
//  Copyright (c) 2015年 com.zhangcihang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarStyle = UIStatusBarStyle.LightContent
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        let sideMenuController = SlidsidTableViewController()
        let nav = UINavigationController(rootViewController: MainViewController())
        
        /******RootViewController中有两个子控制器，一个展示主界面，一个展示侧边栏********/
        //方式1
        let controller = RootViewController()
        controller.menuController = sideMenuController
        controller.contentController = nav
        controller.sideControllerWidthScale = 0.8
        controller.blurredType = .Light
        controller.slipDirection = .Right
        //方式2
//        let controller = RootViewController(menuController: sideMenuController, contentController: nav, blurredType: .Dark, sideControllerWidthScale: 0.4)
        
        //方式3
//        let controller = RootViewController(menuController: sideMenuController, contentController: nav, blurredType: .Light, sideControllerWidth: 180)
        
        //方式4
//        let controller = RootViewController(menuController: sideMenuController, contentController: nav)
        
        //方式5
//        let controller = RootViewController(menuController: sideMenuController)
//        controller.contentController = nav
//        controller.sideControllerWidth = 200
        
        
        /******ViewController中只有一个子控制器，用于展示侧边栏，自身带有的view展示主界面********/
        //方式1
//        let controller = ViewController()
//        controller.menuController = sideMenuController
//        controller.sideControllerWidthScale = 0.5
//        controller.blurredType = .Light
        
        //方式2
//        let controller = ViewController(menuController: sideMenuController, contentController: nil, blurredType: .Dark, sideControllerWidth: 240)
        
        //方式3
//        let controller = ViewController(menuController: sideMenuController, contentController: nil, blurredType: .ExtraLight, sideControllerWidthScale: 0.7)
        
        //方式4
//        let controller = ViewController(menuController: sideMenuController)
        
        //方式5
//        let controller = ViewController(menuController: sideMenuController, contentController: nil)
//        controller.sideControllerWidth = 200
        
        self.window?.rootViewController = controller
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

