//
//  BaseViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 11/22/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import DynamicColor
import Alamofire
import AlamofireSwiftyJSON
import MBProgressHUD
import CoreLocation
import GooglePlaces



class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let tokenHeader = ["Authorization" : "Bearer \(MyUser.token)"]
    
    var locationManager = CLLocationManager()
    var location: CLLocation!{
        didSet {
            MyLocation.lat = location.coordinate.latitude
            MyLocation.long = location.coordinate.longitude
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        tabBarController?.tabBar.isTranslucent = false
        view.backgroundColor = UIColor.white

    }
    
    @objc func dismisss() {
        dismiss(animated: true) {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    ///MArk: Right Bar button
    func showRightBarButton(title: String, action: Selector?) {
        let barButton = UIBarButtonItem(title: title, style: .done, target: self, action: action)
        navigationItem.rightBarButtonItem = barButton
        barButton.isEnabled = false
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
        let menuButon = UIBarButtonItem(image: #imageLiteral(resourceName: "green-menu-2").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showUserMenu))
        navigationItem.rightBarButtonItem = menuButon
    }
    @objc func showUserMenu() {
        let menuVc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        let baseNav = BaseNavigationController(rootViewController: menuVc)
        present(baseNav, animated: true, completion: nil)
    }
    
    ///Mark: Popdown Button
    func setupPopDownButton() {
        let backButton = UIBarButtonItem(title: "Trở về", style: .plain, target: self, action: #selector(dismisss))
        navigationItem.leftBarButtonItem = backButton
    }

    
    ///Mark: Cancel button
    func showCancelButton(title: String = "Huỷ") {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(dismisss))
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
    
    func showHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension BaseViewController {
    
    func requestAPIwith(urlString: String, method: HTTPMethod, params: Parameters, completion: @escaping (_ response: [String : Any]) -> Void ) {
        let url = URL(string: urlString)!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            print(response.description)
            if let responsed = response.value?.dictionaryObject, response.error == nil {
                completion(responsed)
                print(responsed)
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
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
    
    func presentVcWithNav(vc: UIViewController) {
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}

extension BaseViewController {
    
    open func reqestApiWithToken(url: String, method: HTTPMethod, param: Parameters, completion: @escaping (_ response : [String: Any]) -> Void) {
        let urll = URL(string: url)!
        self.showHUD()
        Alamofire.request(urll, method: method, parameters: param, encoding: JSONEncoding.default, headers: self.tokenHeader).responseSwiftyJSON { (response) in
            self.hideHUD()
            print(response)
            if let responsed = response.value?.dictionaryObject, response.error == nil {
                completion(responsed)
            } else {
                self.showAlert(title: "Lỗi", mess: response.debugDescription, style: .alert)
            }
        }
    }
    
}



extension BaseViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = (locations ).last
//        locationManager.stopUpdatingLocation()
    }
    
    func checkCoreLocationPermission(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            self.locationManager.startUpdatingLocation()
        }
        else if CLLocationManager.authorizationStatus() == .notDetermined{
            self.locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .restricted{
            print("unauthorized")
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

}









