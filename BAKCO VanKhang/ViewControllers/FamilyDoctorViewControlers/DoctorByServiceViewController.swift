//
//  DoctorByServiceViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/13/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class DoctorByServiceViewController : BaseViewController {
    
    var familyDoctors = [FamilyDoctor]() {
        didSet {
            self.doctorTableview.reloadData()
        }
    }
    
    @IBOutlet var searchTextfield: UITextField!
    @IBOutlet var doctorTableview: UITableView!
    @IBOutlet var searchButton : UIButton!
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        guard let text = searchTextfield.text else {
            return
        }
        getDoctors(serviceId: SelectedFDItem.serviceId, phone: MyUser.phone, keyWord: text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextfield.addTarget(self, action: #selector(textDidChange(_:)), for: UIControlEvents.editingChanged)
        setupUI()
    }
    
    @objc func textDidChange(_ textfield: UITextField) {
        guard let text = searchTextfield.text else { return }
        if text == "" {
            self.searchButton.isEnabled = false
            self.searchButton.backgroundColor = UIColor.lightGray
        } else {
            self.searchButton.isEnabled = true
            self.searchButton.backgroundColor = UIColor.specialGreenColor()
        }
    }
    
    private func setupUI() {
        self.title = "Chọn bác sĩ"
        self.searchButton.isEnabled = false
        self.searchButton.backgroundColor = UIColor.lightGray
        config(tableView: self.doctorTableview)
        showCancelButton(title: "Xong")
    }
    
    func config(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset.left = 0
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.doctorTableview.endEditing(true)
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        self.doctorTableview.resignFirstResponder()
    }
    
}

//Mark: APi methods.

extension DoctorByServiceViewController {
    
    func getDoctors(serviceId: String, phone: String, keyWord: String) {
        let param: Parameters = [ "Phone": phone,
                                  "ServiceId": serviceId,
                                  "Keyword" : keyWord]
        let url = URL(string: FamilyDocrorApi.doctorListByService)!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if response.result.isSuccess {
                self.familyDoctors.removeAll()
                guard let dict = response.value?.dictionaryObject,
                    let data = dict["data"] as? [[String : Any]]
                    else { return }
                data.forEach({ (familyDoctor) in
                    let newFD = FamilyDoctor(data: familyDoctor)
                    self.familyDoctors.append(newFD)
                })
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
    
    func addDoctorToFavList(tableView: UITableView, phone: String, doctorId: String, serviceId: String, indexPath: IndexPath) {
        let params = [
            "Phone": phone,
            "DoctorId": doctorId,
            "ServiceId": serviceId
        ]
        
        let url = URL(string: FamilyDocrorApi.addDoctor)!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if response.result.isSuccess {
                print(response)
                let dict = response.value?.dictionaryObject!
                let mess = dict!["mess"] as! String
                self.showAlert(title: "Xác nhận", message: mess, style: .alert, hasTwoButton: false, okAction: { (ok) in
                    ///Delete selected item in doctor list
                    self.deleteRow(tableview: tableView, indexPath: indexPath)
                })
            } else {
                self.showAlert(title: "Lỗi", mess: (response.error?.localizedDescription)!, style: .alert)
            }
        }
    }
    
    
}

// Mark : TABLVIEW DELEGATE DATASOURCE

extension DoctorByServiceViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.familyDoctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath)
        cell.textLabel?.text = familyDoctors[indexPath.row].doctorName
        cell.textLabel?.textColor = UIColor.specialGreenColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let doctorID = familyDoctors[indexPath.row].doctorId
        
        self.showAlert(title: "Xác nhận", message: "Bạn muốn thêm bác sĩ này vào danh sách ưa thích?", style: .alert) { (ok) in
            self.addDoctorToFavList(tableView: tableView, phone: MyUser.phone, doctorId: doctorID, serviceId: SelectedFDItem.serviceId, indexPath: indexPath)
        }
    }
    
    private func deleteRow(tableview: UITableView, indexPath: IndexPath) {
        tableview.beginUpdates()
        self.familyDoctors.remove(at: indexPath.row)
        tableview.deleteRows(at: [indexPath], with: .middle)
        tableview.endUpdates()
    }
}

























