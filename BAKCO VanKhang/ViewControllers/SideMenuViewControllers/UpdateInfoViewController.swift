
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
    
    var userId : Int?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var phoneTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var birthdayTextfield: IQDropDownTextField!
    @IBOutlet var addressTextfield: UITextField!
    @IBOutlet var hiTextfield: UITextField!
    @IBOutlet var pesonalIdTextfield: UITextField!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var districtTextField: UITextField!
    @IBOutlet var wardTextField: UITextField!

    
    var selectedPlace = Place()
    var selectedCity: City?
    var selectedDist: District?
    var selectedWard: Ward?
}

extension UpdateInfoViewController {
    
    /// Chọn quận huyện
    @IBAction func chooseDistrict(_ sender: UIButton) {
        if let city = selectedCity {
            let distVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "DistrictsViewController") as! DistrictsViewController
            distVc.selectedCity = city
            distVc.delegate = self
            let nav = BaseNavigationController(rootViewController: distVc)
            present(nav, animated: true)
        } else {
            self.showAlert(title: "Lỗi", mess: "Chưa chọn tỉnh thành", style: .alert)
        }
        
    }
    
    /// Chọn phường xã
    @IBAction func chooseWard(_ sender: UIButton) {
        if let dist = selectedDist {
            let wardVC = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "WardViewController") as! WardViewController
            wardVC.delegate = self
            wardVC.selectedDistrict = dist
            let nav = BaseNavigationController(rootViewController: wardVC)
            present(nav, animated: true)
        } else {
            self.showAlert(title: "Lỗi", mess: "Chưa chọn Quận huyện", style: .alert)
        }
    }
    
    /// Chọn tp
    @IBAction func chooseCity(_ sender: Any) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController") as! CitiesViewController
        cityVc.delegate = self
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
    }
    
    
    /// Cập nhật thông tin bệnh nhân
    @IBAction func confirmUpdate(_ sender: Any) {
        let url = URL(string: API.updateInform)!
        guard let fullName = usernameTextfield.text, let phone = phoneTextfield.text,
            let email = emailTextfield.text, let hiid = hiTextfield.text,
            let address = addressTextfield.text, let bd = birthdayTextfield.date,
            let ward = selectedWard,
            let dist = selectedDist,
            let city = selectedCity
            else { return }

        let parameters: Parameters = [
            "Id": MyUser.id,
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
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response)
            if response.result.isSuccess {
                self.showAlert(title: "Thành công", message: "Cập nhât thông tin người dùng thành công!", style: .alert, hasTwoButton: false, okAction: { (_) in
//                    self.getUserInfo(by: MyUser.id)
                    self.navigationController?.popViewController(animated: true)
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
        guard let userId = self.userId else { return }
        getUserInfo(by: userId)
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
            let hi = hiTextfield.text
        else { return }
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
        title = "Cập nhật thông tin cá nhân"
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

extension UpdateInfoViewController: WardViewControllerDelegate, CitiesViewControllerDelegate, DistrictsViewControllerDelegate {
    func didSelectDistrict(dist: District) {
        self.selectedDist = dist
        districtTextField.text = dist.name
    }
    
    func didSelectedCity(city: City) {
        self.selectedCity = city
        self.cityTextField.text = city.name
    }
    
    func didSelectedWard(ward: Ward) {
        self.selectedWard = ward
        self.wardTextField.text = ward.name
    }
}


















