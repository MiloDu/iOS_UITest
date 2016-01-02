//
//  AppDelegate.swift
//  UITest
//
//  Created by MiloDu on 15/12/14.
//  Copyright © 2015年 Milo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let window = MyWindow(frame: UIScreen.mainScreen().bounds)
        window.tag = 0
        self.window = window
        let viewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Main")
        self.window?.rootViewController = viewController
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

//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("touchedBegan application")
//        super.touchesBegan(touches, withEvent: event)
//    }
    
    class MyWindow: UIWindow {
//        override init(frame: CGRect) {
//            super.init(frame: frame)
////            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTap"))
//        }
//    
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        func onTap(){
//            print("onTap---------->\(self.tag)")
//        }
//        
//        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//            print("touchedBegan->\(self.tag)")
//            super.touchesBegan(touches, withEvent: event)
//        }
//        
//        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//            print("touchesEnded->\(self.tag)")
//            super.touchesEnded(touches, withEvent: event)
//        }
//
//        override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//            print("hitTest ->\(self.tag)")
//            let view = super.hitTest(point, withEvent: event)
//            print("hitTest ->\(self.tag) and view tag is \(view?.tag)")
//            return view
//        }
//        
//        override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
//            print("pointInside ->\(self.tag)")
//            let isin = super.pointInside(point, withEvent: event)
//            print("pointInside ->\(self.tag) and in is \(isin)")
//            return isin
//        }
    }
}

