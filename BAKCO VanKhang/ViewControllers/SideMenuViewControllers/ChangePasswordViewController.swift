//
//  ChangePasswordViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 7/12/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import MBProgressHUD

class ChangePasswordViewController: BaseViewController {
    
    @IBOutlet weak var oldPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var confirmNewPasswordTextfield: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction private func confirmUpdate() {
        guard let old = oldPasswordTextfield.text ,
            let new = newPasswordTextfield.text,
            let confirm = confirmNewPasswordTextfield.text
            else { return }
        if new != confirm {
            self.showAlert(title: "Lỗi", mess: "Mật khẩu mới và mật khẩu xác nhận không giống nhau. \nVui lòng nhập lại!", style: .alert)
        } else if new.count < 6 || confirm.count < 6 {
            self.showAlert(title: "Lỗi", mess: "Mật khẩu phải trên 6 kí tự. \nVui lòng nhập lại!", style: .alert)
        } else {
            updatePass(old: old, new: new, confirm: confirm)
        }
    }
}

extension ChangePasswordViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.title = "Đổi mật khẩu"
        self.showBackButton()
        self.setupTextField(tf: newPasswordTextfield, oldPasswordTextfield, confirmNewPasswordTextfield)
        self.enableConfirmButton(value: false)
    }
    
    private func setupTextField(tf: UITextField...) {
        for tf1 in tf {
            tf1.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        }
    }
    
    @objc func textDidChange(textField: UITextField) {
        guard let old = oldPasswordTextfield.text ,
            let new = newPasswordTextfield.text,
            let confirm = confirmNewPasswordTextfield.text
            else { return }
        if old != "", new != "", confirm != "" {
            self.enableConfirmButton(value: true)
        } else {
            self.enableConfirmButton(value: false)
        }
    }
    
    func enableConfirmButton(value: Bool) {
        if value {
            self.confirmButton.backgroundColor = UIColor.specialGreenColor()
            self.confirmButton.isEnabled = true
        } else {
            self.confirmButton.backgroundColor = UIColor.lightGray
            self.confirmButton.isEnabled = false
        }
    }
    
    private func updatePass(old: String, new: String, confirm: String) {
        
        print(MyUser.token)
        
        self.showHUD()
        let param: Parameters = [
            "OldPassword": old,
            "NewPassword": new,
            "ConfirmPassword": confirm
        ]
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(MyUser.token)",
            "Content-Type": "application/json"
        ]
        
        let url = URL(string: API.changePass)!
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseSwiftyJSON { (response) in
            self.hideHUD()
            print(response)
            print(response.response?.statusCode ?? 0)
            
            if response.response?.statusCode == 200 {
                self.showAlert(title: "Thành công", message: "Đổi mật khẩu thành công!", style: .alert, hasTwoButton: false, okAction: { (ok) in
                    self.navigationController?.popViewController(animated: true)
                })
            } else if response.result.isSuccess {
                if let data = response.value?.dictionaryObject {
                    if let mess = data["Message"] as? String {
                        self.showAlert(title: "Message", mess: mess, style: .alert)
                    }
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
         }
        
    }
}


























