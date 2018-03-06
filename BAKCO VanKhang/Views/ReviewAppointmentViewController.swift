//
//  ReviewAppointmentViewController.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/14/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit

class ReviewAppointmentViewController: UIViewController {

    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSpecialty: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblRoomNumber: UILabel!
    
    var hospitalName:String!
    var patientName:String!
    var hospitalAddress:String!
    var specialty:String!
    var date:String!
    var time:String!
    var roomNumber:String!
    
    @IBAction func actViewDetail(_ sender: Any) {
    }
    @IBAction func actPayment(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        lblHospitalName.text = hospitalName
        lblPatientName.text = patientName
        lblAddress.text = hospitalAddress
        lblSpecialty.text = specialty
        lblDate.text = date
        lblTime.text = time
        lblRoomNumber.text = roomNumber
    }
    
    

    

}
