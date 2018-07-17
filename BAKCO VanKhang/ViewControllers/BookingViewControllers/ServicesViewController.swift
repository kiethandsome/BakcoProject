//
//  ServicesViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 7/4/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit
import AlamofireSwiftyJSON
import Alamofire
import SwiftyJSON
import MBProgressHUD


// Mark: Properties
class ServicesViewController: BaseViewController {
    @IBOutlet weak var servicesTableView: UITableView!
    var servicesArray = [DoctorService]() {
        didSet {
            self.servicesTableView.reloadData()
        }
    }
    var doctor = Doctor()
    let serviceGroupId = 2
}

// Mark: Methods
extension ServicesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dịch vụ của bác sĩ"
        showBackButton()
        config(tableView: servicesTableView)
        getDoctorServices()
    }

    private func config(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60.0
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.specialGreenColor()
        tableView.separatorInset.left = 0
    }
    
    private func getDoctorServices() {
        let url = URL(string: API.getDoctorServices + "?DoctorId=" + "\(doctor.id)" + "&ServiceGroup=" + "\(serviceGroupId)" )!
        self.showHUD()
        let completionHandler : ((DataResponse<JSON>) -> Void) = { response in
            self.hideHUD()
            print(response)
            if let error = response.error {
                self.showAlert(title: "Lỗi", mess: error.localizedDescription, style: .alert)
            } else {
                if let array = response.value?.array {
                    array.forEach({ (json) in
                        if let data = json.dictionaryObject {
                            let service = DoctorService(data: data)
                            self.servicesArray.append(service)
                        } else {
                            print("No Data dict")
                        }
                    })
                } else {
                    print("NO data array")
                }
            }
        }
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON(completionHandler: completionHandler)
    }
}

// Mark: Delegate and Datasource
extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath)
        cell.textLabel?.text = servicesArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// Gán
        let serviceId = servicesArray[indexPath.row].id
        BookingInfo.serviceId = serviceId
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}



















