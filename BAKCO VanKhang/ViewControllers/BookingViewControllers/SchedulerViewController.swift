//
//  SchedulerViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 5/8/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import MBProgressHUD

protocol SchedulersViewControllerDelegate: class {
    func didSelectScheduler(scheduler: HealthCareScheduler)
    func didSelectTime(time: HealthCareScheduler.Time)
}

class SchedulersViewController: BaseViewController {
    @IBOutlet var dateCollectionView: UICollectionView!
    @IBOutlet var timeCollectionView: UICollectionView!
    @IBOutlet var timeSegmentControl: UISegmentedControl!
    @IBAction func selectTime(_ sender: UISegmentedControl) {
        timeCollectionView.reloadData()
    }
    var schedulerList: [HealthCareScheduler] = [] {
        didSet{
            dateCollectionView.reloadData()
        }
    }
    var morningTimeList: [HealthCareScheduler.Time] = [] {
        didSet {
            timeCollectionView.reloadData()
        }
    }
    var afternoonTimeList: [HealthCareScheduler.Time] = [] {
        didSet {
            timeCollectionView.reloadData()
        }
    }
    
    let textAttribute : [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12.0)]
    
    weak var delegate: SchedulersViewControllerDelegate!
    
    var didSelectTime: HealthCareScheduler.Time?
    
    var didSelectScheduler = HealthCareScheduler()
}

extension SchedulersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Ngày, giờ khám"
        showCancelButton()
        showRightBarButton(title: "Xong", action: #selector(done))
        navigationItem.rightBarButtonItem?.isEnabled = false
        config(collectionView: dateCollectionView)
        config(collectionView: timeCollectionView)
        
        if BookingInform.exTypeId == "2" {
            /// Lấy lịch theo chuyên gia
            getSchedulerForExpDoctor(doctorId: BookingInform.doctor.id, hospitalId: BookingInform.hospital.Id)
        } else {
            /// Lấy lịch theo thông thường
            getSchedulerNormally(hospitalId: BookingInform.hospital.Id,
                                 healthcareId: BookingInform.specialty.Id,
                                 type: BookingInform.exTypeId)
        }
    }
    
    @objc func done() {
        delegate.didSelectScheduler(scheduler: didSelectScheduler)
        if let time = didSelectTime {
            delegate.didSelectTime(time: time)
            dismiss(animated: true)
        }
        showAlert(title: "Lỗi", mess: "Bạn chưa chọn giờ!", style: .alert)
    }
    
    fileprivate func config(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "schedulerCell")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func getSchedulerNormally(hospitalId: Int, healthcareId: Int, type: String) {
        let parameters: Parameters = ["HospitalId": hospitalId,
                                      "HealthCareId": healthcareId,
                                      "Type": type]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string:API.getHealthCareScheduler)!, method: .get, parameters: parameters).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                self.showAlert(title: "Lỗi", mess: error.localizedDescription, style: .alert)
            } else {
                self.schedulerList.removeAll()
                response.value?.forEach({ (json) in
                    let newHealthCareScheduler = HealthCareScheduler(data: json.1.dictionaryObject!)
                    self.schedulerList.append(newHealthCareScheduler)
                })
            }
        }
    }
    
    func getSchedulerForExpDoctor(doctorId: Int, hospitalId: Int) {
        let parameters: Parameters = ["HospitalId": hospitalId,
                                      "DoctorId": doctorId]
        let api = URL(string: API.getSchedulerByDoctor)!
        let completionHandler: (DataResponse<JSON>) -> Void = {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                self.showAlert(title: "Lỗi", mess: error.localizedDescription, style: .alert)
            } else {
                self.schedulerList.removeAll()
                response.value?.forEach({ (json) in
                    let newHealthCareScheduler = HealthCareScheduler(data: json.1.dictionaryObject!)
                    self.schedulerList.append(newHealthCareScheduler)
                })
            }
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(api, method: .get, parameters: parameters).responseSwiftyJSON(completionHandler: completionHandler)
    }
}

