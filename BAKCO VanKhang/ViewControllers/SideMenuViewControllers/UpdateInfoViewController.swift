
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

class UpdateInfoViewController: BaseViewController, IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    
    var updatedPaintent: User?
    
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
}

extension UpdateInfoViewController {
    
    @IBAction func choosePlaces(_ sender: Any) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController")
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
    }
    
    @IBAction func confirmUpdate(_ sender: Any) {   //Update User Information
        let url = URL(string: API.updateInform)!
        guard let fullName = usernameTextfield.text, let phone = phoneTextfield.text,
            let email = emailTextfield.text, let hiid = hiTextfield.text,
            let address = addressTextfield.text, let bd = birthdayTextfield.date
            else { return }
        let province = SelectedPlace.city.value
        let district = SelectedPlace.district.value
        let ward = SelectedPlace.ward.value

        let parameters: Parameters = [
            "Id": MyUser.id,
            "Username": "tuan",
            "Password": "",
            "FullName": fullName,
            "Phone": phone,
            "Email": email,
            "HealthInsurance": hiid,
            "Address": address,
            "BirthDate": bd.convertDateToString(with: "yyyy-MM-dd"),
            "Gender": maleButton.isSelected,
            "ProvinceCode": province,
            "DistrictCode": district,
            "WardCode": ward ]
        let completionHandler = { (response: DataResponse<String>) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response)
            if response.result.isSuccess {
                self.showAlert(title: "Thành công", message: "Cập nhât thông tin người dùng thành công!", style: .alert, hasTwoButton: false, okAction: { (_) in
//                    self.getUserInfo(by: MyUser.id)
                    SelectedPlace.release()
                })
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString(completionHandler: completionHandler)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextfield(tf: usernameTextfield, phoneTextfield, emailTextfield, addressTextfield, hiTextfield)
        getUserInfo(by: MyUser.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.placesTextfield.text = SelectedPlace.stringValue
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
        if fullname == MyUser.name,
            phone == MyUser.phone,
            address == MyUser.address,
            email == MyUser.email,
            hi == MyUser.insuranceId {
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
        title = "Thông tin cá nhân"
        showBackButton()
        disableButton(button: confirmButton)
        contentView.layer.borderColor = UIColor.specialGreenColor().cgColor
//        guard let currentUser = MyUser.current else {return}
//        setupAllTextField(user: currentUser)
    }
    
    fileprivate func setupPicker(picker: IQDropDownTextField, user: User) {
        let date = user.birthDate.convertStringToDate(with: "yyyy-MM-dd")
        picker.delegate = self
        picker.dataSource = self
        picker.dropDownMode = .datePicker
        picker.showDismissToolbar = true
        picker.isOptionalDropDown = false
        picker.setDate(date, animated: true)
    }
    
    fileprivate func getUserInfo(by userId: Int) {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(URL(string: API.getUserId + "/\(userId)")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value?.dictionaryValue as Any)
            if let data = response.value?.dictionaryObject {
                if let message = data["Message"] as? String {
                    self.showAlert(title: "Lỗi", mess: message, style: .alert)
                } else {
                    let user = User(data: data)
                    User.setCurrent(user) // Set value for User Default.
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
}



















