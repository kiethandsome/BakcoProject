//
//  RoomModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
class Room: NSObject {
    
    var Id = -1
    var Name = String()
    var HealthCareId = -1
    var HealthCare = -1
    
    override init() {
        super.init()
    }
    
    init(data: [String : Any]) {
        
        if let id = data["Id"] as? Int  {
            Id = id
        } else {
            Id = 0
        }
        
        if let name = data["Name"] as? String {
            Name = name
        } else {
            Name = "No-Room"
        }
        
        if let healthCareId = data["HealthCareId"] as? Int {
            HealthCareId = healthCareId
        } else {
            HealthCareId = 0
        }
        
        if let healthCare = data["HealthCare"] as? Int {
            HealthCare = healthCare
        } else {
            HealthCare = 0
        }
    }
}









