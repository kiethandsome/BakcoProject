//
//  HealthCareSchedulerModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 12/20/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
struct HealthCareSchedulerModel {
    var Date: String?
    var DateView: String?
    
    mutating func initWithData(data: [String:Any]?) {
        Date = data!["Date"] as? String
        DateView = data!["DateView"] as? String
        
    }
    
}
