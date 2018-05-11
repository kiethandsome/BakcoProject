//
//  FinalAppointmentViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/20/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

class FinalAppointmentViewController: BaseViewController {
    
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var insuranceIDLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var exTypeLabel: UILabel!
    @IBOutlet var InsuranceLabel: UILabel!
    @IBOutlet var exDayLabel: UILabel!
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var roomNumberLabel: UILabel!
    var isPaid = Bool()
    
    @IBOutlet var paidmentStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Phiếu hẹn"
        showBackButton()
        if isPaid {
            paidmentStatusLabel.text = "Tình trạng thanh toán: Đã thanh toán"
        } else {
            paidmentStatusLabel.text = "Tình trạng thanh toán: Chưa thanh toán"
        }
        
        lblHospitalName.text = BookingInform.hospital.Name
        lblAddress.text = BookingInform.hospital.Address
        exDayLabel.text = BookingInform.scheduler.DateView
        InsuranceLabel.text = BookingInform.hiid
        exTypeLabel.text = BookingInform.exTypeName
        timeLabel.text = BookingInform.time.from
        roomNumberLabel.text = ""
        
        ///
        userNameLabel.text = "Bệnh nhân: \(MyUser.name)"
        insuranceIDLabel.text = "BHYT: \(MyUser.insuranceId)"
        birthdayLabel.text = "Ngày sinh: \(MyUser.birthday)"
        phoneNumberLabel.text = "ĐT: \(MyUser.phone)"
    }
    
    @IBAction func okAction(_ sender: Any) {
        self.showAlert(title: "Xác nhận", mess: "Hoàn tất đặt lịch khám, quay về trang chủ?", style: .alert, isSimpleAlert: false)
    }
    
    override func okAction() {
        navigationController?.popToRootViewController(animated: true)
    }
}











