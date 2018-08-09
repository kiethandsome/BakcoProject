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
    
    var city: City?
    var dist: District?
    var ward: Ward?
    var place: Place?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var phoneTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var birthdayTextfield: IQDropDownTextField!
    @IBOutlet var addressTextfield: UITextField!
    @IBOutlet var placesTextfield: UITextField!
    @IBOutlet var hiTextfield: UITextField!
    @IBOutlet var pesonalIdTextfield: UITextField!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var confirmButton: UIButton!
    
    
    @IBAction func choosePlaces(_ sender: Any) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController")
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
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
        self.femaleButton.setImage(UIImage(named: "no-image"), for: .normal)
    }
    
    @IBAction func isFemale(_ sender: Any) {
        isFemale()
    }
    
    func isFemale() {
        self.maleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.femaleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
    }
}

// Mark: Functions
extension PatientInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserInfo(by: userId)
        setupTextfield(tf: usernameTextfield, phoneTextfield, emailTextfield, addressTextfield, hiTextfield)
        setupDoneButton()
        
        if self.userId != MyUser.id {
            self.usernameTextfield.isUserInteractionEnabled = false
            self.phoneTextfield.isUserInteractionEnabled = false
            self.addressTextfield.isUserInteractionEnabled = false
            self.birthdayTextfield.isUserInteractionEnabled = false
            self.emailTextfield.isUserInteractionEnabled = false
            self.placesTextfield.isUserInteractionEnabled = false
            self.hiTextfield.isUserInteractionEnabled = false
            self.maleButton.isUserInteractionEnabled = false
            self.femaleButton.isUserInteractionEnabled = false
            self.pesonalIdTextfield.isUserInteractionEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        placesTextfield.text = ""
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
    
    fileprivate func setupTextfield(tf: UITextField...) {
        for tf1 in tf {
            tf1.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        }
    }
    
    @objc func textDidChange(textField: UITextField) {
        guard let fullname = usernameTextfield.text,
            let phone = phoneTextfield.text,
            let address = addressTextfield.text,
            let email = emailTextfield.text,
            let hi = hiTextfield.text else { return }
        if fullname == selectedpatient?.fullName,
            phone == selectedpatient?.phone,
            address == selectedpatient?.address,
            email == selectedpatient?.email,
            hi == selectedpatient?.healthInsurance {
            disableButton(button: confirmButton)
        } else {
            enableButton(button: confirmButton)
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
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(URL(string: API.getUserById + "/\(userId)")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value?.dictionaryValue as Any)
            if let data = response.value?.dictionaryObject {
                if let message = data["Message"] as? String {
                    self.showAlert(title: "Lỗi", mess: message, style: .alert)
                } else {
                    let user = User(data: data)
                    self.selectedpatient = user
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
        setupPicker(picker: birthdayTextfield, user: user)
    }
    
    fileprivate func updateCurrentUserInfo() {
        let url = URL(string: API.updateInform)!
        guard let fullName = usernameTextfield.text, let phone = phoneTextfield.text,
            let email = emailTextfield.text, let hiid = hiTextfield.text,
            let address = addressTextfield.text, let bd = birthdayTextfield.date,
            let city = city,
            let dist = dist,
            let ward = ward
            else { return }
        let parameters: Parameters = [
            "Id": self.userId,
            "FullName": fullName,
            "Username": "",
            "Password": "",
            "Phone": phone,
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
        guard let city = city,
            let dist = dist,
            let ward = ward
            else { return }
        let user = User(id: self.userId,
                        name: usernameTextfield.text!,
                        phone: phoneTextfield.text!,
                        hiid: hiTextfield.text!,
                        email: emailTextfield.text!,
                        address: addressTextfield.text!,
                        birthdate: birthdayTextfield.date!,
                        gender: maleButton.isSelected ? true : false,
                        districtCode: Int(dist.value)!,
                        wardCode: Int(ward.value)!,
                        provinceCode: Int(city.value)!)
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

















