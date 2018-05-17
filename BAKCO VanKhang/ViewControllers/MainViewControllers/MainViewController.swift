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
    
    //Mark: Layout SOS button and SOS calling actions.___________________________/
    let sosButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-sos-ok1"), for: .normal)
        return button
    }()
    
    func setupSOSButton() {
        let buttonWidth = view.bounds.size.height / 4
        sosButton.frame = CGRect(x: (view.frame.size.width - buttonWidth) / 2,
                                 y: 100,
                                 width: buttonWidth,
                                 height: buttonWidth)
        sosButton.center.x = view.center.x
        sosButton.center.y = view.center.y - 150
        sosButton.layer.cornerRadius = buttonWidth / 2
        sosButton.clipsToBounds = true
        let anotherWidth = sosButton.frame.size.width / 30
        sosButton.contentEdgeInsets = UIEdgeInsets(top: -anotherWidth,
                                                   left: -anotherWidth,
                                                   bottom: -anotherWidth - 6,
                                                   right: -anotherWidth - 8)
        ///mark: Long pressed handle
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
//        let next = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "ChooseInformViewController")
//        navigationController?.pushViewController(next, animated: true)
        
        let next = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "BookingViewController")
        navigationController?.pushViewController(next, animated: true)
    }
    
    //Mark: Advisory Button
    @IBAction func advisoryButtonAction(_ sender: Any) {
        self.showAlert(title: "Xác nhận", message: "Mở trình duyệt?", style: .actionSheet, hasTwoButton: true) { (okAction) in
            let url = URL(string: Link._TrueconfLink)
            UIApplication.shared.open(url!)
        }
    }
    
    //Mark: Home dotor
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













