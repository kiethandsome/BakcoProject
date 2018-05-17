//
//  ReviewSpecialtyViewController.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/14/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import AlamofireSwiftyJSON
import Alamofire
import MBProgressHUD


class FirstAppointmentViewController: BaseViewController {

    @IBOutlet var srollView: UIScrollView!
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var insuranceIDLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var exTypeLabel: UILabel!
    @IBOutlet var InsuranceLabel: UILabel!
    @IBOutlet var exDayLabel: UILabel!
    @IBOutlet weak var doctorLabel: UILabel!
    
    /// Những thông tin từ api response.
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var roomNumberLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Xác nhận"
        showBackButton()
        setupAlreadyContent()
        setupApiResponseContent()
    }
    
    override func popToBack() {
        BookingInform.release()
        navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate func setupAlreadyContent() {
        lblHospitalName.text = BookingInform.hospital.Name
        lblAddress.text = BookingInform.hospital.Address
        exDayLabel.text = BookingInform.scheduler.DateView
        InsuranceLabel.text = BookingInform.didUseHI ? "Sử dụng BHYT: Có" : "Sử dụng BHYT: Không"
        exTypeLabel.text = BookingInform.exTypeName
        ///
        userNameLabel.text = "Bệnh nhân: " + MyUser.name
        insuranceIDLabel.text = "BHYT: " + MyUser.insuranceId
        birthdayLabel.text = "Ngày sinh: " + MyUser.birthday
        phoneNumberLabel.text = "ĐT: " + MyUser.phone
        
        if BookingInform.exTypeId == extypeDict[Expert] {
            doctorLabel.text = BookingInform.doctor.fullName
        }
    }
    
    fileprivate func setupApiResponseContent() {
        numberLabel.text = "\( BookingInform.appointment.id)"
        timeLabel.text = BookingInform.appointment.detail.from
        roomNumberLabel.text = BookingInform.appointment.room.Name
    }
    
    @IBAction func confirm(_ sender: Any) {
        let next = MyStoryboard.paymentStoryboard.instantiateViewController(withIdentifier: "PayViewController")
        navigationController?.pushViewController(next, animated: true)
    }
    
}
























