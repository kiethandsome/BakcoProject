//
//  BaseViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 11/22/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import DynamicColor
import Hero
import Alamofire
import AlamofireSwiftyJSON
import MBProgressHUD



class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = DynamicColor(hexString: "f7f9f9")
    }
    
    ///mark: Back Button
    func showBackButton() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "green-back").withRenderingMode(.alwaysTemplate) , style: .plain, target: self, action: #selector(popToBack))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func popToBack() {
        navigationController?.popViewController(animated: true)
    }
    
    ///Mark: MenuButton
    func setupUserRightBarButton() {
        let menuButon = UIBarButtonItem(image: #imageLiteral(resourceName: "user (1)").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showUserMenu))
        navigationItem.rightBarButtonItem = menuButon
    }
    @objc func showUserMenu() {
        let menuVc = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        let baseNav = BaseNavigationController(rootViewController: menuVc)
        present(baseNav, animated: true, completion: nil)
    }
    
    ///Mark: Popdown Button
    func setupPopDownButton() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Cancel2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismisss))
        navigationItem.rightBarButtonItem = backButton
    }
    @objc func dismisss() {
        dismiss(animated: true) {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    ///Mark: Cancel button
    func showCancelButton() {
        let backButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(dismisss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    ///Mark: Default Alert
    func showAlert(title: String, mess: String, style: UIAlertControllerStyle, isSimpleAlert: Bool = true) {
        let alertController = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.okAction()
        }
        alertController.addAction(okAction)

        if !isSimpleAlert { ///simple alert
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        

        present(alertController, animated: true)
    }
    
    func okAction() {
        
    }
    
    ///Mark: Logo Image
    func showLogoImage() {
        let width = UIScreen.main.bounds.width / 4
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 30))
        let imageView = UIImageView(image: #imageLiteral(resourceName: "vankhang_logo"))
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: 30)
        imageView.contentMode = .scaleAspectFit
        containView.addSubview(imageView)
        let leftButton = UIBarButtonItem(customView: containView)
        leftButton.isEnabled = false
        navigationItem.leftBarButtonItem = leftButton
    }

    func login() {}


}

extension BaseViewController {
    
    func requestAPIwith(urlString: String, method: HTTPMethod, params: Parameters, completion: @escaping (_ response: [String : Any]) -> Void ) {
        let url = URL(string: urlString)!
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            print(response.description)
            if let responsed = response.value?.dictionaryObject, response.error == nil {
                completion(responsed)
                print(responsed)
            } else {
                self.showAlert(title: "Lỗi", mess: (response.error?.localizedDescription)!, style: .alert)
            }
            
        }
    }
    
    
    open func showAlert(title: String, message: String, style: UIAlertControllerStyle, hasTwoButton: Bool = true, okAction: @escaping (_ action: UIAlertAction) -> Void ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: okAction)
        alert.addAction(ok)

        if hasTwoButton {
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        present(alert, animated: true)
    }

    
}
















