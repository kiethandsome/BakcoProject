//
//  Location.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/3/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation

struct Location: Codable {
    var success: Bool
    var message: String
    var data: LocationData
}

struct LocationData: Codable {
    var LocationList: [LocationItem]
}

struct LocationItem: Codable {
    var LocID: Int!
    var LocName: String!
}
