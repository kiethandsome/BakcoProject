//
//  HomedTreatment.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 1/19/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire
import AlamofireSwiftyJSON

class HomedTreatmentViewController: BaseViewController {
    
    var serviceId = String() {
        didSet {
            print(serviceId)
        }
    }
    
    @IBAction func selectMedicalStaff(_ sender: Any) {
        self.getFavoriteDoctorList(serviceId: self.serviceId, phone: MyUser.phone)
    }
    
    @IBAction func selectUsedMedicalStaff(_ sender: Any) {
        self.showAlertController()

    }
    
    @IBAction func automaticallyCalling(_ sender: Any) {
        self.showAlertController()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Bác sĩ gia đình"
        showCancelButton()
    }

    
    private func showAlertController() {
        self.showAlert(title: "Xin lỗi", mess: "Chức năng hiện đang phát triền, vui lòng cập nhật ở phiên bản tiếp theo. \n Xin cám ơn!", style: .alert)
    }
    
    private func getFavoriteDoctorList(serviceId: String, phone: String) {
        let param: Parameters = [ "Phone": phone,
                                  "ServiceId": serviceId ]
        MBProgressHUD.showAdded(to: self.view , animated: true)
        self.requestAPIwith(urlString: FamilyDocrorApi.favoriteDoctorList, method: .post, params: param) { (responseDict) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(responseDict)
        }
    }
    
}
















