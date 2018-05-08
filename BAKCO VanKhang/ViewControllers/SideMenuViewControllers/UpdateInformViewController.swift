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

struct SelectedPlace {
    static var city = City()
    static var district = District()
    static var ward = Ward()
    static var stringValue = String()
    
    static func release() {
        self.city = City()
        self.district = District()
        self.ward = Ward()
        self.stringValue = ""
    }
}

class UpdateInformViewController: UIViewController, IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    
    var editedUser: User?
    var gender = Bool()
    
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
    
    @IBAction func confirmUpdate(_ sender: Any) {   ///Update User Information
        
        SelectedPlace.release()
        
        let url = URL(string: API.updateInform)!
        
        guard let fullName = usernameTextfield.text, let phone = phoneTextfield.text,
            let email = emailTextfield.text, let hiid = hiTextfield.text,
            let address = addressTextfield.text, let bd = birthdayTextfield.date
            else { return }
        let province = SelectedPlace.city.value
        let district = SelectedPlace.district.value
        let ward = SelectedPlace.ward.value
        
        let parameters: Parameters = [
            "FullName": fullName,
            "Phone": phone,
            "Email": email,
            "HealthInsurance": hiid,
            "Address": address,
            "BirthDate": bd.convertDateToString(with: "yyyy-MM-dd"),
            "Gender": gender,
            "ProvinceCode": province,
            "DistrictCode": district,
            "WardCode": ward
        ]
        
        let completionHandler = { (response: DataResponse<String>) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            print(response)
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
        self.gender = true
    }
    
    @IBAction func isFemale(_ sender: Any) {
        isFemale()
    }
    
    func isFemale() {
        self.maleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.femaleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        self.gender = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButton(button: confirmButton)
        contentView.layer.borderColor = UIColor.specialGreenColor().cgColor
        setupUI()
        setupTextfield(tf: usernameTextfield, phoneTextfield, emailTextfield, addressTextfield, hiTextfield)
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
    
    func setupUI() {
        ///Get current User inform
        if MyUser.gender { isMale() }
        else { isFemale() }
        usernameTextfield.text = MyUser.name
        phoneTextfield.text = MyUser.phone
        emailTextfield.text = MyUser.email
        addressTextfield.text = MyUser.address
        hiTextfield.text = MyUser.insuranceId
        /// Setup DropDown
        let date = MyUser.birthday.convertStringToDate(with: "yyyy-MM-dd")
        self.birthdayTextfield.delegate = self
        self.birthdayTextfield.dataSource = self
        self.birthdayTextfield.dropDownMode = .datePicker
        self.birthdayTextfield.showDismissToolbar = true
        self.birthdayTextfield.isOptionalDropDown = false
        self.birthdayTextfield.setDate(date, animated: true)
    }
}



















