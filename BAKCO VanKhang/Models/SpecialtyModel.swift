//
//  SpecialtyModel.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/21/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

struct SpecialtyModel {
    var Id: Int?
    var Name: String?
    var Price: Int?
    var Image: String?
    var Code: String?
    var Description: String?
    
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
        
        if let description = data["Description"] as? String {
            Description = description
        } else {
            Description = ""
        }
        
    }
}

