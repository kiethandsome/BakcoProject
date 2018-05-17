//
//  AppointmentModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

let Expert = "Chuyên gia"
let Service = "Dịch vụ"
let Normal = "Thông thường"

let exTypeArray = [Normal, Service, Expert]

class Appointment: NSObject {
    
    var id = Int()
    var hospital = Hospital()
    var doctor = Doctor()
    var room = Room()
    var customer: User?
    var service = Serviced()
    var detail = DetailModel()
    var price = -1
    var statusCode = -1
    var statusLabel = -1
    var type = ""
    
    override init() {
        super.init()
    }

    init(data: [String : Any]) {
        
        if let roomData = data["Room"] as? [String : Any] {
            self.room = Room(data: roomData)
        } else {
            print("\n No room data!")
        }
        
        if let hospitalData = data["Hospital"] as? [String : Any] {
            self.hospital = Hospital(data: hospitalData)
        } else {
            print("\n No hospital data!")
        }
        
        if let doctorData = data["Doctor"] as? [String : Any] {
            self.doctor = Doctor(data: doctorData)
            
        } else {
            print("\n No doctor data!")
        }
        
        if let serviceData = data["Service"] as? [String : Any] {
            self.service = Serviced(data: serviceData)
        } else {
            print("\n No detail data!")
        }
        
        if let detailData = data["Detail"] as? [String : Any] {
            self.detail = DetailModel(data: detailData)
        } else {
            
        }
        
        if let customerData = data["Customer"] as? [String : Any] {
            self.customer = User(data: customerData)
        } else {
            print("\n No customer Data")
        }
        
        if let priceData = data["Price"] as? Int {
            self.price  = priceData
        } else {
            self.price = 0
        }
        
        if let id = data["Id"] as? Int {
            self.id = id
        } else {
            self.id = 0
        }
        
        if let type = data["Type"] as? Int {
            for enumm in exTypeArray.enumerated() {
                if type == enumm.offset {
                    self.type = enumm.element
                }
            }
        }
    }
}









