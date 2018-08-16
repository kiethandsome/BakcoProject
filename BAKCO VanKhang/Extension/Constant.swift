//
//  Constant.swift
//  BAKCO VanKhang
//
//  Created by Lou on 2/22/1397 AP.
//  Copyright © 1397 Lou. All rights reserved.
//

import Foundation

struct Constant {
    
    static let exTypeDict = [Normal : "0",
                             Service : "1",
                             Expert : "2"]
    
    static var paintentList: [User?] = [MyUser.current]
    static var paintentNameList: [String] = []
    
    static let insertUserString = "Thêm bệnh nhân"
    
    static let yes = "Có"
    static let no = "Không"
    
    static let emtyUser = User(id: 0, name: "", phone: "", hiid: "", email: "", address: "", birthdate: Date(), gender: false, districtCode: "0", wardCode: "0", provinceCode: "0")
    
    static let format = "yyyy-MM-dd'T'HH:mm:ss"
    
}
