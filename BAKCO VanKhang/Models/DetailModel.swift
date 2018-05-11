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
        
        guard let day = data["Time"] as? String,
            let from = data["From"] as? String,
            let to = data["To"] as? String,
            let timeId = data["TimeId"] as? Int
//            let active = data["Active"] as? String
            else { return }
        
        self.timeId = timeId
        self.day = day
        self.from = from
        self.to = to
//        self.active = active
    }
}
