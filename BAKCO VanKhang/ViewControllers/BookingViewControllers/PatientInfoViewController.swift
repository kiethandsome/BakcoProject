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



// Mark: Properties
class PatientInfoViewController: BaseViewController, IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    
    var selectedpatient: User?
    var userId = Int()
    var direct: DirectViewController!
    
    var city = City()
    var dist = District()
    var ward = Ward()
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var phoneTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var birthdayTextfield: IQDropDownTextField!
    @IBOutlet var addressTextfield: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var hiTextfield: UITextField!
    @IBOutlet var personalIdTextfield: UITextField!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var districtTextField: UITextField!
    @IBOutlet var wardTextField: UITextField!
    
    
    @IBAction func choosePlaces(_ sender: Any) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController") as! CitiesViewController
        cityVc.delegate = self
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
    }
    
    @IBAction func chooseDistrict(_ sender: Any) {
        if cityTextField.text != "" {
            let distVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "DistrictsViewController") as! DistrictsViewController
            distVc.selectedCity = city
            distVc.delegate = self
            let nav = BaseNavigationController(rootViewController: distVc)
            present(nav, animated: true)
        } else {
            self.showAlert(title: "Lỗi", mess: "Chưa chọn tỉnh thành", style: .alert)
        }
    }
    
    @IBAction func chooseWard(_ sender: Any) {
        if districtTextField.text != "" {
            let wardVC = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "WardViewController") as! WardViewController
            wardVC.delegate = self
            wardVC.selectedDistrict = dist
            let nav = BaseNavigationController(rootViewController: wardVC)
            present(nav, animated: true)
        } else {
            self.showAlert(title: "Lỗi", mess: "Chưa chọn Quận huyện", style: .alert)
        }
    }
    
    @IBAction func confirmUpdate(_ sender: Any) {
        if self.userId == MyUser.id {
            updateCurrentUserInfo()
        } else {
            updateProfilepatient(by: self.userId)
        }
    }
    
    @IBAction func isMale(_ sender: Any) {
        isMale()
    }
    
    func isMale() {
        self.maleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        self.maleButton.isSelected = true
        self.femaleButton.isSelected = false
        self.femaleButton.setImage(UIImage(named: "no-image"), for: .normal)
    }
    
    @IBAction func isFemale(_ sender: Any) {
        isFemale()
    }
    
    func isFemale() {
        self.maleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.maleButton.isSelected = false
        self.femaleButton.isSelected = true
        self.femaleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
    }
}

