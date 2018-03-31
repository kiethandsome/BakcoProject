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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
   var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        setupFirstScreen()
        registerForPushNotification()
        return true
    }
    
    func setupFirstScreen() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVc: UIViewController

        if UserDefaults.standard.bool(forKey: DidLogin)
        {
            rootVc = mainStoryboard.instantiateViewController(withIdentifier: "tab")
            self.setValueForConstantVariables()
        }
        else
        {
            rootVc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        }   
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
    }
    
    func setValueForConstantVariables() {
        _userName = UserDefaults.standard.string(forKey: UserName)!
        _userId = UserDefaults.standard.integer(forKey: UserId)
        _userAddress = UserDefaults.standard.string(forKey: UserAddress)!
        _userInsurance = UserDefaults.standard.string(forKey: UserInsurance)!
        _userPhone = UserDefaults.standard.string(forKey: UserPhone)!
        _userEmail = UserDefaults.standard.string(forKey: UserEmail)!
        _userBirthday = UserDefaults.standard.string(forKey: UserBirthday)!

    }
    
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







