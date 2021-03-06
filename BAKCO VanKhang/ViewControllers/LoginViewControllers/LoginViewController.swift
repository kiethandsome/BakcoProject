//
//  LoginViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/6/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import DynamicColor
import Alamofire
import AlamofireSwiftyJSON
import MBProgressHUD

class LoginViewController: BaseViewController {
        
    var currentUser: User? {
        didSet {
            User.setCurrent(currentUser!)
        }
    }
    
    @IBOutlet var buttonView: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTexfield: UITextField!

    @IBAction func loginButtonAction(_ sender: Any) {
        let next = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "SignUpViewController")
        let nav = BaseNavigationController(rootViewController: next)
        self.present(nav, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        buttonView.layer.cornerRadius = buttonView.bounds.height / 2
        buttonView.clipsToBounds = true

        loginButton.layer.cornerRadius = 9.0
        loginButton.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        let loginTextAttributes: [NSAttributedStringKey : Any] = [.foregroundColor: UIColor.lightGray]
        self.usernameTextfield.attributedPlaceholder = NSAttributedString(string: "Tên đăng nhập",
                                                                          attributes: loginTextAttributes)
        self.passwordTexfield.attributedPlaceholder = NSAttributedString(string: "Mật khẩu",
                                                                         attributes: loginTextAttributes)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Login(_ sender: Any) {
        if let username = self.usernameTextfield.text, self.usernameTextfield.text != "" {
            if let password = self.passwordTexfield.text, self.passwordTexfield.text != "" {
                self.getToken(username: username, password: password)
            } else {
                showAlert(title: "Chưa thế đăng nhập!", mess: "Bạn chưa nhập mật khẩu", style: .alert)
            }
        } else {
            showAlert(title: "Chưa thế đăng nhập!", mess: "Bạn chưa nhập mật khẩu", style: .alert)
        }
    }
    
    private func getToken(username: String, password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let getTokenApi = URL(string: API.getToken)!
        Alamofire.request(getTokenApi, method: .post, encoding: "grant_type=password&username=\(username)&password=\(password)").responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if response.result.isSuccess {
                print(response.response?.statusCode as Any)
                guard let dict = response.value?.dictionaryObject else { return }
                if let token = dict["access_token"] as? String {
                    print("Token: \(token)")
                    self.getUserID(token: token)
                } else if let error = dict["error_description"] as? String {
                    self.showAlert(title: "Error", message: error, style: .alert, hasTwoButton: false, okAction: { (okAction) in })
                }
            } else {
                self.showAlert(title: "LỗI", mess: (response.error?.localizedDescription)!, style: .alert)
            }
        }
    }
    
    private func getUserID(token: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let getUserIdApi = URL(string: API.getUserId)!
        Alamofire.request(getUserIdApi, method: .get, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if response.result.isSuccess {
                if let dict = response.value?.dictionaryObject {
                self.showAlert(title: "Thành công", mess: "Đăng nhập thành công", style: .alert)
                    print(dict as Any)
                    self.currentUser = User(data: dict)
                    self.saveToken(token: token)
                    self.pushToMainViewController()
                    self.saveUserName()
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
    private func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: UserToken)
        MyUser.token = token
    }
    
    func saveUserName() {
        MyUser.username = self.usernameTextfield.text!
    }
    
    func pushToMainViewController() {
        let mainTab = MyStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "tab")
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window, duration: 0.5, options: .curveEaseIn, animations: {
            window.rootViewController = mainTab
            window.makeKeyAndVisible()
        }, completion: nil)
    }

}









