//
//  PayViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/20/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit
import DynamicColor

class PayViewController: BaseViewController {
    
    @IBOutlet var confirmButton: UIButton!
    var isPayNow = false
    var currentColor: UIColor = DynamicColor(hexString: "BCBEBE")

    @IBOutlet var payLaterButton: UIButton!
    @IBOutlet var payNowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Thanh toán"
        showBackButton()
        setEnableForConfirmButton(value: false)
    }
    
    @IBAction func payNoww(_ sender: Any) {
        isPayNow = true
        payNowButton.backgroundColor = .orange
        payLaterButton.backgroundColor = currentColor
        setEnableForConfirmButton(value: true)
    }
    
    
    @IBAction func payLater(_ sender: Any) {
        isPayNow = false
        payLaterButton.backgroundColor = .orange
        payNowButton.backgroundColor = currentColor
        setEnableForConfirmButton(value: true)
    }
    
    @IBAction func confirm(_ sender: Any) {
        if isPayNow {
//            let next = storyboard?.instantiateViewController(withIdentifier: "WebViewController")
//            navigationController?.pushViewController(next!, animated: true)
            showAlert(title: "Xin lỗi", mess: "Chức năng thanh toán trước đang được phát triển, vui lòng chọn thanh toán sau!", style: .alert)
        } else {
            let next = MyStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "FinalAppointmentViewController") as! FinalAppointmentViewController
            next.isPaid = false
            navigationController?.pushViewController(next, animated: true)
        }
    }
    
    private func setEnableForConfirmButton(value: Bool) {
        if value == true {
            self.confirmButton.backgroundColor = UIColor.specialGreenColor()
            self.confirmButton.isUserInteractionEnabled = true
        } else {
            self.confirmButton.backgroundColor = UIColor.gray
            self.confirmButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        navigationController?.popToRootViewController(animated: true)
    }
    
}






