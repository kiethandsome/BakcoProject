//
//  RoomModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
class Room: NSObject {
    
    var Id: Int?
    var Name: String?
    var HealthCareId:Int?
    var HealthCare: Int?
    
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









