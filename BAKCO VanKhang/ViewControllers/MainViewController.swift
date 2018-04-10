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
import Hero
import AlamofireSwiftyJSON
import Alamofire
import MBProgressHUD

var _long = Double()
var _lat = Double()

class MainViewController: BaseViewController  {
    
    @IBOutlet var greenButton: UIButton!  //Hospitals Button
    @IBOutlet var blueButton: UIButton! //Another Button
    @IBOutlet var advisoryButton: UIButton!

    
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
                                          "Lat": _lat,
                                          "Lng": _long,
                                          "Speed": 0]
            let sosUrl = URL(string: _SOSEmergencyApi)!
            
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
    
    private func checkContract(phone: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let link: String = "\(FamilyDocrorApi.checkContract)?phone=\(phone)&lat=\(_lat)&lng=\(_long)"
        let url = URL(string: link)!
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = response.value?.dictionaryObject, response.result.isSuccess == true {
                if let message: String = data["message"] as? String {
                    print("Message: \(message)")
                }
            }
        }
    }
    
    /*_______________________________*/
    // Location
    var locationManager: CLLocationManager!
    var location: CLLocation!{
        didSet {
            _lat = location.coordinate.latitude
            _long = location.coordinate.longitude
            print("Long: \(location.coordinate.latitude), Lat: \(location.coordinate.longitude)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sosButton)
        view.backgroundColor = .white
        
        blueButton.layer.cornerRadius = 10.0
        blueButton.clipsToBounds = true
        blueButton.contentMode = .scaleToFill

        greenButton.layer.cornerRadius = 10.0
        greenButton.clipsToBounds = true

        setupSOSButton()
        setupUserRightBarButton()
        
        showLogoImage()
        self.checkContract(phone: MyUser.phone)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
        
        ///
        if MyUser.id != 0 {
            print(MyUser.id)
        }
    }
    
    @IBAction func greenButtonAction(_ sender: Any) { /// Đăng kí khám chữa bệnh.
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ChooseInformViewController")
        navigationController?.pushViewController(next!, animated: true)
    }
    
    //Mark: Advisory Button
    @IBAction func advisoryButtonAction(_ sender: Any) {
        self.showAlert(title: "Xác nhận", mess: "Mở trình duyệt?", style: .alert, isSimpleAlert: false)
    }
    override func okAction() {
        let url = URL(string: _TrueconfLink)
        UIApplication.shared.open(url!)
    }
    
    //Mark: Home dotor
    @IBAction func blueButtonAction(_ sender: Any) {
        let popUpVc = storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        tabBarController?.view.addSubview((popUpVc.view)!)
        tabBarController?.addChildViewController(popUpVc)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    ///location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = (locations ).last
        locationManager.stopUpdatingLocation()
    }
    
    func checkCoreLocationPermission(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
        else if CLLocationManager.authorizationStatus() == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .restricted{
            print("unauthorized")
        }
    }
}












