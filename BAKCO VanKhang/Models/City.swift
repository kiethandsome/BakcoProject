//
//  City.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/2/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation

class City : NSObject {
    
    var name: String!
    
    var value: String!
    
    init(data: [String : Any]) {
        super.init()
        self.name = data["Name"] as! String
        self.value = data["Value"] as! String
    }
}

struct District {
    
    var name = String()
    
    var value = String()
    
    init(data: [String : Any]) {
        self.name = data["Name"] as! String
        self.value = data["Value"] as! String
    }
}

struct Ward {
    
    var name = String()
    
    var value = String()
    
    init(data: [String : Any]) {
        self.name = data["Name"] as! String
        self.value = data["Value"] as! String
    }
}







