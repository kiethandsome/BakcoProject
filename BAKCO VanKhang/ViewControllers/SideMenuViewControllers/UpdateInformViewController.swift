//
//  UpdateInformViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/21/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit
import IQDropDownTextField
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import MBProgressHUD

class UpdateInformViewController: BaseViewController {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var phoneTextfield: UITextField!
    @IBOutlet var sosPhoneTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var birthdayTextfield: IQDropDownTextField!
    @IBOutlet var addressTextfield: UITextField!
    @IBOutlet var hiTextfield: UITextField!
    @IBOutlet var pesonalIdTextfield: UITextField!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    
    @IBAction func choosePlaces(_ sender: Any) {
        
    }
    
    @IBAction func confirmUpdate(_ sender: Any) {
        ///Update User Information
        let url = URL(string: _UpdateInformApi)!
        let parameters: Parameters = [
            "Username": usernameTextfield.text!,
            "Password": "password",
            "FullName": "fullName",
            "Phone": "phone",
            "Email": "email",
            "HealthInsurance": "",
            "Address": "address",
            "BirthDate": "birthDate",
            "Gender": true,
            "ProvinceCode": "provinceCode",
            "DistrictCode": "districtCode",
            "WardCode": "wardCode"
        ]
        
        let completionHandler = {(response: DataResponse<String>) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString(completionHandler: completionHandler)
        
    }
    
    @IBAction func isMale(_ sender: Any) {
        self.maleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        self.femaleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.gender = true
    }
    
    @IBAction func isFemale(_ sender: Any) {
        self.maleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.femaleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        self.gender = false
    }
    
    var gender = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupUI() {
        
        ///Get current User inform
        
        if MyUser.gender {
            
        } else {
            
        }
        
        usernameTextfield.text = MyUser.name
        phoneTextfield.text = MyUser.phone
        sosPhoneTextfield.text = MyUser.phone
        emailTextfield.text = MyUser.email
        
        let date = MyUser.birthday.convertStringToDate(with: "dd-MM-yyyy")
        birthdayTextfield.setDate(date, animated: true)
        
        addressTextfield.text = MyUser.address
    }
    
}




















