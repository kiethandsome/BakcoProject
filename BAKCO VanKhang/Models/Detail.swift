//
//  DetailModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

class DetailModel: NSObject {
    
    var timeId = -1
    var day = String()
    var from = String()
    var to = String()
    var active = String()
    
    override init() {
        super.init()
    }
    
    init(data: [String : Any]) {
        
        if let day = data["Time"] as? String {
            self.day = day
        } else {
            self.day = "Chưa có ngày khám"
        }
        
        if let from = data["From"] as? String {
            self.from = from
        } else {
            self.from = "Chưa có giờ"
        }
        
        if let to = data["To"] as? String {
            self.to = to
        } else {
            self.to = "Chưa có giờ đến"
        }
        
        if let timeId = data["TimeId"] as? Int {
            self.timeId = timeId
        }
        
        if let active = data["Active"] as? String {
            self.active = active
        }
    }
}










