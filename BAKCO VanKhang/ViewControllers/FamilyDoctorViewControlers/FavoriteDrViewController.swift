//
//  FavoriteDrViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/11/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import MBProgressHUD

class FavoriteDrViewController: BaseViewController {
    
    var serviceId = String()
    
    @IBOutlet var favDoctorTableview: UITableView!
    @IBOutlet var searchDoctorNameTexfield: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    @IBAction func searchButtonAction(_ sender: Any) {
        guard let text = searchDoctorNameTexfield.text else {return}
        self.getDoctors(serviceId: serviceId, phone: MyUser.phone, keyWord: text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDoctorNameTexfield.delegate = self
    }
}

//Mark: API request.

extension FavoriteDrViewController {
    
    func getFavoriteDoctors(phone: String, serviceId: String) {
        let param: Parameters = [ "Phone": phone,
                                  "ServiceId": serviceId ]
        MBProgressHUD.showAdded(to: self.view , animated: true)
        self.requestAPIwith(urlString: FamilyDocrorApi.favoriteDoctorList, method: .post, params: param) { (responseDict) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(responseDict)
        }
    }
    
    func getDoctors(serviceId: String, phone: String, keyWord: String) {
        let param: Parameters = [ "Phone": phone,
                                  "ServiceId": serviceId,
                                  "Keyword" : keyWord]
        let url = URL(string: FamilyDocrorApi.doctorListByService)!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}

//Mark: UITextField Delegate.

extension FavoriteDrViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text == "" {
            self.searchButton.isEnabled = false
            self.searchButton.backgroundColor = UIColor.lightGray
        } else {
            self.searchButton.isEnabled = true
            self.searchButton.backgroundColor = UIColor.specialGreenColor()
        }
    }
    
}
