extension SchedulersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90.0, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        /// Ngày
        case dateCollectionView:
            if schedulerList.count > 0 {
                return schedulerList.count
            }
            return 1
        /// Giờ
        case timeCollectionView:
            if timeSegmentControl.selectedSegmentIndex == 0 { /// sáng
                return numberOfItems(with: morningTimeList)
            } else {
                return numberOfItems(with: afternoonTimeList) /// chiều
            }
        default:
            return 1
        }
    }
    
    fileprivate func numberOfItems(with list: [HealthCareScheduler.Time]) -> Int {
        if list.count > 0 {
            return list.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "schedulerCell", for: indexPath) as! DateCell
        cell.title.textColor = UIColor.white
        cell.title.textAlignment = NSTextAlignment.center
        if cell.isSelected {
            cell.backgroundColor = UIColor.orange
        }
        cell.backgroundColor = UIColor.specialGreenColor()
        
        switch collectionView {
        case dateCollectionView:
            configDate(cell: cell, indexPath: indexPath)
            break
            
        case timeCollectionView:
            
            switch timeSegmentControl.selectedSegmentIndex {
            case 0: /// Sáng
                configTime(cell: cell, indexPath: indexPath, timeList: self.morningTimeList)
                break
                
            case 1: /// Chiều
                configTime(cell: cell, indexPath: indexPath, timeList: self.afternoonTimeList)
                break
                
            default:
                break
            }
            
            break
            
        default:
            break
        }
        return cell
    }
    
    fileprivate func configDate(cell: DateCell, indexPath: IndexPath) {
        if schedulerList.count > 0 {
            cell.title.attributedText = NSAttributedString(string: schedulerList[indexPath.item].DateView, attributes: textAttribute)
        } else {
            cell.title.text = "..."
            cell.backgroundColor = UIColor.lightGray
        }
    }
    
    fileprivate func configTime(cell: DateCell, indexPath: IndexPath, timeList: [HealthCareScheduler.Time]) {
        if timeList.count > 0 {
            let time = timeList[indexPath.item]
            if !time.active {
                cell.backgroundColor = UIColor.lightGray
                cell.isUserInteractionEnabled = false
            } else {
                cell.isUserInteractionEnabled = true
            }
            cell.title.attributedText = NSAttributedString(string: timeList[indexPath.item].from, attributes: textAttribute)
        } else {
            cell.title.text = "..."
            cell.backgroundColor = UIColor.lightGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        switch collectionView {
            
        case dateCollectionView:
            if schedulerList.count > 0 {
                selectedDateHandler(cell: cell, indexPath: indexPath, dateList: schedulerList)
            }
            break
            
        case timeCollectionView:
            if timeSegmentControl.selectedSegmentIndex == 0 {
                /// Sáng
                selectTimeHandler(cell: cell, indexPath: indexPath, timeList: morningTimeList)
            } else {
                /// Chiều
                selectTimeHandler(cell: cell, indexPath: indexPath, timeList: afternoonTimeList)
            }
            break
            
        default:
            break
        }
    }
    
    fileprivate func selectedDateHandler(cell: DateCell, indexPath: IndexPath, dateList: [HealthCareScheduler]) {
        cell.backgroundColor = .orange
        self.morningTimeList.removeAll()
        self.afternoonTimeList.removeAll()
        self.morningTimeList = dateList[indexPath.item].morning
        self.afternoonTimeList = dateList[indexPath.item].afternoon
        didSelectScheduler = dateList[indexPath.item]       /// Ngày đã chọn
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    fileprivate func selectTimeHandler(cell: DateCell, indexPath: IndexPath, timeList: [HealthCareScheduler.Time]) {
        if timeList.count > 0 {
            cell.backgroundColor = UIColor.orange
            didSelectTime = timeList[indexPath.item]  /// Giờ đã chọn
        }
    }
    
    /// Deselect là bỏ chọn chứ ko phải nhấp lại
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.specialGreenColor()
    }
}
















