//
//  Place.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/16/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation

struct Place {
    static var city = City()
    static var district = District()
    static var ward = Ward() {
        didSet {
            self.stringValue = ward.name + " " + district.name + " " + city.name
        }
    }
    static var stringValue = String()
    
    static func release() {
        self.city = City()
        self.district = District()
        self.ward = Ward()
        self.stringValue = "Chưa chọn thành phố"
    }
}
