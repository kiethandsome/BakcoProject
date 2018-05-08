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
    var gender = true
    
//    private static var _currentUser: User?
//    
//    static var current: User { /// Get only varriable
//        guard let currentUser = _currentUser else {
//            fatalError("Error: current user doesnt exsist")
//        }
//        return currentUser
//    }
    
    init(id: Int, name: String, phone: String, hiid: String, email: String, address: String, birthdate: String, gender: Bool) {
        super.init()
        self.id = id
        self.phone = phone
        self.healthInsurance = hiid
        self.email = email
        self.address = address
        self.birthDate = birthdate
        self.gender = gender
        self.fullName = name
    }
    
    init(data: [String : Any]) {
        super.init()
        
        if let id = data["Id"] as? Int {
            self.id = id
        }
        
        if let name = data["FullName"] as? String {
            self.fullName = name
        }
        
        if let phone = data["Phone"] as? String {
            self.phone = phone
        }
        
        if let hiid = data["HealthInsurance"] as? String {
            self.healthInsurance = hiid
        }

        if let email = data["Email"] as? String {
            self.email = email
        }
        
        if let address = data["Address"] as? String {
            self.address = address
        }
        
        if let birthdate = data["BirthDate"] as? String {
            self.birthDate = birthdate
        }
        
        if let gender = data["Gender"] as? Bool {
            self.gender = gender
        }
        
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        guard let id = aDecoder.decodeObject(forKey: UserId) as? Int,
//            let username = aDecoder.decodeObject(forKey: UserName) as? String,
//            let hiid = aDecoder.decodeObject(forKey: UserInsurance) as? String,
//            let email = aDecoder.decodeObject(forKey: UserEmail) as? String,
//            let phone = aDecoder.decodeObject(forKey: UserPhone) as? String,
//            let address = aDecoder.decodeObject(forKey: UserAddress) as? String,
//            let birthDate = aDecoder.decodeObject(forKey: UserBirthday) as? String,
//            let gender = aDecoder.decodeObject(forKey: UserGender) as? Bool
//            else { return nil }
//
//        self.id = id
//        self.fullName = username
//        self.address = address
//        self.birthDate = birthDate
//        self.healthInsurance = hiid
//        self.phone = phone
//        self.gender = gender
//        self.email = email
//
//        super.init()
//    }
    
    static func setCurrent(_ user: User) {
        let str = user.birthDate
        let index = str.index(str.startIndex, offsetBy: 10) /// Cắt bỏ phần giờ phía sau ngày sinh do server trả về
        let mySubstring = str[..<index]
        print(mySubstring)
    
        /// Set value for userDefault
        UserDefaults.standard.set(true, forKey: DidLogin)
        UserDefaults.standard.setValue(user.fullName, forKey: UserName)
        UserDefaults.standard.setValue(user.id, forKey: UserId)
        UserDefaults.standard.setValue(user.phone, forKey: UserPhone)
        UserDefaults.standard.setValue(user.healthInsurance, forKey: UserInsurance)
        UserDefaults.standard.setValue(user.email, forKey: UserEmail)
        UserDefaults.standard.setValue(mySubstring, forKey: UserBirthday)
        UserDefaults.standard.setValue(user.gender, forKey: UserGender)
        UserDefaults.standard.set(user.address, forKey: UserAddress)
        
        setCurrentToMyUser()
        
//        _currentUser = user
    }
    
    
    private static func setCurrentToMyUser() {  /// Gán dữ liệu cho My User hỗ trợ Get thuộc tính user Nhanh gọn.
        MyUser.name = UserDefaults.standard.string(forKey: UserName)!
        MyUser.id = UserDefaults.standard.integer(forKey: UserId)
        MyUser.address = UserDefaults.standard.string(forKey: UserAddress)!
        MyUser.insuranceId = UserDefaults.standard.string(forKey: UserInsurance)!
        MyUser.phone = UserDefaults.standard.string(forKey: UserPhone)!
        MyUser.email = UserDefaults.standard.string(forKey: UserEmail)!
        MyUser.birthday = UserDefaults.standard.string(forKey: UserBirthday)!
        MyUser.gender = UserDefaults.standard.bool(forKey: UserGender)
    }
    
//    class func setCurrent(_ user: User, writeToUserDefalt: Bool = false) {
//        UserDefaults.standard.set(true, forKey: DidLogin)
//        if writeToUserDefalt {
//            let data = NSKeyedArchiver.archivedData(withRootObject: user)
//            UserDefaults.standard.set(data, forKey: CurrentUser)
//        }
//        _currentUser = user
//    }
    
    static func logoutUser() {
        UserDefaults.standard.set(false, forKey: DidLogin)
        UserDefaults.standard.setValue("", forKey: UserName)
        UserDefaults.standard.setValue(0, forKey: UserId)
        UserDefaults.standard.setValue("", forKey: UserPhone)
        UserDefaults.standard.setValue("", forKey: UserInsurance)
        UserDefaults.standard.setValue("", forKey: UserEmail)
        UserDefaults.standard.setValue("", forKey: UserBirthday)
        UserDefaults.standard.setValue("", forKey: UserGender)
        UserDefaults.standard.set(nil, forKey: CurrentUser)
    }
}

//extension User: NSCoding {
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(id, forKey: UserId)
//        aCoder.encode(fullName, forKey: UserName)
//        aCoder.encode(phone, forKey: UserPhone)
//        aCoder.encode(healthInsurance, forKey: UserInsurance)
//        aCoder.encode(email, forKey: UserEmail)
//        aCoder.encode(birthDate, forKey: UserBirthday)
//        aCoder.encode(gender, forKey: UserGender)
//        aCoder.encode(address, forKey: UserAddress)
//    }
//}














