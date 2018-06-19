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
    static var long = Double()
    static var lat = Double()
}

class MainViewController: BaseViewController  {
    
    @IBOutlet weak var sosButton: UIButton!
    @IBAction func checkConnection(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork(){
        }else{
        }
    }
    
    func setupSOSButton() {
        sosButton.layer.cornerRadius = sosButton.bounds.width / 2
        sosButton.clipsToBounds = true
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        longPressed.minimumPressDuration = 2.0
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
            
            locationManager.startUpdatingLocation()
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Alamofire.request(sosUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
                MBProgressHUD.hide(for: self.view, animated: true)
                print(response.value as Any)
                let test = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")
                self.navigationController?.pushViewController(test!, animated: true)
            }
        }
    }
    
    /*_______________________________*/
    // Location
    var locationManager = CLLocationManager()
    var location: CLLocation!{
        didSet {
            MyLocation.lat = location.coordinate.latitude
            MyLocation.long = location.coordinate.longitude
            print("Long: \(location.coordinate.latitude), Lat: \(location.coordinate.longitude)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sosButton)
        view.backgroundColor = .white

        setupSOSButton()
        setupUserRightBarButton()
        
        showLogoImage()
        self.checkContract(phone: MyUser.phone)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkCoreLocationPermission()
        ///
        if MyUser.id != 0 {
            print("User id : \(MyUser.id)")
        }
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
}

//Mark: Location manager delegate.

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = (locations ).last
        locationManager.stopUpdatingLocation()
    }
    
    func checkCoreLocationPermission(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
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
    

}













