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
import IQDropDownTextField
import AlamofireSwiftyJSON

var _selectedPlace = String()

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
    @IBOutlet var cityTextfield: UITextField!
    
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
    
    @IBAction func showCityVc(_ sender: UIButton) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController")
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Đăng kí"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityTextfield.text = _selectedPlace
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
        txtBirthday.text = birthdayPicker.date.convertDateToString(with: "yyyy-MM-dd")
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
            let _ = txtConfirmPassword.text, txtConfirmPassword.text == password,
            let city = _selectedCity, let dist = _selectedDistrict, let ward = _selectedWard
        {
            self.signup(fullName: fullName,
                        phone: sosPhoneNum,
                        email: email,
                        birthDate: birthdayPicker.date.convertDateToString(with: "yyyy-MM-dd"),
                        address: address, provinceCode: city.value, districtCode: dist.value, wardCode: ward.value,
                        HealthInsurance: "",
                        username: username,
                        password: password,
                        gender: gender)
        } else {
            showAlert(title: "Lỗi", mess: "Bạn chưa điền đủ thông tin hoặc nhập sai thông tin. Vui lòng kiểm tra lại!", style: .alert)
        }
    }
    
    private func signup(fullName: String, phone: String, email: String, birthDate: String, address: String, provinceCode: String, districtCode: String, wardCode: String,  HealthInsurance: String, username: String, password: String, gender: Bool) {
        
        let parameters: Parameters = [
            "Username": username,
            "Password": password,
            "FullName": fullName,
            "Phone": phone,
            "Email": email,
            "HealthInsurance": HealthInsurance,
            "Address": address,
            "BirthDate": birthDate,
            "Gender": true,
            "ProvinceCode": provinceCode,
            "DistrictCode": districtCode,
            "WardCode": wardCode
            ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string: _RegisterURL)!,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default).responseString { (responseString) in
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            if responseString.result.isSuccess {
                                
                                guard let message = responseString.value else { return }
                                if message == "" {
                                    self.showAlert(title: "Xác nhận", message: "Đăng kí thành công", style: .alert, hasTwoButton: false, okAction: { (okkk) in
                                        self.navigationController?.dismiss(animated: true)
                                    })
                                } else {
                                    self.showAlert(title: "Lỗi", mess: message, style: .alert)
                                }
                            } else {
                                self.showAlert(title: "Lỗi", mess: responseString.error.debugDescription, style: .alert)
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
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
    
}



















