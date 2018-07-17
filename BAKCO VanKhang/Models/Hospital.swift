//
//  Hospital.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 10/23/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

public struct Hospital {
    var Id: Int
    var Name: String
    var Image: String
    var Website: String
    var Price: Int
    var Address: String
    
    public init() {
        self.Id = -1
        self.Name = ""
        self.Image = ""
        self.Website = ""
        self.Price = -1
        self.Address = ""
    }

    
    init(data: [String : Any]) {
        if let id = data["Id"] as? Int {
            Id = id
        } else {
            Id = 0
        }
        if let image = data["Image"] as? String {
            Image = image
        } else {
            Image = ""
        }
        if let name = data["Name"] as? String, name != "" {
            Name = name
        } else {
            Name = "Đang cập nhật"
        }
        if let web = data["Website"] as? String, web != "" {
            Website = web
        } else {
            Website = "Đang cập nhật"
        }
        if let address = data["Address"] as? String, address != "" {
            Address = address
        } else {
            Address = "Đang cập nhật"
        }
        if let price = data["Price"] as? Int {
            Price = price
        } else {
            Price = 0
        }
    }
}










