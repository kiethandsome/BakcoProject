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
import SwiftyJSON

class HomedTreatmentViewController: BaseViewController {
    
    var serviceId = String() {
        didSet {
            print(serviceId)
        }
    }
    
    @IBAction func selectMedicalStaff(_ sender: Any) {
        let vc = MyStoryboard.familyDoctorStoryboard.instantiateViewController(withIdentifier: "FavoriteDrViewController") as! FavoriteDrViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func selectUsedMedicalStaff(_ sender: Any) {
        self.checkFamilyDoctorServiceStatus()

    }
    
    @IBAction func automaticallyCalling(_ sender: Any) {

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Bác sĩ gia đình"
        showCancelButton()
    }
    
    
    func checkFamilyDoctorServiceStatus() {
        let url = URL(string: FamilyDocrorApi.serviceStatus)!
        let param: Parameters = [
            "ServiceId": serviceId,
            "SosPhone": MyUser.phone
        ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if response.result.isSuccess {
                print(response)
                let responseDict = response.value?.dictionaryObject!
                let fDResponse = FamilyDoctorResponse(data: responseDict!)
                if fDResponse.status == true {
                    
                } else {
                    self.showAlert(title: "Thông báo", mess: fDResponse.message, style: .alert)
                }
            } else {
                self.showAlert(title: "Lỗi", mess: (response.error?.localizedDescription)!, style: .alert)
            }
        }
    }
    
}
















