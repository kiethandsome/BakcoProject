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
        lblHospitalName.text = BookingInfo.hospital.Name
        lblAddress.text = BookingInfo.hospital.Address
        exDayLabel.text = BookingInfo.scheduler.DateView
        InsuranceLabel.text = BookingInfo.hiid
        exTypeLabel.text = BookingInfo.serviceType.name
        timeLabel.text = BookingInfo.time.from
        roomNumberLabel.text = BookingInfo.appointment.room.Name
        ///
        numberLabel.text = "\(BookingInfo.appointment.id)"
        userNameLabel.text = "Bệnh nhân: \(MyUser.name)"
        insuranceIDLabel.text = "BHYT: \(MyUser.insuranceId)"
        birthdayLabel.text = "Ngày sinh: \(MyUser.birthday.convertDateToString(with: "dd-MM-yyyy"))"
        phoneNumberLabel.text = "ĐT: \(MyUser.phone)"
    }
    
    @IBAction func okAction(_ sender: Any) {
        self.showAlert(title: "Xác nhận", mess: "Hoàn tất đặt lịch khám, quay về trang chủ?", style: .alert, isSimpleAlert: false)
    }
    
    override func okAction() {
        navigationController?.popToRootViewController(animated: true)
    }
}











