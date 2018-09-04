//
//  ViewController.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 10/19/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import CoreLocation
import DynamicColor
import AlamofireSwiftyJSON
import Alamofire
import MBProgressHUD


struct MyLocation {
    static var long = Double() {
        didSet {
            print("Long: \(long)")
        }
    }
    static var lat = Double() {
        didSet {
            print("Lat: \(lat)")
        }
    }
}

class MainViewController: BaseViewController  {
    
    @IBOutlet weak var sosButton: UIButton!
    @IBAction func checkConnection(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork(){
            
        } else {
            print("Internet Connection not Available!")
        }
    }
    
    func setupSOSButton() {
        sosButton.layer.cornerRadius = sosButton.bounds.width / 2
        sosButton.clipsToBounds = true
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        longPressed.minimumPressDuration = 1.0
        longPressed.delegate = self
        sosButton.addGestureRecognizer(longPressed)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let parameters: Parameters = ["Phone": MyUser.phone,
                                          "Lat": MyLocation.lat,
                                          "Lng": MyLocation.long,
                                          "Speed": 0]
            let sosUrl = URL(string: API.sosEmergency)!
            self.showHUD()
            Alamofire.request(sosUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (responseString) in
                self.hideHUD()
                print(responseString)
                let mapVc = MyStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MapViewController")
                self.presentVcWithNav(vc: mapVc)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSOSButton()
        setupUserRightBarButton()
        
        self.checkContract(phone: MyUser.phone)
        
        self.checkCoreLocationPermission()
        ///
        if MyUser.id != 0 {
            print("User id : \(MyUser.id)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkCoreLocationPermission()
    }
    
    private func checkContract(phone: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let link: String = "\(API.FamilyDoctor.checkContract)?phone=\(phone)&lat=\(MyLocation.lat)&lng=\(MyLocation.long)"
        guard let url = URL(string: link) else {return}
        
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseString { (responseString) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if responseString.result.isSuccess {
                print(responseString.result.description)
            } else {
                print(responseString.error?.localizedDescription as Any)
            }
        }
        
    }
    
    // Mark: Booking Button
    @IBAction func bookingButtonAction(_ sender: Any) {
        let next = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "BookingViewController")
        navigationController?.pushViewController(next, animated: true)
    }
    
    //Mark: Telehealth booking button
    @IBAction func advisoryButtonAction(_ sender: Any) {
        let teleHealthViewController = MyStoryboard.teleHealthStoryboard.instantiateViewController(withIdentifier: "TeleHealthViewController")
        self.navigationController?.pushViewController(teleHealthViewController, animated: true)
    }
    
    //Mark: Family Doctor
    @IBAction func familyDoctorButonAction(_ sender: Any) {
        let popUpVc = MyStoryboard.familyDoctorStoryboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        tabBarController?.view.addSubview((popUpVc.view)!)
        tabBarController?.addChildViewController(popUpVc)
    }
    
    // Mark : Medical television Button
    @IBAction func medicalTvButtonAction(_ sender: Any) {
        self.showAlert(title: "Xác nhận", message: "Mở trình duyệt?", style: .actionSheet, hasTwoButton: true) { (okAction) in
            let url = URL(string: Link._MedicalTvLink)
            UIApplication.shared.open(url!)
        }
    }


    func checkingConnection() {
        
    }
    
    func checkInsternetConnection() {
        
    }
    
    func checkGPS() -> Bool {
        if CLLocationManager.authorizationStatus() == .restricted{
            self.showAlert(title: "Bật định vị", message: "Vui lòng bật định vị để sử dụng dịch vụ của chúng tôi!", style: .alert) { (_) in
                // move to settings
            }
            return false
        }
        return true
    }
    

}













