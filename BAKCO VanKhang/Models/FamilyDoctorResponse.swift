//
//  FamilyDoctorResponse.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 3/24/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation

struct FdData {
    var title: String
    var serviceId: String
    var serviceName: String
    var introText: String
}

class FamilyDoctorResponse: NSObject {
    var status = Bool()
    var message = String()
    var fdData: FdData?
    var totalRow = String()
    
    init(data: [String : Any]) {
        
        if let status = data["status"] as? Bool {
            self.status = status
        } else {
            self.status = false
        }
        
        if let mess = data["mess"] as? String {
            self.message = mess
        } else {
            self.message = ""
        }
        
        if let fdData = data["data"] as? [String : String] {
            
            if let introtext = fdData["introtext"] {
                if let title = fdData["title"],
                    let serviceId = fdData["service_id"],
                    let serviceName = fdData["service_name"]
                {
                    self.fdData = FdData(title: title, serviceId: serviceId, serviceName: serviceName, introText: introtext)
                }
            } else {
                if let title = fdData["title"],
                    let serviceId = fdData["service_id"],
                    let serviceName = fdData["service_name"]
                {
                    self.fdData = FdData(title: title, serviceId: serviceId, serviceName: serviceName, introText: "Dịch vụ khác ...")
                }
            }

        } else {
            self.fdData = FdData(title: "N/A", serviceId: "N/A", serviceName: "N/A", introText: "N/A")
        }
        
        if let totalRow = data["total_row"] as? String {
            self.totalRow = totalRow
        } else {
            self.totalRow = ""
        }
        super.init()
    }
}
