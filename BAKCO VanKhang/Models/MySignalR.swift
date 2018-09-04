//
//  MySignalR.swift
//  BAKCO VanKhang
//
//  Created by lou on 8/25/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import SwiftR

struct MySignalR {
    
    static let connection = SignalR("http://api.vkhealth.vn/signalr/hubs")
    
    static let hub = Hub("centerHub")
    
    static var isFirstTimeUsing = true
    
    static func autoSetup() {
        if isFirstTimeUsing {
            connection.useWKWebView = true
            connection.signalRVersion = .v2_0_0
            connection.queryString = ["accessToken": MyUser.username]
            connection.addHub(hub)
            isFirstTimeUsing = false
        }
        
    }
}

