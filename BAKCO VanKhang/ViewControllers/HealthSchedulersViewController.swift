//
//  HealthSchedulersViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 1/24/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import AlamofireSwiftyJSON
import Alamofire

class HealthSchedulersViewController: BaseViewController {
    
    @IBOutlet var tableView1: UITableView!
    var schedulerList = [Appointment]() {
        didSet {
            self.tableView1.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Lịch đã đặt"
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.contentInset = UIEdgeInsets(top: 25.0, left: 0, bottom: 25.0, right: 0)
        tableView1.separatorStyle = .none
        loadSchedule(with: MyUser.id)
        showBackButton()
    }
    
    func loadSchedule(with Id: Int) {
        MBProgressHUD.showAdded(to: self.tableView1, animated: true)
        let url = URL(string: "http://api.vkhs.vn/api/BkCustomer/GetSchedulerCustomer?CustomerId=\(MyUser.id)")
        Alamofire.request(url!, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.tableView1, animated: true)
            
            if response.result.isSuccess {
                print("Lịch đã đặt: \n\(response)")
                let dataArray = response.value?.array
                for dataJson in dataArray! {
                    let data = dataJson.dictionaryObject
                    let schedule = Appointment(data: data!)
                    print(schedule.id)
                    print(schedule.customer?.id ?? -10)
                    self.schedulerList.append(schedule)
                }
            } else {
                print("LỖI KO CÓ LỊCH")
                self.showAlert(title: "Lỗi", mess: "Bệnh nhân này chưa đặt lịch khám!", style: .alert)
            }
        }
    }
}

extension HealthSchedulersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedulerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HealthSchedulerCell", owner: self, options: nil)?.first as! HealthSchedulerCell
        cell.selectionStyle = .none
        configCell(cell: cell, indexPath: indexPath.row, scheduler: self.schedulerList[indexPath.row])
        return cell
    }
    
    private func configCell(cell: HealthSchedulerCell, indexPath: Int, scheduler: Appointment) {
        if let hospitalName = scheduler.hospital?.Name {
            cell.hospitalNameLabel.text = hospitalName
        }
        if let paintentName = scheduler.customer?.fullName {
            cell.paintentNameLabel.text = paintentName
        }
        if let insurance = scheduler.customer?.healthInsurance {
            cell.insuranceLabel.text = insurance
        }
        if let examDate = scheduler.detail?.day {
            cell.examinationDateLabel.text = examDate
        }
        if let time = scheduler.detail?.from {
            cell.timeLabel.text = time
        }
        if let roomName = scheduler.room?.Name {
            cell.roomNameLabel.text = roomName
        }
        
        cell.numberLabel.text = "Chưa có"
        cell.examinationTypeLabel.text = scheduler.type
        cell.schedulerId = scheduler.id
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HealthSchedulerCell
        
        let detailVc = self.storyboard?.instantiateViewController(withIdentifier: "DetailSchedulerViewController") as! DetailSchedulerViewController
        detailVc.id = cell.schedulerId
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    
}

class HealthSchedulerCell: UITableViewCell {
    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var paintentNameLabel: UILabel!
    @IBOutlet var insuranceLabel: UILabel!
    @IBOutlet var examinationTypeLabel: UILabel!
    @IBOutlet var examinationDateLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var roomNameLabel: UILabel!
    @IBOutlet var payStatusLabel: UILabel!
    @IBOutlet var paidIdLabel: UILabel!
    var schedulerId = -1
    
    
}





















