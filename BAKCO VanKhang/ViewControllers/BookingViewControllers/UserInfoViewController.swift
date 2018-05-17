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

enum TransitionType {
    case present
    case push
}

protocol UserInfoViewControllerDelegate: class {
    func didSelectUser(user: User)
}

class UserInfoViewController: BaseViewController, IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    
    var selectedPaintent: User?
    weak var delegate: UserInfoViewControllerDelegate?
    
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

extension UserInfoViewController {
    
    @IBAction func choosePlaces(_ sender: Any) {
        let cityVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "CitiesViewController")
        let nav = BaseNavigationController(rootViewController: cityVc)
        present(nav, animated: true)
    }
    
    @IBAction func confirmUpdate(_ sender: Any) {   //Update User Information
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
            "Gender": maleButton.isSelected,
            "ProvinceCode": province,
            "DistrictCode": district,
            "WardCode": ward ]
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
        setupPicker(picker: birthdayTextfield)
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
        if fullname == selectedPaintent?.fullName,
            phone == selectedPaintent?.phone,
            address == selectedPaintent?.address,
            email == selectedPaintent?.email,
            hi == selectedPaintent?.healthInsurance {
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
        showCancelButton()
        disableButton(button: confirmButton)
        contentView.layer.borderColor = UIColor.specialGreenColor().cgColor
        guard let paintent = self.selectedPaintent else {return}
        if (paintent.gender) { isMale() }
        else { isFemale() }
        usernameTextfield.text = paintent.fullName
        phoneTextfield.text = paintent.phone
        emailTextfield.text = paintent.email
        addressTextfield.text = paintent.address
        hiTextfield.text = paintent.healthInsurance
    }
    
    fileprivate func setupPicker(picker: IQDropDownTextField) {
        let date = selectedPaintent?.birthDate.convertStringToDate(with: "yyyy-MM-dd")
        picker.delegate = self
        picker.dataSource = self
        picker.dropDownMode = .datePicker
        picker.showDismissToolbar = true
        picker.isOptionalDropDown = false
        picker.setDate(date, animated: true)
    }
}



















