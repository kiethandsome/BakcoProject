//
//  DetailSchedulerViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 3/7/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireSwiftyJSON
import MBProgressHUD

class DetailSchedulerViewController: BaseViewController {
    
    @IBOutlet var schedulerView: UIView!
    @IBOutlet var paintentView: UIView!

    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var serviceNameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var doctorNameLabel: UILabel!
    @IBOutlet var insuranceLabel: UILabel!
    
    @IBOutlet var paintentIdLabel: UILabel!
    @IBOutlet var examIdLabel: UILabel!
    @IBOutlet var paintentNameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var didHaveInsuranceLabel: UILabel!
    
    var currentScheduler: Appointment! {
        didSet {
            hospitalNameLabel.text = currentScheduler.hospital?.Name
            serviceNameLabel.text = currentScheduler.service?.Name
            timeLabel.text = currentScheduler.detail?.from
            priceLabel.text = "\(currentScheduler.price)"
            doctorNameLabel.text = currentScheduler.doctor?.fullName
//            insuranceLabel.text = currentScheduler.
            
            paintentIdLabel.text = "\((currentScheduler.customer?.id)!)"
            examIdLabel.text = "\((currentScheduler.id)!)"
            paintentNameLabel.text = currentScheduler.customer?.fullName
            phoneLabel.text = currentScheduler.customer?.phone
            emailLabel.text = currentScheduler.customer?.email
        }
    }
    
    var id = -1 {
        didSet {
            print("Scheduler id: \(id)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configViewController()
    }
    
    private func configViewController() {
        self.title = "Chi tiết"
        self.showBackButton()
        self.configView(myView: self.schedulerView)
        self.configView(myView: self.paintentView)
        getDetailScheduler(id: id)
    }
    
    private func configView(myView: UIView) {
        myView.layer.cornerRadius = 5.0
        myView.clipsToBounds = true
        myView.layer.borderColor = UIColor.specialGreenColor().cgColor
        myView.layer.borderWidth = 1.0
    }
    
    private func getDetailScheduler(id: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = URL(string: "\(API.getDetailScheduler)/\(id)")
        Alamofire.request(url!, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if response.result.isSuccess {
                let responseData = response.value?.dictionaryObject
                self.currentScheduler = Appointment(data: responseData!)
                print("Price: \(self.currentScheduler.price)")
            } else {
                self.showAlert(title: "Lỗi", mess: (response.error?.localizedDescription)!, style: .alert)
            }
        }
    }
}





