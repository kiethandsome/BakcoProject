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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
   var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        setupFirstScreen()
        return true
    }
    
    func setupFirstScreen() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVc: UIViewController

        if UserDefaults.standard.bool(forKey: DidLogin)
        {
            rootVc = mainStoryboard.instantiateViewController(withIdentifier: "tab")
            _userName = UserDefaults.standard.string(forKey: UserName)!
            _userId = UserDefaults.standard.integer(forKey: UserId)
            _userAddress = UserDefaults.standard.string(forKey: UserAddress)!
            _userInsurance = UserDefaults.standard.string(forKey: UserInsurance)!
            _userPhone = UserDefaults.standard.string(forKey: UserPhone)!
            _userEmail = UserDefaults.standard.string(forKey: UserEmail)!
            _userBirthday = UserDefaults.standard.string(forKey: UserBirthday)!
        }
        else
        {
            rootVc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        }   
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
    }
}







