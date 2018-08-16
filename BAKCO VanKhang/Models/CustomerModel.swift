//
//  Customer.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 10/23/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

let CurrentUser = "currentUser"
let UserName = "Name"
let UserId = "Id"
let UserPhone = "Phone"
let UserInsurance = "Insurance"
let UserEmail = "Email"
let UserAddress = "Address"
let UserBirthday = "Birthday"
let UserGender = "Gender"
let UserToken = "Token"
let UserDistCode = "DistCode"
let UserDistName = "DistName"
let DidLogin = "DidLogin"

class Customer {
    
    var Id: Int?
    var FullName: String?
    var CustomerCode: String?
    var Phone: String?
    var HealthInsurance: String?
    var Email:  String?
    var Address: String?
    var BirthDate: String?
    var Gender: Bool?
    
    private static var _currentUser: Customer?
    
    static var current: Customer { /// Get only varriable
        guard let currentUser = _currentUser else {
            fatalError("Error: current user doesnt exsist")
        }
        return currentUser
    }
    
    init(data: [String : Any]) {
        
        if let id = data["Id"] {
            self.Id = id as? Int
        } else {
            self.Id = 0
        }
        
        if let fullname = data["FullName"]  {
            self.FullName = (fullname as! String)
        } else {
            self.FullName = ""
        }
        
        if let customerCode = data["CustomerCode"] as? String {
            self.CustomerCode = customerCode
        } else {
            self.CustomerCode = "none-code"
        }
        
        if let phone = data["Phone"] as? String {
            self.Phone = phone
        } else {
            self.Phone = "none- Phone number"
        }
        
        if let healthInsurance = data["HealthInsurance"] as? String {
            self.HealthInsurance = healthInsurance
        } else {
            self.HealthInsurance = "đéo có nhé ^^ hihi"
        }
        
        if let email = data["Email"] as? String {
            self.Email = email
        } else {
            self.Email = "ko có email"
        }
        
        if let address = data["Address"] as? String {
            self.Address = address
        } else {
            self.Address = "Ko có địa chỉ"
        }
        
        if let birthday = data["BirthDate"] as? String {
            self.BirthDate = birthday
        } else {
            self.BirthDate = "con chim non"
        }
        
        if let gender = data["Gender"] as? Bool {
            self.Gender = gender
        } else {
            self.Gender = nil
        }
    }
    
    static func setCurrent(_ user: Customer) {

        self._currentUser = user
        UserDefaults.standard.set(true, forKey: DidLogin)
        UserDefaults.standard.setValue(user.FullName, forKey: UserName)
        UserDefaults.standard.setValue(user.Id, forKey: UserId)
        UserDefaults.standard.setValue(user.Phone, forKey: UserPhone)
        UserDefaults.standard.setValue(user.HealthInsurance, forKey: UserInsurance)
        UserDefaults.standard.setValue(user.Email, forKey: UserEmail)
        UserDefaults.standard.setValue(user.BirthDate, forKey: UserBirthday)
        UserDefaults.standard.setValue(user.Gender, forKey: UserGender)
    }
    
    static func logoutUser() {
        UserDefaults.standard.setValue("", forKey: UserName)
        UserDefaults.standard.set(false, forKey: DidLogin)
        UserDefaults.standard.setNilValueForKey(UserId)
        UserDefaults.standard.setNilValueForKey(UserPhone)
        UserDefaults.standard.setNilValueForKey(UserInsurance)
        UserDefaults.standard.setNilValueForKey(UserEmail)
        UserDefaults.standard.setNilValueForKey(UserBirthday)
        UserDefaults.standard.setNilValueForKey(UserGender)
    }
}







 




