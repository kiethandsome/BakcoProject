//
//  HealthCareModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 10/23/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

struct MatchModel {
    
    var schedulerId = -1
    var customerId = -1
    
    init() {
        
    }
    
    init(data: [String:Any]) {
        
        guard let schedule = data["HealthCareSchedulerId"] as? Int,
            let customerId = data["CustomerId"] as? Int
            else { return }
                
        self.schedulerId = schedule
        self.customerId = customerId
        
    }
    
}
