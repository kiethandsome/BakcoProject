//
//  User.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 1/11/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    
    var id = 0
    var fullName = "Chưa có tên"
    var phone = "Chưa có số điện thoại"
    var healthInsurance = "Chưa có Bảo hiểm"
    var email = "Chưa có Email"
    var address = "Chưa có địa chỉ"
    var birthDate = "CHưa có          "
    var gender: Bool?
    
    var currentUser: User?
    
    init(data: [String : Any]) {
        super.init()
        
        guard let id = data["Id"] as? Int,
            let name = data["FullName"] as? String,
            let phone = data["Phone"] as? String,
//            let insurance = data["HealthInsurance"] as? String,
            let email = data["Email"] as? String,
//            let address = data["Address"] as? String,
            let birthDate = data["BirthDate"] as? String,
            let gender = data["Gender"] as? Bool
            else { return }
        
        self.id = id
        self.fullName = name
        self.phone = phone
//        self.healthInsurance = insurance
        self.email = email
//        self.address = address
        self.birthDate = birthDate
        self.gender = gender
        
    }
    
    static func setCurrent(_ user: User) {
    
        UserDefaults.standard.set(true, forKey: DidLogin)
        UserDefaults.standard.setValue(user.fullName, forKey: UserName)
        UserDefaults.standard.setValue(user.id, forKey: UserId)
        UserDefaults.standard.setValue(user.phone, forKey: UserPhone)
        UserDefaults.standard.setValue(user.healthInsurance, forKey: UserInsurance)
        UserDefaults.standard.setValue(user.email, forKey: UserEmail)
        
        let str = user.birthDate
        let index = str.index(str.startIndex, offsetBy: 10)
        let mySubstring = str[..<index]
        UserDefaults.standard.setValue(mySubstring, forKey: UserBirthday)
        print(mySubstring)
        
        UserDefaults.standard.setValue(user.gender, forKey: UserGender)
        UserDefaults.standard.set(user.address, forKey: UserAddress)
        
        
        _userName = UserDefaults.standard.string(forKey: UserName)!
        _userId = UserDefaults.standard.integer(forKey: UserId)
        _userAddress = UserDefaults.standard.string(forKey: UserAddress)!
        _userInsurance = UserDefaults.standard.string(forKey: UserInsurance)!
        _userPhone = UserDefaults.standard.string(forKey: UserPhone)!
        _userEmail = UserDefaults.standard.string(forKey: UserEmail)!
        _userBirthday = UserDefaults.standard.string(forKey: UserBirthday)!
    }
    
    static func logoutUser() {
        UserDefaults.standard.set(false, forKey: DidLogin)
        UserDefaults.standard.setValue("", forKey: UserName)
        UserDefaults.standard.setValue(0, forKey: UserId)
        UserDefaults.standard.setValue("", forKey: UserPhone)
        UserDefaults.standard.setValue("", forKey: UserInsurance)
        UserDefaults.standard.setValue("", forKey: UserEmail)
        UserDefaults.standard.setValue("", forKey: UserBirthday)
        UserDefaults.standard.setValue("", forKey: UserGender)
    }
    
    static func setUserForPaintent(_ user: User) {
        userDict[user.fullName] = user
    }
}





