//
//  ReviewAppointmentViewController.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/14/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit

class ReviewAppointmentViewController: BaseViewController {

    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSpecialty: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblRoomNumber: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton()
        navigationItem.title = "Phiếu hẹn"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    
    

    

}
