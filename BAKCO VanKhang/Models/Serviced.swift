//
//  ServiceModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

class Serviced: NSObject {
    var Id = -1
    var Name = String()
    var Price = -1
    var Image = ""
    var Code = -1
    
    override init() {
        super.init()
    }

    
    init(data: [String : Any]) {
        
        guard let id = data["Id"] as? Int,
            let name = data["Name"] as? String,
            let price = data["Price"] as? Int
//            let image = data["Image"] as? String,
//            let code = data["Code"] as? Int
        else { return }
        
        self.Id = id
        self.Name = name
        self.Price = price
//        self.Image = image
//        self.Code = code
    }
}
