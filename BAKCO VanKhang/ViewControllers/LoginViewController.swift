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
    @IBAction func loginButtonAction(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "SecondMainViewController")
        let nav = BaseNavigationController(rootViewController: next!)
        self.present(nav, animated: true)
    }
    
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTexfield: UITextField!
    
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
            }
        }
    }
    
    private func getToken(username: String, password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let getTokenApi = URL(string: _GetTokenApi)!
        Alamofire.request(getTokenApi, method: .post, encoding: "grant_type=password&username=\(username)&password=\(password)").responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if response.result.isSuccess {
                let token = response.value?.dictionaryObject!["access_token"] as! String; print("Token: \(token)")
                self.getUserID(token: token)
            } else {
                self.showAlert(title: "LỖI", mess: (response.error?.localizedDescription)!, style: .alert)
            }
        }
    }
    
    private func getUserID(token: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let getUserIdApi = URL(string: _GetUserIdApi)!
        Alamofire.request(getUserIdApi, method: .get, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token)"]).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if response.result.isSuccess {
                if let dict = response.value?.dictionaryObject {
                self.showAlert(title: "Thành công", mess: "Đăng nhập thành công", style: .alert)
                    print(dict as Any)
                    self.currentUser = User(data: dict)
                    self.pushToMainViewController()
                }
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
    func pushToMainViewController() {
        let mainTab = self.storyboard?.instantiateViewController(withIdentifier: "tab")
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = mainTab
            window.makeKeyAndVisible()
        }, completion: nil)
    }

}


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}







