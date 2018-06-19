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
        if let name = data["Name"] as? String {
            Name = name
        } else {
            Name = ""
        }
        if let web = data["Website"] as? String {
            Website = web
        } else {
            Website = ""
        }
        if let address = data["Address"] as? String {
            Address = address
        } else {
            Address = ""
        }
        if let price = data["Price"] as? Int {
            Price = price
        } else {
            Price = 0
        }
    }
}










