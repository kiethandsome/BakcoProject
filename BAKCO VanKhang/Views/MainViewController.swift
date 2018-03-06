//
//  ViewController.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 10/19/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: BaseViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate  {
    
    @IBOutlet var redButton: UIButton!
    @IBAction func rebButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HospitalViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBOutlet var greenButton: UIButton!
    @IBAction func greenButtonAction(_ sender: Any) {
        
    }
    
    @IBOutlet var blueButton: UIButton!
    @IBAction func blueButtonAction(_ sender: Any) {
        
    }
    
    let sosButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "CallSOS"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "CallSOS").withRenderingMode(.alwaysTemplate), for: .selected)
        button.addTarget(self, action: #selector(SOS(_:)), for: .touchUpInside)
        return button
    }()
    
    let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sosButton)
        setupSOSButton()
        setupMenuButtonAndSideMenu() // Jump to defination for more
        setupBottomButtons()
        addPanGestureToPresentMenu()
    }
    
    func setupBottomButtons() {
        redButton.layer.cornerRadius = 10.0
        redButton.clipsToBounds = true
        redButton.layer.borderWidth = 1.0
        redButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupSOSButton() {
        let buttonWidth = view.bounds.size.height / 4
        sosButton.center.x = view.center.x
        sosButton.frame = CGRect(x: (view.frame.size.width - buttonWidth) / 2, y: 230, width: buttonWidth, height: buttonWidth)
        sosButton.layer.cornerRadius = buttonWidth / 2
        sosButton.clipsToBounds = true
        let anotherWidth = sosButton.frame.size.width / 4
        sosButton.contentEdgeInsets = UIEdgeInsets(top: -anotherWidth,
                                                   left: -anotherWidth,
                                                   bottom: -anotherWidth,
                                                   right: -anotherWidth)
    }
    
    @IBAction func SOS(_ sender: Any) {
        makeACall(scheme: "")
    }
    
    func makeACall(scheme: String) {
        if let url = URL(string: scheme) {
            if(UIApplication.shared.canOpenURL(url))
            {
                if #available(iOS 10, *)
                {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                                                print("Open \(scheme): \(success)")})
                }
                else
                {
                    let success = UIApplication.shared.openURL(url)
                    print("Open \(scheme): \(success) 9")
                }
            }
            else
            {
                print ("error")
            }
        }
    }
    
    ///location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
    
    // Collection view delegate data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MenuCell
        cell.tintColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.height / 3, height: (view.frame.height / 3) * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}

class MenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let imageCell: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










