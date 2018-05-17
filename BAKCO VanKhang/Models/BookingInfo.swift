//
//  BookingInfo.swift
//  BAKCO VanKhang
//
//  Created by Lou on 2/20/1397 AP.
//  Copyright © 1397 Lou. All rights reserved.
//

import Foundation

public struct BookingInform {
    static var paintent = User(id: 0, name: "", phone: "", hiid: "", email: "", address: "", birthdate: "", gender: Bool())
    static var hospital = Hospital()
    static var didUseHI = Bool()
    static var hiid = String()
    static var exTypeId = String()
    static var exTypeName = String()
    static var doctor = Doctor()
    static var specialty = Specialty()
    static var scheduler = HealthCareScheduler()
    static var time = HealthCareScheduler.Time()
    static var match = MatchModel()
    static var appointment = Appointment()
    
    static func release() {
        self.hospital = Hospital()
        self.didUseHI = false
        self.exTypeId = String()
        self.exTypeName = ""
        self.doctor = Doctor()
        self.scheduler = HealthCareScheduler()
        self.time = HealthCareScheduler.Time()
        self.hiid = ""
        self.appointment = Appointment()
    }
}
