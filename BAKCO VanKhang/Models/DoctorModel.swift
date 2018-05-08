//
//  DoctorModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

struct Doctor {
    
    var id = Int()
    var fullName = String()
    var idH = Int()
    var image = String()
    
    init() {
        id = 0
        fullName = ""
        idH = 0
        image = ""
    }
    
    init(data: [String : Any]) {
        
        if let id = data["Id"] as? Int {
            self.id = id
        } else {
            self.id = 0
        }
        
        if let fullName = data["FullName"] as? String {
            self.fullName = fullName
        } else {
            self.fullName = "Chưa có tên"
        }
        
        if let idH = data["IdH"] as? Int {
            self.idH = idH
        } else {
            self.idH = 0
        }
        
        if let image = data["Image"] as? String {
            self.image = image
        } else {
            self.image = ""
        }
    }
}










