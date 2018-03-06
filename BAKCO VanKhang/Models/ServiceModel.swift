//
//  ServiceModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

class Serviced: NSObject {
    var Id = 0
    var Name: String?
    var Price = 0
    var Image = ""
    var Code = 0

    
    init(data: [String : Any]) {
        Id = data["Id"] as! Int
        Name = data["Name"] as? String
        Price = data["Price"] as! Int
//        Image = data["Image"] as? String
//        Code = data["Code"] as! Int
    }
}
