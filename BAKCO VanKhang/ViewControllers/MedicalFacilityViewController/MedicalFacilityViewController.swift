//
//  MedicalFacilityViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/22/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

class MedicalFacilityViewController: BaseViewController {
    
    @IBOutlet weak var hospitalTableView: UITableView!
    
     var hospitals = [Hospital]()
    
    var url = URL(string: API.getHospital)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configTable(tableView: self.hospitalTableView)
        getHospitals()
    }
    
    func setupUI() {
        title = "Các cơ sở khám chữa bệnh"
        showCancelButton()
    }
    
    func configTable(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.specialGreenColor()
        tableView.separatorInset.left = 0.0
        tableView.register(UINib(nibName: "MedicalFacilityCell", bundle: nil), forCellReuseIdentifier: "MedicalFacilityCell")
        tableView.rowHeight = 150
    }
    
    func getHospitals() {
        self.showHUD()
        Alamofire.request(url, method: .get).responseSwiftyJSON { (response) in
            self.hideHUD()
            print(response.value as Any)
            
            if (response.error != nil) { /// error
                self.showAlert(title: "Lỗi", mess: "Ko tìm thấy bệnh viện nào", style: .alert)
            } else {
                response.result.value?.forEach({ (json) in
                    let data = json.1.dictionaryObject
                    let newHospital: Hospital = Hospital(data: data!)
                    self.hospitals.append(newHospital)
                })
                self.hospitalTableView.reloadData()
            }
        }
    }

}

extension MedicalFacilityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicalFacilityCell", for: indexPath) as! MedicalFacilityCell
        let hospital = self.hospitals[indexPath.row]
        cell.configCell(hospital: hospital)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}








