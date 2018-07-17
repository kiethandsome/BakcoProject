//
//  patientListViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/17/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import AlamofireSwiftyJSON
import Alamofire
import MBProgressHUD
import UIKit
import SwiftyJSON

public enum DirectViewController {
    case booking
    case teleHealth
}

/// Mark: Properties
class PatientListViewController: BaseViewController {

    var patientList: [User?] = [MyUser.current] {
        didSet {
            self.patientTableview.reloadData()
        }
    }

    var direct: DirectViewController!

    @IBOutlet weak var patientTableview: UITableView!
}

/// Mark: Methods
extension PatientListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bệnh nhân"
        showCancelButton()
        self.config(tv: patientTableview)
        setupAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getpatientList()
    }
    
    func setupAddButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func add() {
        let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "AddPatientViewController") as! AddPatientViewController
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func config(tv: UITableView) {
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        tv.separatorColor = UIColor.specialGreenColor()
        tv.separatorInset.left = 0.0
        tv.rowHeight = 70.0
        tv.register(UINib(nibName: "PatientCell", bundle: nil), forCellReuseIdentifier: "PatientCell")
    }
    
    func getpatientList() {
        let api = URL(string: API.getPatients + "?CustomerId=\(MyUser.id)")!
        let completionHandler = { (response: DataResponse<JSON>) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.parseToSystempatientList(with: response)
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(api, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON(completionHandler: completionHandler)

    }
    
    func parseToSystempatientList(with response: DataResponse<JSON>) {
        print(response)
        patientList = [MyUser.current!]
        if response.result.isSuccess {
            guard let dataArray = response.value?.array else { return }
            dataArray.forEach({ (Json) in
                guard let data = Json.dictionaryObject else {return}
                let patient = User(data: data)
                patientList.append(patient)
            })
        } else {
            self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
        }
    }
}

extension PatientListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientCell
        cell.nameLabel.text = patientList[indexPath.row]?.fullName
        cell.phoneNumLabel.text = patientList[indexPath.row]?.phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedUser = patientList[indexPath.row]  else { return }
        let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "PatientInfoViewController") as! PatientInfoViewController
        vc.userId = selectedUser.id
        vc.direct = self.direct
        navigationController?.pushViewController(vc, animated: true)
    }
}




















