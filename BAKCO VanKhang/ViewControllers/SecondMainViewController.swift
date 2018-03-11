//
//  SignUpViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/13/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


class SecondMainViewController: BaseViewController {
    
    var gender = true
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var okButton: UIButton!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtPhone: UIView!
    @IBOutlet weak var txtEmergencyPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet var birthdayPicker: UIDatePicker!
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBAction func isMale(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        self.femaleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.gender = true
    }
    @IBAction func isFemale(_ sender: UIButton) {
        self.maleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.femaleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        self.gender = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Đăng kí"
        setupUI()
    }
    
    func setupUI() {
        firstView.layer.borderColor = UIColor.specialGreenColor().cgColor
        firstView.layer.borderWidth = 1.0
        firstView.layer.cornerRadius = 10.0
        firstView.clipsToBounds = true
        
        secondView.layer.borderColor = UIColor.specialGreenColor().cgColor
        secondView.layer.borderWidth = 1.0
        secondView.layer.cornerRadius = 10.0
        secondView.clipsToBounds = true
        showCancelButton()
        
        okButton.layer.cornerRadius = 10.0
        okButton.clipsToBounds = true
        
        birthdayPicker.layer.cornerRadius = 10.0
        birthdayPicker.clipsToBounds = true
        
        self.maleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.femaleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)

    }
    
    @IBAction func dateChanged(_ sender: Any) {
        txtBirthday.text = convertDate(date: birthdayPicker.date, with: "dd-MM-yyyy")
    }
    
    @IBAction func actOk(_ sender: Any) {
        registerUser()
    }
    
    func registerUser() {
        /// Validate textField
        if let fullName = txtFullName.text, txtFullName.text != "",
            let sosPhoneNum = txtEmergencyPhone.text, txtEmergencyPhone.text != "",
            let email = txtEmail.text, txtEmail.text != "",
            let _ = txtBirthday.text, txtBirthday.text != "",
            let address = txtAddress.text, txtAddress.text != "",
            let username = txtUserName.text,txtUserName.text != "",
            let password = txtPassword.text,txtPassword.text != "",
            let _ = txtConfirmPassword.text, txtConfirmPassword.text == password
        {
            self.signup(fullName: fullName, phone: sosPhoneNum, email: email, birthDate: convertDate(date: birthdayPicker.date, with: "yyyy-MM-dd"), address: address, HealthInsurance: "", username: username, password: password, gender: gender)
        } else {
            showAlert(title: "Lỗi", mess: "Bạn phải điền đầy đủ thông tin", style: .alert)
        }
    }
    
    func signup(fullName: String, phone: String, email: String, birthDate: String, address: String, HealthInsurance: String, username: String, password: String, gender: Bool) {
        let parameters: Parameters = [  "Username": username,
                                        "Password": password,
                                        "FullName": fullName,
                                        "Phone": phone,
                                        "Email": email,
                                        "HealthInsurance": HealthInsurance,
                                        "Address": "244/70 Lê Văn Khương",
                                        "BirthDate": birthDate,
                                        "Gender": gender,
                                        "ProvinceCode": "TP.HCM",
                                        "DistrictCode": "12",
                                        "WardCode": "Thới An"]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string: _RegisterURL)!,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if response.result.isSuccess {
                                self.showAlert(title: "Thành công!", mess: "Bạn đã đăng kí thành công!", style: .alert)
                                self.navigationController?.dismiss(animated: true)
                            } else {
                                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
                            }
        }
    }

    
    func getUserInfo(userId: Int) {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(URL(string: "http://api.vkhs.vn/api/BkCustomer/GetById/\(userId)")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value?.dictionaryValue as Any)
            
            if let data = response.value?.dictionaryObject {
                DispatchQueue.main.async {
                    let user = User(data: data)
                    User.setCurrent(user) /// Set value for User Default.
                    User.setUserForPaintent(user)
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
}









