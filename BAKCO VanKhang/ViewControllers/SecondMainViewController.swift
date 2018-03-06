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


class SecondMainViewController: BaseViewController {
    
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
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBAction func isMale(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        self.femaleButton.setImage(UIImage(named: "no-image"), for: .normal)
    }
    @IBAction func isFemale(_ sender: UIButton) {
        self.maleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.femaleButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Đăng kí"
        setupUI()
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
        txtBirthday.text = convertDate(date: birthdayPicker.date, with: "dd-MM-yyyy")
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
            let _ = txtConfirmPassword.text, txtConfirmPassword.text == password
        {
            register(fullName: fullName,
                     phone: sosPhoneNum,
                     email: email,
                     birthDate: convertDate(date: self.birthdayPicker.date, with: "yyyy-MM-dd"),
                     address: address,
                     HealthInsurance: "",
                     username: username,
                     password: password,
                     completion: { (response) in
                let userID = response["CustomerId"] as! Int
                print(userID)
                self.getUserInfo(userId: userID)
                
                
                let mainTab = self.storyboard?.instantiateViewController(withIdentifier: "tab")
                guard let window = UIApplication.shared.keyWindow else { return }
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = mainTab
                    window.makeKeyAndVisible()
                }, completion: nil)
            })
        } else {
            showAlert(title: "Lỗi", mess: "Bạn phải điền đầy đủ thông tin", style: .alert)
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
                    User.setUserForPaintent(user)
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
}









