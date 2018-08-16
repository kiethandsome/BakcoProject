
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
    var currentUser: User?
    var editingUser: User?
    
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
    var currentCity = City()
    var currentDist = District()
    var currentWard = Ward()

    /// Chọn quận huyện
    @IBAction func chooseDistrict(_ sender: UIButton) {
        if cityTextField.text != "" {
            let distVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "DistrictsViewController") as! DistrictsViewController
            distVc.selectedCity = currentCity
            distVc.delegate = self
            let nav = BaseNavigationController(rootViewController: distVc)
            present(nav, animated: true)
        } else {
            self.showAlert(title: "Lỗi", mess: "Chưa chọn tỉnh thành", style: .alert)
        }
        
    }
    
    /// Chọn phường xã
    @IBAction func chooseWard(_ sender: UIButton) {
        if districtTextField.text != "" {
            let wardVC = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "WardViewController") as! WardViewController
            wardVC.delegate = self
            wardVC.selectedDistrict = self.currentDist
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
            let address = addressTextfield.text, let bd = birthdayTextfield.date
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
            "ProvinceCode": currentCity.value,
            "DistrictCode": currentDist.value,
            "WardCode": currentWard.value ]
        let completionHandler = { (response: DataResponse<String>) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response)
            if response.result.isSuccess {
                self.showAlert(title: "Thành công", message: "Cập nhât thông tin người dùng thành công!", style: .alert, hasTwoButton: false, okAction: { (_) in
                    /// Sau khi cập nhật thông tin thành công thì gán giá trị mới cho MyUser.
                    self.parseToCurrentUser()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        guard let userId = self.userId else { return }
        getUserInfo(by: userId)
    }
    
    
    fileprivate func setupUI() {
        title = "Cập nhật thông tin cá nhân"
        showBackButton()
//        disableButton(button: confirmButton)
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
        Alamofire.request(URL(string: API.getUserInfo)!,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization" : "Bearer \(MyUser.token)"]).responseSwiftyJSON { (response) in
            self.hideHUD()
            print(response)
            if response.result.isSuccess {
                if let data = response.value?.dictionaryObject {
                    self.currentUser = User(data: data)
                    guard let user = self.currentUser else { return }
                    self.setupAllTextField(user: user)
//                    self.disableButton(button: self.confirmButton)
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
    func parseToCurrentUser() {
        let user = User(id: MyUser.id,
                        name: usernameTextfield.text!,
                        phone: phoneTextfield.text!,
                        hiid: hiTextfield.text!,
                        email: emailTextfield.text!,
                        address: addressTextfield.text!,
                        birthdate: birthdayTextfield.date!,
                        gender: maleButton.isSelected,
                        districtCode: currentDist.value,
                        wardCode: currentWard.value,
                        provinceCode: currentCity.value)
        User.setCurrent(user)

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
        currentCity = City(name: user.cityName, value: "\(user.provinceCode)")
        /// Set dist
        districtTextField.text = user.distName
        currentDist = District(name: user.distName, value: "\(user.districtCode)")
        /// Set ward
        wardTextField.text = user.wardName
        currentWard = Ward(name: user.wardName, value: "\(user.wardCode)")

        setupPicker(picker: birthdayTextfield, user: user)
    }
}

extension UpdateInfoViewController: WardViewControllerDelegate, CitiesViewControllerDelegate, DistrictsViewControllerDelegate {
    func didSelectedCity(city: City) {
        self.currentCity = city
        self.cityTextField.text = city.name
        
        /// Xóa quận đã chọn
        self.districtTextField.text = String()
        self.currentDist = District()
        
        /// Xóa phường đã chọn
        self.wardTextField.text = String()
        self.currentWard = Ward()
    }
    
    func didSelectDistrict(dist: District) {
        self.currentDist = dist
        districtTextField.text = dist.name
        
        /// Xóa phường xã đã chọn
        self.wardTextField.text = String()
        self.currentWard = Ward()
    }
    
    func didSelectedWard(ward: Ward) {
        self.currentWard = ward
        self.wardTextField.text = ward.name
    }
}


















