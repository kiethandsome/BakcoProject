//
//  Place.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/16/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation

struct Place {
    var city = City()
    var district = District()
    var ward = Ward() {
        didSet {
            self.stringValue = ward.name + " " + district.name + " " + city.name
        }
    }
    var stringValue = String()
    
    init() {
        
    }
    
    init(city: City, district: District, ward: Ward) {
        self.city = city
        self.district = district
        self.ward = ward
    }
}
