//
//  DoctorService.swift
//  BAKCO VanKhang
//
//  Created by lou on 7/4/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation


struct DoctorService {
    
    var id = Int()
    var name = String()
    var serviceGroup = Int()
    
    init() {}
    
    init(data: [String : Any]) {
        guard let id = data["Id"] as? Int,
            let name = data["Name"] as? String,
            let serviceGroup = data["ServiceGroup"] as? Int
            else { return }
        self.id  = id
        self.name = name
        self.serviceGroup = serviceGroup
    }
}
