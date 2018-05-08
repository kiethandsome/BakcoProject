//
//  Specialty.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/21/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

struct Specialty {
    var Id = Int()
    var Name = String()
    var Price = Int()
    var Image = String()
    var Code = String()
    
    init() {
        self.Id = 0
        self.Name = ""
        self.Price = 0
        self.Image = ""
        self.Code = ""
    }
    
    mutating func initWithData(data: [String:Any?]) {
        
        if let id = data["Id"] as? Int {
            Id = id
        } else {
            Id = 0
        }
        if let name = data["Name"] as? String {
            Name = name
        } else {
            Name = "no-name"
        }
        
        if let price = data["Price"] as? Int {
            Price = price
        } else {
            Price = 0
        }
        
        if let image = data["Image"] as? String {
            Image = image
        } else {
            Image = ""
        }
        
        if let code = data["Code"] as? String {
            Code = code
        } else {
            Code = ""
        }
    }
}

