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

class SignUpViewController: BaseViewController {
    
    var gender = true
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var okButton: UIButton!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
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
        cityTextfield.text = Place.stringValue
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
        let isValid = validateInputContent()
        if isValid == true {
            self.registerUser()
        } else {
            
        }
    }
    
    func registerUser() {
        let birthDate: String = birthdayPicker.date.convertDateToString(with: "yyyy-MM-dd")
        self.signup(fullName: txtFullName.text!,
                    phone: txtPhone.text!,
                    email: txtEmail.text!,
                    birthDate: birthDate,
                    address: txtAddress.text!,
                    provinceCode: Place.city.value, districtCode: Place.district.value, wardCode: Place.ward.value,
                    HealthInsurance: "",
                    username: txtUserName.text!,
                    password: txtPassword.text!,
                    gender: gender)
    }
    
    func validateInputContent() -> Bool {
        guard let fullName = txtFullName.text,
            let phone = txtPhone.text,
            let email = txtEmail.text,
            let birthday = txtBirthday.text,
            let address = txtAddress.text,
            let username = txtUserName.text,
            let password = txtPassword.text,
            let confirmPassword = txtConfirmPassword.text
            else { return false }
        if fullName == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập họ tên", style: .alert)
            return false
        } else if phone == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập số điện thoại", style: .alert)
            return false
        } else if email == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập email", style: .alert)
            return false
        } else if birthday == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập ngày sinh", style: .alert)
            return false
        } else if address == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập địa chỉ", style: .alert)
            return false
        } else if username == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập tên đăng nhập", style: .alert)
            return false
        } else if username.count < 6 {
            showAlert(title: "Lỗi", mess: "Tên người dùng phải trên 6 kí tự, không bao gồm các kí tự đặt biệt và phải viết thường", style: .alert)
            return false
        } else if password == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập mật khẩu", style: .alert)
            return false
        } else if password.count < 6 {
            showAlert(title: "Lỗi", mess: "Mật khẩu phải trên 6 kí tự, không bao gồm các kí tự đặt biệt và phải viết thường", style: .alert)
            return false
        } else if confirmPassword == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập xác nhận mật khẩu", style: .alert)
            return false
        } else if confirmPassword != password {
            showAlert(title: "Lỗi", mess: "Xác nhận mật khẩu không khớp với mật khẩu bạn đã nhập", style: .alert)
            return false
        } else {
            return true
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
        Alamofire.request(URL(string: API.register)!,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default).responseString { (responseString) in
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            if responseString.result.isSuccess {
                                
                                guard let message = responseString.value else { return }
                                if message == "" {
                                    self.showAlert(title: "Xác nhận", message: "Đăng kí thành công", style: .alert, hasTwoButton: false, okAction: { (_) in
                                        self.navigationController?.dismiss(animated: true)
                                        Place.release()
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
        Alamofire.request(URL(string: API.getUserId + "/\(userId)")!, method: .get).responseSwiftyJSON { (response) in
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



















