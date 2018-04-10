//
//  HealthInsurance.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/9/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation

struct HealthInsurance {
    
    var id = String()
    
    var place = String()
    
    var startDate = String()
    
    var endDate = String()
    
    init(data: [String : Any]) {
        
        self.id = data["HealthInsurance_Start_No"] as! String
        self.place = data["HealthInsurance_Place"] as! String
        self.startDate = data["HealthInsurance_Start"] as! String
        self.endDate = data["HealthInsurance_End"] as! String

    }
    
}
