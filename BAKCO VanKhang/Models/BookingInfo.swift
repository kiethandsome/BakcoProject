//
//  BookingInfo.swift
//  BAKCO VanKhang
//
//  Created by Lou on 2/20/1397 AP.
//  Copyright © 1397 Lou. All rights reserved.
//

import Foundation

public struct BookingInfo {
    static var patient = Constant.emtyUser
    static var hospital = Hospital()
    static var didUseHI = Bool()
    static var hiid = String()
    static var exTypeId = String()
    static var exTypeName = String()
    static var doctor = Doctor()
    static var doctorService = DoctorService()
    static var specialty = Specialty()
    static var scheduler = HealthCareScheduler()
    static var time = HealthCareScheduler.Time()      
    static var match = MatchModel()
    static var appointment = Appointment()
    static var serviceType = ServiceType()
    
    static func release() {
        self.patient = Constant.emtyUser
        self.hospital = Hospital()
        self.didUseHI = false
        self.exTypeId = String()
        self.exTypeName = ""
        self.doctor = Doctor()
        self.scheduler = HealthCareScheduler()
        self.time = HealthCareScheduler.Time()
        self.hiid = ""
        self.appointment = Appointment()
        self.doctorService = DoctorService()
    }
}
