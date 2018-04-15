//
//  FamilyDoctor.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/13/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation

class FamilyDoctor: NSObject {
    
    var serviceId = String()
    var serviceName = String()
    var serviceTitle = String()
    var doctorId = String()
    var doctorName = String()
    var doctorPhone = String()
    
    init(data: [String : Any]) {
        super.init()
        guard let serviceId = data["service_id"] as? String,
            let serviceName = data["service_name"] as? String,
            let serviceTitle = data["service_title"] as? String,
            let doctorId = data["doctor_id"] as? String,
            let doctorName = data["doctor_name"] as? String,
            let doctorPhone = data["doctor_phone"] as? String
            else { return }
        self.serviceId = serviceId
        self.serviceName = serviceName
        self.serviceTitle = serviceTitle
        self.doctorId = doctorId
        self.doctorName = doctorName
        self.doctorPhone = doctorPhone
    }
    
}
