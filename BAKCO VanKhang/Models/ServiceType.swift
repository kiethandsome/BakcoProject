//
//  HospitalService.swift
//  BAKCO VanKhang
//
//  Created by lou on 7/20/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation

struct ServiceType {
    
    var canChooseDoctor = Bool()
    var canPostPay = Bool()
    var canUseHI = Bool()
    var canChooseHour = Bool()
    var id = Int()
    var name = String()
    
    init() {}
    
    init(data: [String : Any]) {
        
        if let canChooseDoctor = data["CanChoiceDoctor"] as? Bool {
            self.canChooseDoctor = canChooseDoctor
        }
        
        if let canPostPay = data["CanPostPay"] as? Bool {
            self.canPostPay = canPostPay
        }
        
        if let canUseHI = data["CanUseHealthInsurance"] as? Bool {
            self.canUseHI = canUseHI
        }
        
        if let canChooseHour = data["CanChoiceHour"] as? Bool {
            self.canChooseHour = canChooseHour
        }
        
        if let name = data["Name"] as? String {
            self.name = name
        }
        
        if let id = data["Id"] as? Int {
            self.id = id
        }
        
    }
}
