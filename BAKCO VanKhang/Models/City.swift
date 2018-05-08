//
//  City.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/2/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation

class City: NSObject {
    
    var name = String()
    
    var value = String()
    
    override init() {
        super.init()
        self.name = ""
        self.value = ""
    }
    
    init(data: [String : Any]) {
        
        self.name = data["Name"] as! String
        self.value = data["Value"] as! String
        super.init()
    }
}

class District: NSObject {
    
    var name = String()
    
    var value = String()
    
    override init() {
        super.init()
        self.name = ""
        self.value = ""
    }
    
    init(data: [String : Any]) {
        
        self.name = data["Name"] as! String
        self.value = data["Value"] as! String
        super.init()
    }
}

class Ward: NSObject {
    
    var name = String()
    
    var value = String()
    
    override init() {
        super.init()
        self.name = ""
        self.value = ""
    }
    
    init(data: [String : Any]) {
        
        self.name = data["Name"] as! String
        self.value = data["Value"] as! String
        super.init()
    }
}







