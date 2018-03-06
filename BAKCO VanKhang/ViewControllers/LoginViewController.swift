//
//  LoginViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/6/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import DynamicColor

class LoginViewController: UIViewController {
    
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
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
       
        self.usernameTextfield.attributedPlaceholder = NSAttributedString(string: "Tên đăng nhập",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        self.passwordTexfield.attributedPlaceholder = NSAttributedString(string: "Mật khẩu",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    }
    
    func setupUI() {
        buttonView.layer.cornerRadius = buttonView.bounds.height / 2
        buttonView.clipsToBounds = true

        loginButton.layer.cornerRadius = 9.0
        loginButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Login(_ sender: Any) {
        
    }
    
    private func login(username: String, password: String) {
        
    }

}










