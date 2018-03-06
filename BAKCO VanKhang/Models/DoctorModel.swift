//
//  DoctorModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

class Doctor: NSObject {
    
    var id = 0
    var fullName: String?
    var idH: Int?
    var image: String?
    
    init(data: [String : Any]) {
        id = data["Id"] as! Int
        fullName = data["FullName"] as? String
        idH = data["IdH"] as? Int
        image = data["Image"] as? String
    }
}
