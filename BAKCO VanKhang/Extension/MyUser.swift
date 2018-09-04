//
//  Constant.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 1/26/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation


struct MyUser {
    static var current: User?
    static var name = String()
    static var id = Int()
    static var address = String()
    static var insuranceId = String()
    static var phone = String()
    static var email = String()
    static var birthday = Date()
    static var token = String()
    static var gender = Bool()
    static var provinceCode = String()
    static var districtCode = String()
    static var wardCode = String()
    static var cityName = String()
    static var distName = String()
    static var wardName = String()
    
    /// Tên đăng nhập
    static var username = String() {
        didSet {
            UserDefaults.standard.set(username, forKey: LoginUserName)
        }
    }
}
























