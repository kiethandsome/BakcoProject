//
//  AddPatientViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/17/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import AlamofireSwiftyJSON
import Alamofire
import MBProgressHUD
import UIKit
import SwiftyJSON
import IQDropDownTextField

class AddPatientViewController: BaseViewController {
    
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
    @IBOutlet var confirmAddingButton: UIButton!
    
    var city : City?
    var dist: District?
    var ward: Ward?

    @IBAction func choosePlaces(_ sender: Any) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController")
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
    }
    
    @IBAction func chooseDistrict(_ sender: Any) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController")
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
    }
    
    @IBAction func chooseWard(_ sender: Any) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController")
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
    }
    
    @IBAction func add(_ sender: Any) {
        if validate() {
            guard let username = usernameTextfield.text,
                let phone = phoneTextfield.text,
                let email = emailTextfield.text,
                let hiid = hiTextfield.text,
                let address = addressTextfield.text,
                let birthdate = birthdayTextfield.date?.convertDateToString(with: "yyyy-MM-dd"),
                let city = city,
                let dist = dist,
                let ward = ward else { return }
            createPaintent(username: username,
                        phone: phone,
                        email: email,
                        hiId: hiid,
                        address: address,
                        birthdate: birthdate,
                        gender: maleButton.isSelected ? true : false,
                        provinceCode: city.value,
                        districtCode: dist.value,
                        wardCode: ward.value)
        } else {
            showAlert(title: "Lỗi", mess: "Bạn chưa điền đủ thông tin", style: .alert)
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

extension AddPatientViewController: IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Thêm bệnh nhân"
        showCancelButton()
        setupPicker(picker: self.birthdayTextfield)
    }
    
    func validate() -> Bool {
        if let userName = usernameTextfield.text, userName != "" {
            return true
        } else {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập tên bệnh nhân", style: .alert)
        }
        if let phone = phoneTextfield.text, phone != "" {
            return true
        } else {
            showAlert(title: "Lỗi", mess: "Bạn chưa nhập số điện thoại bệnh nhân", style: .alert)
        }
        return false
        
    }
    
    func setupPicker(picker: IQDropDownTextField) {
        picker.delegate = self
        picker.dataSource = self
        picker.dropDownMode = .datePicker
        picker.showDismissToolbar = true
        picker.isOptionalDropDown = false
    }
    
    /// Tạo bệnh nhân
    func createPaintent(username: String, phone: String, email: String, hiId: String, address: String, birthdate: String, gender: Bool, provinceCode: String, districtCode: String, wardCode: String) {
        let param: Parameters = [
            "FullName": username,
            "Phone": phone,
            "Email": email,
            "HealthInsurance": hiId,
            "Address": address,
            "BirthDate": birthdate,
            "Gender": gender,
            "ProvinceCode": provinceCode,
            "DistrictCode": districtCode,
            "WardCode": wardCode
        ]
        let url = URL(string: API.createCustomer)!
        
        let completionHandler = { (response: DataResponse<JSON>) -> Void in
            self.hideHUD()
            print(response)
            if response.result.isSuccess {
                if let data = response.value, let dict = data.dictionaryObject {
                    let customerId = dict["CustomerId"] as! Int
                    self.showAlert(title: "Thành công!", message: "Tạo thành công bệnh nhân", style: .alert, hasTwoButton: false, okAction: { (_) in
                        self.addPatient(profileId: customerId)
                    })
                } else {
                }
            } else {
                
            }
        }
        
        self.showHUD()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseSwiftyJSON(completionHandler: completionHandler)
    }
    
    /// Thêm bệnh nhân vào danh sách
    fileprivate func addPatient(profileId: Int) {
        let url = URL(string: API.addProfiles + "?CustomerId=" + "\(MyUser.id)" + "&ProfileId=" + "\(profileId)")!
        let completionHandler = { (response: DataResponse<JSON>) -> Void in
            self.hideHUD()
            print(response)
            if response.result.isSuccess {
                if let value = response.value , let data = value.dictionaryObject {
                    print(data["Id"] ?? "")
                    self.showAlert(title: "Thành công", message: "Đã thêm bệnh nhân mới vào danh sách", style: .alert, hasTwoButton: true, okAction: { (_) in
                        self.dismiss(animated: true)
                    })
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
        self.showHUD()
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseSwiftyJSON(completionHandler: completionHandler)
    }
}











