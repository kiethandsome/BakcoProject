//
//  AppDelegate.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 10/19/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder {
    
   var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        setupFirstScreen()
        registerForPushNotification()
        return true
    }
    
    func setupFirstScreen() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let rootVc: UIViewController

        if UserDefaults.standard.bool(forKey: DidLogin)
        {
            rootVc = MyStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "tab")
            self.setValueForConstantVariables()
        }
        else
        {
            rootVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        }   
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
    }
    
    func setValueForConstantVariables() {
        MyUser.name = UserDefaults.standard.string(forKey: UserName)!
        MyUser.id = UserDefaults.standard.integer(forKey: UserId)
        MyUser.address = UserDefaults.standard.string(forKey: UserAddress)!
        MyUser.insuranceId = UserDefaults.standard.string(forKey: UserInsurance)!
        MyUser.phone = UserDefaults.standard.string(forKey: UserPhone)!
        MyUser.email = UserDefaults.standard.string(forKey: UserEmail)!
        MyUser.birthday = UserDefaults.standard.string(forKey: UserBirthday)!
    }
 
}


extension AppDelegate: UIApplicationDelegate {
    
    func registerForPushNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted, error) in
            if granted {
                print("Permission is granted")
                // 1
                let viewAction = UNNotificationAction(identifier: "viewAction",
                                                      title: "View",
                                                      options: [.foreground])
                
                // 2
                let newsCategory = UNNotificationCategory(identifier: "newsCategory",
                                                          actions: [viewAction],
                                                          intentIdentifiers: [],
                                                          options: [])
                // 3
                UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                
            } else {
                print("Permission is fail")
            }
        })
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {settings in
            guard settings.authorizationStatus == .authorized else {
                print("authorizations status is failed.")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map{ data in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device token: \(token)")
        _deviceToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail to register with error: \(error)")
    }
}

































