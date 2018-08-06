//
//  ExpDoctorViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 5/3/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

protocol ExpDoctorViewControllerDelegate: class {
    func didSelectDoctor(doctor: Doctor)
}

class ExpDoctorViewController: BaseViewController {
    @IBOutlet var doctorTableview: UITableView!
    var doctorList: [Doctor] = [] {
        didSet {
            doctorTableview.reloadData()
        }
    }
    weak var delegate: ExpDoctorViewControllerDelegate!
    var hospitalId = Int()
    
    override func dismisss() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        BookingInfo.doctor = Doctor()
    }
}

extension ExpDoctorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chuyên gia"
        config(tableView: doctorTableview)
        getDoctor(hospitalId: self.hospitalId)
        showCancelButton(title: "Huỷ")
    }
    
    fileprivate func config(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.specialGreenColor()
        tableView.rowHeight = 60.0
        tableView.separatorInset.left = 0
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func getDoctor(hospitalId: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let api = URL(string: API.getDoctor + "/\(hospitalId)")!
        let completionHandler: (DataResponse<JSON>) -> Void = {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.doctorList.removeAll()
            print(response)
            let dataArray = response.value?.array
            dataArray?.forEach({ (json) in
                guard let data = json.dictionaryObject else { return }
                let doctor = Doctor(data: data)
                self.doctorList.append(doctor)
                print(doctor.fullName)
            })
        }
        Alamofire.request(api, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON(completionHandler: completionHandler)
    }
}


extension ExpDoctorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doctorCell", for: indexPath)
        cell.textLabel?.text = doctorList[indexPath.row].fullName
        cell.detailTextLabel?.text = "\(doctorList[indexPath.row].id)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let doctor = self.doctorList[indexPath.row]
        
        let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "ServicesViewController") as! ServicesViewController
        vc.doctor = doctor
        self.navigationController?.pushViewController(vc, animated: true)
        self.delegate.didSelectDoctor(doctor: doctor)
    }
    
}













