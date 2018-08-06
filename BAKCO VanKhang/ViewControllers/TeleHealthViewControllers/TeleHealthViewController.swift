//
//  TeleHealthViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/3/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import DropDown
import AlamofireSwiftyJSON
import Alamofire
import SwiftyJSON
import MBProgressHUD

public struct TeleHealthInfo {
    static var patient = Constant.emtyUser
    static var hospital = Hospital()
    static var doctor = Doctor()
    static var specialty = Specialty()
    static var scheduler = HealthCareScheduler()
    static var time = HealthCareScheduler.Time()
    static var match = MatchModel()
    static var appointment = Appointment()
    
    static func release() {
        self.hospital = Hospital()
        self.doctor = Doctor()
        self.scheduler = HealthCareScheduler()
        self.time = HealthCareScheduler.Time()
        self.appointment = Appointment()
    }
}

class TeleHealthViewController: BaseViewController {
    
    var paintentDropDown = DropDown()
    
    @IBOutlet weak var paintentNameTextfield: UITextField!
    @IBOutlet weak var hospitalTextfield: UITextField!
    @IBOutlet weak var doctorUnitTextfield: UITextField!
    @IBOutlet weak var schedulerTextfield: UITextField!
    
    /** Chọn bệnh nhân */
    @IBAction func selectPatient(_ sender: Any) {
        let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "PatientListViewController") as! PatientListViewController
        vc.direct = .teleHealth
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    /** Chọn bệnh viện */
    @IBAction func selecthospital(_ sender: Any) {
        let hospitalVc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "HospitalViewController") as! HospitalViewController
        hospitalVc.delegate = self
        let nav = BaseNavigationController(rootViewController: hospitalVc)

        let alert = UIAlertController(title: "Tuỳ chọn", message: "", preferredStyle: .actionSheet)
        let singleMemberAction  = UIAlertAction(title: "Cán bộ tư vấn", style: .default) { (_) in
            hospitalVc.url = URL(string: API.TeleHealth.getHospitals + "?unitTypeId=2")! /// "2" là đơn vị 1 thành viên
            self.present(nav, animated: true)
        }
        let multiMemberAction = UIAlertAction(title: "Đơn vị tư vấn", style: .default) { (_) in
            hospitalVc.url = URL(string: API.TeleHealth.getHospitals + "?unitTypeId=1")! /// "1" là đơn vị nhiều thành viên
            self.present(nav, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alert.addAction(singleMemberAction)
        alert.addAction(multiMemberAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    /** Chọn bác sĩ */
    @IBAction func selectdoctor(_ sender: Any) {
        if (hospitalTextfield.text == nil) || TeleHealthInfo.hospital.Id == -1 {
            self.showAlert(title: "Lỗi", mess: "Bạn chưa chọn đơn vị tư vấn", style: .alert)
        } else {
            let doctorVc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "ExpDoctorViewController") as! ExpDoctorViewController
            let nav = BaseNavigationController(rootViewController: doctorVc)
            doctorVc.delegate = self
            doctorVc.hospitalId = TeleHealthInfo.hospital.Id
            navigationController?.present(nav, animated: true)
        }
    }
    
    /** Chọn ngày giờ khám */
    @IBAction func selectScheduler(_ sender: Any) {
        if doctorUnitTextfield.text == nil || TeleHealthInfo.doctor.id == 0 {
            self.showAlert(title: "Lỗi", mess: "Bạn chưa chọn chuyên gia tư vấn", style: .alert)
        } else {
            let calendarVc = MyStoryboard.teleHealthStoryboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
            let nav = BaseNavigationController(rootViewController: calendarVc)
            calendarVc.doctorId = TeleHealthInfo.doctor.id
            present(nav, animated: true)
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TeleHealthInfo.release()
        setupUI()
        getPaintent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paintentNameTextfield.text = TeleHealthInfo.patient.fullName
    }
    
    fileprivate func setupUI() {
        title = "Tư vấn sức khoẻ từ xa"
        showBackButton()
    }
    
    /** Lấy ds bệnh nhân. */
    fileprivate func getPaintent() {
        let api = URL(string: API.getPatients + "?CustomerId=\(MyUser.id)")!
        let completionHandler = { (response: DataResponse<JSON>) -> Void in
            self.hideHUD()
            self.parseToSystemPaintentList(with: response)
        }
        self.showHUD()
        Alamofire.request(api, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON(completionHandler: completionHandler)
    }
    
    fileprivate func parseToSystemPaintentList(with response: DataResponse<JSON>) {
        print(response)
        Constant.paintentNameList.removeAll()
        Constant.paintentList = [MyUser.current!]
        if response.result.isSuccess {
            guard let dataArray = response.value?.array else { return }
            dataArray.forEach({ (Json) in
                guard let data = Json.dictionaryObject else {return}
                let paintent = User(data: data)
                Constant.paintentList.append(paintent)
            })
            for paintent in Constant.paintentList {
                guard let name = paintent?.fullName else {return}
                Constant.paintentNameList.append(name)
            }
        } else {
            self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
        }
    }
}

extension TeleHealthViewController: HospitalViewControllerDelegate {
    func didChooseHospital(hospital: Hospital) {
        self.hospitalTextfield.text = hospital.Name
        TeleHealthInfo.hospital = hospital
    }
}

extension TeleHealthViewController: ExpDoctorViewControllerDelegate {
    func didSelectDoctor(doctor: Doctor) {
        self.doctorUnitTextfield.text = doctor.fullName
        TeleHealthInfo.doctor = doctor
    }
}


























