//
//  FavoriteDrViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/11/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import MBProgressHUD

class FavoriteDrViewController: BaseViewController {
        
    var familyDoctorList = [FamilyDoctor]() {
        didSet {
            favDoctorTableview.reloadData()
        }
    }
    
    @IBOutlet var favDoctorTableview: UITableView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        favDoctorTableview.delegate = self
        favDoctorTableview.dataSource = self
        favDoctorTableview.rowHeight = 70.0
        favDoctorTableview.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoriteDoctors(phone: MyUser.phone, serviceId: SelectedFDItem.serviceId)
    }
    
    func setupNavBar() {
        showBackButton()
        self.title = SelectedFDItem.serviceName
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleBarButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func handleBarButton() {
        let vc = MyStoryboard.familyDoctorStoryboard.instantiateViewController(withIdentifier: "DoctorByServiceViewController")
        let nav = BaseNavigationController(rootViewController: vc)
        self.navigationController?.present(nav, animated: true)
    }
}

//Mark: API request.

extension FavoriteDrViewController {
    
    func getFavoriteDoctors(phone: String, serviceId: String) {
        self.familyDoctorList.removeAll()
        let param: Parameters = [ "Phone": phone,
                                  "ServiceId": serviceId ]
        let url = URL(string: API.FamilyDoctor.favoriteDoctorList)!
        MBProgressHUD.showAdded(to: self.view , animated: true)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if response.result.isSuccess {
                
                guard let dict = response.value?.dictionaryObject,
                    let data = dict["data"] as? [[String : Any]]
                    else { return }
                data.forEach({ (familyDoctor) in
                    let newFD = FamilyDoctor(data: familyDoctor)
                    self.familyDoctorList.append(newFD)
                })
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
    
    func removeDoctorFromFavoriteList(tableView: UITableView, indexPath: IndexPath, phone: String, serviceId: String, doctorId: String) {
        
        let param: Parameters = [ "Phone": phone,
                                  "DoctorId" : doctorId,
                                  "ServiceId": serviceId
                                  ]
        
        let url = URL(string: API.FamilyDoctor.removeDoctor)!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if response.result.isSuccess {
                print(response)
                
                guard let dict = response.value?.dictionaryObject,
                    let mess = dict["mess"] as? String
                else { return }
                
                if mess == "Xóa thành công." {
                    self.deleteRowAndUpdateDoctorList(tableView: tableView, indexPath: indexPath)
                }
            } else {
                self.showAlert(title: "Lỗi", message: response.error.debugDescription, style: .alert, hasTwoButton: false, okAction: { (okAction) in
                    
                })
            }
        }
    }
    
    
    func callDoctorService(doctorName: String, doctorId: String, doctorPhone: String) {
        let param = [
            "Phone": MyUser.phone,
            "ServiceId": SelectedFDItem.serviceId,
            "DoctorId": doctorId,
            "DoctorName": doctorPhone,
            "DoctorPhone": doctorPhone,
            "DeviceType": "iOS",
            "DeviceToken": _deviceToken
        ]
        let url = URL(string: API.FamilyDoctor.callService)!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)

            if response.result.isSuccess {
                print(response)
                guard let dict = response.value?.dictionaryObject,
                    let mess = dict["mess"] as? String
                    else { return }
                self.showAlert(title: "Thông báo", mess: mess, style: .alert)
            } else {
                self.showAlert(title: "Lỗi", message: (response.error?.localizedDescription)!, style: .alert, hasTwoButton: false, okAction: { (ok) in
                    
                })
            }
        }
    }
}

extension FavoriteDrViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyDoctorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavDoctorCell", for: indexPath)
        cell.textLabel?.text = familyDoctorList[indexPath.row].doctorName
        cell.detailTextLabel?.text = familyDoctorList[indexPath.row].doctorPhone
        
        cell.textLabel?.textColor = UIColor.specialGreenColor()
        cell.detailTextLabel?.textColor = UIColor.lightGray
        return cell
    }
    
    /// Commit editting style
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let doctor = self.familyDoctorList[indexPath.row]

        let delButton = UITableViewRowAction(style: .default, title: "Xoá") { (delete, indexpath) in
            self.removeDoctorFromFavoriteList(tableView: tableView, indexPath: indexPath, phone: MyUser.phone, serviceId: SelectedFDItem.serviceId, doctorId: doctor.doctorId)
        }
        let callServiceButton = UITableViewRowAction(style: .default, title: "Gọi dịch vụ") { (callService, indexpath) in
            self.callDoctorService(doctorName: doctor.doctorName, doctorId: doctor.doctorId, doctorPhone: doctor.doctorPhone)
        }
        callServiceButton.backgroundColor = UIColor.specialGreenColor()
        return [callServiceButton, delButton]
    }
    
    func deleteRowAndUpdateDoctorList(tableView: UITableView, indexPath: IndexPath) {
        tableView.beginUpdates()
        self.familyDoctorList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .middle)
        tableView.endUpdates()
    }
    
    
}

















