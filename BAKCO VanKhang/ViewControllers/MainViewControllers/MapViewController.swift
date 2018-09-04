//
//  MapViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 8/24/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import SwiftR
import SwiftyJSON
import Alamofire
import AlamofireSwiftyJSON

class MapViewController: BaseViewController {

    let attribute: [NSAttributedStringKey : Any] = {
        let pr = NSMutableParagraphStyle()
        pr.alignment = .center
        let attr: [NSAttributedStringKey : Any] = [.font : UIFont.systemFont(ofSize: 13.0),
                                                   .foregroundColor : UIColor.red,
                                                   .paragraphStyle : pr]
        return attr
    }()

    var mapView = GMSMapView()
    
    let ambulanceMarker: GMSMarker = {
       let marker = GMSMarker()
        marker.icon = UIImage(named: "ambulance")
        marker.isFlat = true
        marker.title = "Vị trí xe cấp cứu"
        return marker
    }()
    
    let patientMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: MyLocation.lat, longitude: MyLocation.long))
    
    var ambulanceLocation = CLLocationCoordinate2D()
    
    var polyline = GMSPolyline()
    
    var currentLocation = CLLocationCoordinate2D(latitude: MyLocation.lat, longitude: MyLocation.long)
    
    override func loadView() {
        self.checkCoreLocationPermission()
        self.setupPopDownButton()
        self.title = "Cấp cứu"
        self.configMapView()
        
        /// SignalR
        setupSignalR()
    }
    
    override func dismisss() {
        self.navigationController?.dismiss(animated: true)
        MySignalR.connection.stop()
    }
    
    fileprivate func setupSignalR() {
        MySignalR.autoSetup()
        receiveSosStatus()
        checkSignalRStatus()
    }
    
    func configMapView() {
        /// Camera
        let camera = GMSCameraPosition.camera(withLatitude: MyLocation.lat, longitude: MyLocation.long, zoom: 15.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.zoomGestures = true
        self.mapView.delegate = self
        self.view = mapView
    }
    
    // Mark: Create Marker
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = mapView
    }
    
    // Mark: Set ambulance position
    func setAmbulancePosition(title: String, icon: UIImage, lat: CLLocationDegrees, long: CLLocationDegrees) {
        self.createMarker(titleMarker: title, iconMarker: icon, latitude: lat, longitude: long)
        self.ambulanceLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    
    func checkSignalRStatus() {
        MySignalR.connection.starting = {
            print("Starting...")
        }
        MySignalR.connection.connectionSlow = {
            print("Connection slow")
        }
        MySignalR.connection.reconnecting = {
            print("Starting...")
        }
        MySignalR.connection.reconnected = {
            print("Reconnecting...")
        }
        MySignalR.connection.connected = {
            print("connected")
        }
        MySignalR.connection.disconnected = {
            print("disconnected")
        }
        MySignalR.connection.error = { error in
            print("Error: \(String(describing: error))")
            
            if let source = error?["source"] as? String, source == "TimeoutException" {
                print("Connection timed out. Restarting...")
                MySignalR.connection.start()
            }
        }
    }
    
    fileprivate func configStatusLabel1() {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "\(getCurrentTime()): Hệ thống đã nhận được yêu cầu, đang chờ xử lý", attributes: self.attribute)
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        let frame = CGRect(x: 10, y: 10, width: self.mapView.bounds.width - 20, height: 30)
        label.frame = frame
        view.addSubview(label)
    }
    
    fileprivate func configStatusLabel2() {
        let label = UILabel()
        mapView.addSubview(label)
        label.attributedText = NSAttributedString(string: "\(getCurrentTime()): Bác sĩ đã nhận ca", attributes: self.attribute)
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        let frame = CGRect(x: 10, y: 50, width: self.mapView.bounds.width - 20, height: 30)
        label.frame = frame
    }
    
    fileprivate func configStatusLabel3() {
        let label = UILabel()
        mapView.addSubview(label)
        label.attributedText = NSAttributedString(string: "\(getCurrentTime()): Bác sĩ đã tiếp cận bênh nhân", attributes: self.attribute)
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        let frame = CGRect(x: 10, y: 90, width: self.mapView.bounds.width - 20, height: 30)
        label.frame = frame
    }

    
    private func drawPolyline(patientLocation: CLLocationCoordinate2D, ambulanceLocation: CLLocationCoordinate2D) {
        let path = GMSMutablePath()
        path.add(patientLocation)
        path.add(ambulanceLocation)
        self.polyline = GMSPolyline(path: path)
        self.polyline.strokeColor = .red
        self.polyline.strokeWidth = 2.0
        self.polyline.geodesic = true
        self.polyline.map = self.mapView
    }
    
    fileprivate func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: Date())
    }
    
    func receiveSosStatus() {
        MySignalR.hub.on("receiveSOSStatus") { args in
            if let message = args![0] as? String {
                print(message)
                
                switch message {
                    
                case "1":
                    self.configStatusLabel1()
                    
                case "2":
                    self.configStatusLabel2()
                    self.receiveSOSDoctorLocation()
                    
                case "3":
                    self.configStatusLabel3()
                    self.dismisss()
                
                case "5":
                    self.showAlert(title: "Thông báo", message: "Ca cấp cứu của bạn đã được chuyển sang ngoài quy trình!", style: .alert, hasTwoButton: false, okAction: { (_) in
                        self.dismisss()
                    })
                    
                default:
                    self.dismisss()
                }
                
            } else {
                print("No response")
            }
        }
        MySignalR.connection.start()
    }

    
    func receiveSOSDoctorLocation() {
        MySignalR.hub.on("receiveSOSDoctorLocation") { args in
            if let message = args![0] as? String {
                /// Đề test trạng thái
                print(message)
                guard let dict = self.convertToDictionary(text: message) else { return }
                let lat = dict["Lat"] as! Double
                let long = dict["Lng"] as! Double
                
                /// Tạo marker và vẽ đường đi
                self.mapView.clear()
                self.setAmbulancePosition(title: "Vị trí xe cấp cứu", icon: #imageLiteral(resourceName: "ambulance"), lat: lat, long: long)
                self.drawPath(startLocation: self.currentLocation, endLocation: self.ambulanceLocation)
            } else {
                print("Cannot cast")
            }
        }
        MySignalR.connection.start()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func drawPath(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) {
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        self.showHUD()
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        Alamofire.request(url).responseSwiftyJSON { response in
            self.hideHUD()
            guard let json = response.value else { return }
            let routes = json["routes"].arrayValue
            /// print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 2.5
                polyline.strokeColor = UIColor.red
                polyline.geodesic = true
                polyline.map = self.mapView
            }
        }
    }
}


extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(" did tapped Lat: \(coordinate.latitude)")
        print(" did tapped Long: \(coordinate.longitude)")
    }
}
























