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

protocol ServiceViewControllerDelegate: class {
    func didSelectDoctorService(service: DoctorService)
}


// Mark: Properties
class ServicesViewController: BaseViewController {
    @IBOutlet weak var servicesTableView: UITableView!
    var servicesArray = [DoctorService]() {
        didSet {
            self.servicesTableView.reloadData()
        }
    }
    var doctor = Doctor()
    let serviceGroupId = BookingInfo.serviceType.id
    var form = Int()
    var direction: DirectViewController! {
        didSet {
            if direction == .booking {
                self.form = 1
            } else if direction == .teleHealth {
                self.form = 2
            }
        }
    }
    
    
    override func popToBack() {
        navigationController?.popViewController(animated: true)
        BookingInfo.doctorService = DoctorService() // release
    }
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
        let url = URL(string: API.getDoctorServices + "?DoctorId=" + "\(doctor.id)" + "&ServiceGroup=" + "\(serviceGroupId)" + "&Form=" + "\(form)" )!
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
        BookingInfo.doctorService = servicesArray[indexPath.row]
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}



















