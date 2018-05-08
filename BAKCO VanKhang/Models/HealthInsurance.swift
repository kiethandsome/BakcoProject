//
//  HealthInsurance.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/9/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation

struct HealthInsurance {
    
    var id = ""
    
    var place = ""
    
    var startDate = String()
    
    var endDate = String()
    
    init(data: [String : Any]) {
        
        /// Gán ngày hiện tại cho ngày cấp và hết hạn của số BH trước khi có dữ liệu.
        self.startDate = getCurrentDate()
        self.endDate = getCurrentDate()
        
        guard let id = data["HealthInsurance_Start_No"] as? String,
            let place = data["HealthInsurance_Place"] as? String,
            let startDate = data["HealthInsurance_Start"] as? String,
            let endDate = data["HealthInsurance_End"] as? String
            else { return }

        self.id = id
        self.place = place
        self.startDate = startDate
        self.endDate = endDate
    }
    
    private func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let result = formatter.string(from: date)
        return result
    }
    
}
