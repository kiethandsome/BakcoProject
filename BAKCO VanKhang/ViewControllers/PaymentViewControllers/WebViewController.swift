//
//  WebViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/13/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBAction func success(_ sender: Any) {
        let next = storyboard?.instantiateViewController(withIdentifier: "FinalAppointmentViewController") as! FinalAppointmentViewController
        next.isPaid = true
        navigationController?.pushViewController(next, animated: true)
    }

    @IBOutlet var webViewww: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewww.delegate = self
        webViewww.loadRequest(URLRequest(url: URL(string: "http://vkhs.vn/index_bak.html#/mpayment/1")! ))
        
    }

    

 

}


