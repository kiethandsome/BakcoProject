//
//  HealthCareSchedulerModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 12/20/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

public struct HealthCareScheduler {
    
    var Date = String()
    var DateView = String()
    var morning: [Time] = []
    var afternoon: [Time] = []
    
    public struct Time {
        var timeId = Int()
        var time = String()
        var from = String()
        var to = String()
        var active = Bool()
        
        init() {}
        
        init(data: [String : Any]) {
            
            if let timeId = data["TimeId"] as? Int {
                self.timeId = timeId
            }
            if let time = data["Time"] as? String {
                self.time = time
            }
            if let from = data["From"] as? String {
                self.from = from
            }
            if let to = data["To"] as? String {
                self.to = to
            }
            if let active = data["Active"] as? Bool {
                self.active = active
            }
        }
    }
    
    init() {}

    init(data: [String : Any]) {
        
        if let date = data["Date"] as? String {
            self.Date = date
        } else {
            self.Date = ""
        }
        
        if let dateView = data["DateView"] as? String {
            self.DateView = dateView
        } else {
            self.DateView = ""
        }
        
        if let morningTime = data["Morning"] as? [[String: Any]] {
            self.morning.removeAll()
            morningTime.forEach({ (data) in
                let time = Time(data: data)
                self.morning.append(time)
            })
        }
        
        if let afternoonTime = data["Afternoon"] as? [[String: Any]] {
            self.afternoon.removeAll()
            afternoonTime.forEach({ (data) in
                let time = Time(data: data)
                self.afternoon.append(time)
            })
        }
    }
    
}






