// Mark: Functions
extension PatientInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if userId == MyUser.id {
            getUserInfo(by: userId)
        } else {
            getPatientInfo(id: userId)
        }

        setupDoneButton()
        disableButton(button: confirmButton)
        ///
        self.usernameTextfield.isUserInteractionEnabled = false
        self.phoneTextfield.isUserInteractionEnabled = false
        self.addressTextfield.isUserInteractionEnabled = false
        self.birthdayTextfield.isUserInteractionEnabled = false
        self.emailTextfield.isUserInteractionEnabled = false
        self.cityTextField.isUserInteractionEnabled = false
        self.hiTextfield.isUserInteractionEnabled = false
        self.maleButton.isUserInteractionEnabled = false
        self.femaleButton.isUserInteractionEnabled = false
        self.personalIdTextfield.isUserInteractionEnabled = false
    }
    
    fileprivate func setupDoneButton() {
        let button = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func done() {
        if let patient: User = self.selectedpatient {
            self.navigationController?.dismiss(animated: true)
            BookingInfo.patient = patient /// Gán
        } else {
            self.showAlert(title: "Lỗi", mess: "Không có bệnh nhân nào được chọn", style: .alert)
        }
    }
    
    fileprivate func disableButton(button: UIButton) {
        button.backgroundColor = .lightGray
        button.isEnabled = false
    }
    
    fileprivate func enableButton(button: UIButton) {
        button.backgroundColor = UIColor.specialGreenColor()
        button.isEnabled = true
    }
    
    fileprivate func setupUI() {
        title = "Thông tin bệnh nhân"
        showBackButton()
        disableButton(button: confirmButton)
        contentView.layer.borderColor = UIColor.specialGreenColor().cgColor
    }
    
    fileprivate func setupPicker(picker: IQDropDownTextField, user: User) {
        let date = user.birthDate
        picker.delegate = self
        picker.dataSource = self
        picker.dropDownMode = .datePicker
        picker.showDismissToolbar = true
        picker.isOptionalDropDown = false
        picker.setDate(date, animated: true)
    }
    
    fileprivate func getUserInfo(by userId: Int) {
        self.showHUD()
        Alamofire.request(URL(string: API.getUserInfo)!, method: .get, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(MyUser.token)"]).responseSwiftyJSON { (response) in
            self.hideHUD()
            print(response)
            if response.result.isSuccess {
                if let data = response.value?.dictionaryObject {
                    self.selectedpatient = User(data: data)
                    guard let user = self.selectedpatient else {return }
                    self.setupAllTextField(user: user)
                    self.disableButton(button: self.confirmButton)
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
    fileprivate func getPatientInfo(id: Int) {
        self.showHUD()
        Alamofire.request(URL(string: API.getUserById + "\(id)")! , method: .get, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            self.hideHUD()
            if response.result.isSuccess {
                if let data = response.value?.dictionaryObject {
                    self.selectedpatient = User(data: data)
                    guard let user = self.selectedpatient else {return }
                    self.setupAllTextField(user: user)
                    self.disableButton(button: self.confirmButton)
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
    fileprivate func setupAllTextField(user: User) {
        if (user.gender) { isMale() }
        else { isFemale() }
        usernameTextfield.text = user.fullName
        phoneTextfield.text = user.phone
        emailTextfield.text = user.email
        addressTextfield.text = user.address
        hiTextfield.text = user.healthInsurance
        /// Set City
        cityTextField.text = user.cityName
        city = City(name: user.cityName, value: "\(user.provinceCode)")
        /// Set dist
        districtTextField.text = user.distName
        dist = District(name: user.distName, value: "\(user.districtCode)")
        /// Set ward
        wardTextField.text = user.wardName
        ward = Ward(name: user.wardName, value: "\(user.wardCode)")
        
        setupPicker(picker: birthdayTextfield, user: user)
    }
    
    fileprivate func updateCurrentUserInfo() {
        let url = URL(string: API.updateInform)!
        guard let fullName = usernameTextfield.text, let phone = phoneTextfield.text,
            let email = emailTextfield.text, let hiid = hiTextfield.text,
            let address = addressTextfield.text, let bd = birthdayTextfield.date
            else { return }
        let parameters: Parameters = [
            "Id": self.userId,
            "FullName": fullName,
            "Phone": phone,
            "Phone1": phone,
            "Email": email,
            "HealthInsurance": hiid,
            "Address": address,
            "BirthDate": bd.convertDateToString(with: "yyyy-MM-dd"),
            "Gender": maleButton.isSelected,
            "ProvinceCode": city.value,
            "DistrictCode": dist.value,
            "WardCode": ward.value ]
        let completionHandler = { (response: DataResponse<String>) -> Void in
            self.hideHUD()
            print(response)
            
            if response.result.isSuccess {
                let alertTitle = "Xác nhận"
                let alertMess = "Cập nhật thông tin bệnh nhân thành công!"
                self.showAlert(title: alertTitle, message: alertMess, style: .alert, hasTwoButton: false, okAction: { (_) in
                    
                    if self.userId == MyUser.id { /// Nếu là tài khoản cá nhân thì gán vào userDefault
                        self.parseToCurrentUser()
                    }
                    self.navigationController?.dismiss(animated: true)
                })
            } else {
                self.showAlert(title: "Lỗi", mess: response.debugDescription, style: .alert)
            }
        }
        self.showHUD()
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString(completionHandler: completionHandler)
    }
    
    func parseToCurrentUser() {
        let user = User(id: self.userId,
                        name: usernameTextfield.text!,
                        phone: phoneTextfield.text!,
                        hiid: hiTextfield.text!,
                        email: emailTextfield.text!,
                        address: addressTextfield.text!,
                        birthdate: birthdayTextfield.date!,
                        gender: maleButton.isSelected ? true : false,
                        districtCode: dist.value,
                        wardCode: ward.value,
                        provinceCode: city.value)
        User.setCurrent(user)
        BookingInfo.patient = user
    }
    
    func updateProfilepatient(by id: Int) {
        /// Chưa có api update profile
        showAlert(title: "Thông báo", message: "Chưa có api cập nhât thông tin cho bệnh nhân", style: .alert, hasTwoButton: false) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension PatientInfoViewController: DistrictsViewControllerDelegate, WardViewControllerDelegate, CitiesViewControllerDelegate {
    func didSelectDistrict(dist: District) {
        self.dist = dist
        districtTextField.text = dist.name
        
        /// Xóa phường xã đã chọn
        self.wardTextField.text = String()
        self.ward = Ward()
    }
    
    func didSelectedCity(city: City) {
        self.city = city
        self.cityTextField.text = city.name
        
        /// Xóa quận đã chọn
        self.districtTextField.text = String()
        self.dist = District()
        
        /// Xóa phường đã chọn
        self.wardTextField.text = String()
        self.ward = Ward()
    }
    
    func didSelectedWard(ward: Ward) {
        self.ward = ward
        self.wardTextField.text = ward.name
    }
}















