//
//  TestViewController.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 1/2/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import UIKit
import SwiftR

class TestViewController: BaseViewController{

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var bigNotificationLabel: UILabel!
    
    var centerHub: Hub!
    var connection = SignalR("http://api.vkhealth.vn/signalr/hubs")
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCancelButton()
        navigationItem.title = "Cấp cứu!"
        
        connection.useWKWebView = true
        connection.signalRVersion = .v2_0_0
        connection.queryString = ["accessToken": "longhdt"]
        centerHub = Hub("centerHub")
        centerHub.on("receiveSOSDoctorLocation")  { args in
            let s = args![0] as! String
            print(s)
            self.notificationLabel.text = s
            self.bigNotificationLabel.text = "Đã tiếp nhận yêu cầu của bạn!"
        }
        connection.addHub(centerHub)
        
        // SignalR events
        
        connection.starting = { [weak self] in
            self?.statusLabel.text = "Starting..."
        }
        
        connection.reconnecting = { [weak self] in
            self?.statusLabel.text = "Reconnecting..."
        }
        
        connection.connected = { [weak self] in
            print("Connection ID: \(self!.connection.connectionID!)")
            self?.statusLabel.text = "Connected"
        }
        
        connection.reconnected = { [weak self] in
            self?.statusLabel.text = "Reconnected. Connection ID: \(self!.connection.connectionID!)"
        }
        
        connection.disconnected = { [weak self] in
            self?.statusLabel.text = "Disconnected"
        }
        
        connection.connectionSlow = { print("Connection slow...") }
        
        connection.error = { [weak self] error in
            print("Error: \(String(describing: error))")
            if let source = error?["source"] as? String, source == "TimeoutException" {
                print("Connection timed out. Restarting...")
                self?.connection.start()
            }
        }
        connection.start()
    }
    
    func send() {
        let username = "longhdt"
        let password = "zaq@123A"
        
        if let hub = centerHub {
            do {
                try hub.invoke("iAmAvailable", arguments: [username,password,"con chim non"]) { (result, error) in
                    if let e = error {
                        print("Error: \(e)")
                    } else {
                        print("Success!")
                        if let r = result {
                            print("Result: \(r)")
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
















