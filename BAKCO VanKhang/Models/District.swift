//
//  District.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/17/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation

class District: NSObject {
    var name = String()
    var value = String()
    override init() {
        super.init()
        self.name = ""
        self.value = ""
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    init(data: [String : Any]) {
        self.name = data["Name"] as! String
        self.value = data["Value"] as! String
        super.init()
    }
}
