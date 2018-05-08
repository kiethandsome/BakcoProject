//
//  BookingViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 5/3/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire
import IQDropDownTextField
import AlamofireSwiftyJSON
import DropDown
import SwiftyJSON


public let extypeDict = [Normal : "0",
                         Service : "1",
                         Expert : "2"]

public struct BookingInform {
    static var paintent = MyUser.current
    static var hospital = Hospital()
    static var didUseHI = Bool()
    static var exTypeId = String()
    static var exTypeName = String()
    static var doctor = Doctor()
    static var specialty = Specialty()
    static var scheduler = HealthCareScheduler()
    static var time = HealthCareScheduler.Time()
    
    static func release() {
        self.hospital = Hospital()
        self.didUseHI = false
        self.exTypeId = String()
        self.exTypeName = ""
        self.doctor = Doctor()
        self.scheduler = HealthCareScheduler()
        self.time = HealthCareScheduler.Time()
    }
}

class BookingViewController: BaseViewController {
    
    var didUseInsurance: (Bool) -> Void = { result in
        BookingInform.didUseHI = result
    }
    
    var paintentDropdown = DropDown()
    var exTypeDropdown = DropDown()
    var hiDropdown = DropDown()
    
    @IBOutlet var paintentTextfield: UITextField!
    @IBOutlet var hospitalTextfield: UITextField!
    @IBOutlet var hIIdTextfield: UITextField!
    @IBOutlet var exTypeTextfield: UITextField!
    @IBOutlet var expDocOrSpecialtyTextfield: UITextField!
    @IBOutlet var dateAndTimeTextfield: UITextField!
    @IBOutlet var ExpDocOrSpecialtyLabel: UILabel!
    
    @IBAction func showHospitals(_ sender: Any) {
        let hospitalVc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "HospitalViewController") as! HospitalViewController
        hospitalVc.delegate = self
        let nav = BaseNavigationController(rootViewController: hospitalVc)
        present(nav, animated: true)
    }
    
    @IBAction func showExpertDoctor(_ sender: Any) {
        guard let hosName = hospitalTextfield.text,
            let exType = exTypeTextfield.text else { return }
        if hosName == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa chọn bệnh viện", style: .alert)
        } else if exType == "" {
            showAlert(title: "Lỗi", mess: "Bạn chưa chọn loại hình khám", style: .alert)
        }  else {
            if exType == Expert {
                showExpDoc()
            } else {
                showSpecialty()
            }
        }
    }
    
    @IBAction func showScheduler(_ sender: Any) {
        let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "SchedulersViewController") as! SchedulersViewController
        vc.delegate = self
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @IBAction func confirm(_ sender: Any) {
        if validate() {
            if BookingInform.exTypeId == extypeDict[Expert] { /// for expert
                createExaminationNoteWithDoctor()
            } else {
                createExaminationNoteForMember() /// for normal
            }
        }
    }
    
    @IBAction func userDropdown(_ sender: Any) {
        self.paintentDropdown.show()
    }
    
    @IBAction func hiDropdown(_ sender: Any) {
        guard let paintentName = paintentTextfield.text else { return }
        if paintentName == ""  {
            showAlert(title: "Lỗi", mess: "Bạn chưa chọn bệnh nhân!", style: .alert)
        } else {
            self.hiDropdown.show()
        }
    }
    
    @IBAction func examinationTypesDropdown(_ sender: Any) {
        self.exTypeDropdown.show()
    }
    
    override func popToBack() {
        navigationController?.popViewController(animated: true)
        BookingInform.release()
    }
}


//Mark: Functions
extension BookingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Đăng kí khám bệnh"
        showBackButton()
        config(dropdown: paintentDropdown, for: paintentTextfield)
        config(dropdown: hiDropdown, for: hIIdTextfield)
        config(dropdown: exTypeDropdown, for: exTypeTextfield)
    }
    
    fileprivate func config(dropdown: DropDown, for textview: UITextField) {
        dropdown.direction = .bottom
        dropdown.anchorView = textview
        dropdown.animationduration = 0.3
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)

        switch dropdown {
        case paintentDropdown:
            let paintentList = [MyUser.current]
            var paintentNameList: [String] = []
            paintentList.forEach { (item) in
                guard let user = item else { return }
                paintentNameList.append(user.fullName)
            }
            dropdown.dataSource = paintentNameList
            dropdown.selectionAction = { (index: Int, item: String) in
                print(item)
                self.paintentTextfield.text = item
            }
            break
        
        case hiDropdown:
            dropdown.dataSource = ["Có", "Không"]
            dropdown.selectionAction =  { (index: Int, item: String) in
                print(item)
                self.hIIdTextfield.text = item
                if item == "Có" {
                    /// show pop up
                    let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "HIUPdateViewController") as! HIUPdateViewController
                    self.tabBarController?.view.addSubview(vc.view)
                    self.tabBarController?.addChildViewController(vc)
                    BookingInform.didUseHI = true
                } else {
                    BookingInform.didUseHI = false
                }
            }
            break
            
        case exTypeDropdown:
            dropdown.dataSource = exTypeArray
            dropdown.selectionAction =  { (index: Int, item: String) in
                print(item)
                self.exTypeTextfield.text = item
                self.expDocOrSpecialtyTextfield.text = ""
                self.dateAndTimeTextfield.text = ""
                if item == Expert {
                    /// Cho luồng KHÁM CHUYÊN GIA
                    self.ExpDocOrSpecialtyLabel.text = "5. Chuyên gia"
                    self.expDocOrSpecialtyTextfield.placeholder = "Chọn chuyên gia"
                } else {
                    /// Luồng khám thông thường và dịch vụ
                    self.ExpDocOrSpecialtyLabel.text = "5. Chuyên khoa"
                    self.expDocOrSpecialtyTextfield.placeholder = "Chọn chuyên khoa"
                }
                BookingInform.exTypeName = item  /// Gán
                BookingInform.exTypeId = extypeDict[item]! /// Gán
            }
            break
            
        default:
            break
        }
    }
    
    fileprivate func showExpDoc() {
        let doctorVc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "ExpDoctorViewController") as! ExpDoctorViewController
        let nav = BaseNavigationController(rootViewController: doctorVc)
        doctorVc.delegate = self
        navigationController?.present(nav, animated: true)
    }
    
    fileprivate func showSpecialty() {
        let next = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "ChooseSpecialtyViewController") as! ChooseSpecialtyViewController
        let nav = BaseNavigationController(rootViewController: next)
        next.delegate = self
        navigationController?.present(nav, animated: true)
    }
    
    public func subString(text: String, offsetBy: Int) -> String {
        let index = text.index(text.startIndex, offsetBy: offsetBy)
        let dateString = text[..<index] /// substring
        return String(dateString)
    }
    
    /// Create for member
    fileprivate func createExaminationNoteForMember() {
        let param : Parameters = ["CustomerId": MyUser.id,
                                  "HospitalId": BookingInform.hospital.Id,
                                  "HealthCareId": BookingInform.specialty.Id,
                                  "IsMorning": true,
                                  "Date": subString(text: BookingInform.scheduler.Date, offsetBy: 10),
                                  "Type": BookingInform.exTypeId]
        
        let completionHandler : ((DataResponse<String>) -> Void) = { reponse in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(reponse)
        }
        let uRL = URL(string: API.createExaminationNote)!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(uRL, method: .post, parameters: param, encoding: JSONEncoding.default).responseString(completionHandler: completionHandler)
    }
    
    
    /// Create with doctor
    fileprivate func createExaminationNoteWithDoctor() {
        let param : Parameters = ["CustomerId": MyUser.id,
                                  "DoctorId": BookingInform.doctor.id,
                                  "HospitalId": BookingInform.hospital.Id,
                                  "HealthCareId": BookingInform.time.timeId]
        
        let completionHandler : ((DataResponse<String>) -> Void) = { reponse in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(reponse)
        }
        let uRL = URL(string: API.createExaminationNoteByDoctor)!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(uRL, method: .post, parameters: param, encoding: JSONEncoding.default).responseString(completionHandler: completionHandler)
    }
    
    fileprivate func validate() -> Bool {
        guard let hospitalName = hospitalTextfield.text,
            let hiId = hIIdTextfield.text,
            let exType = exTypeTextfield.text,
            let expDocNameOrSpecialtyName = expDocOrSpecialtyTextfield.text,
            let paintentName = paintentTextfield.text,
            let date = dateAndTimeTextfield.text
        else { return false }
        
        if paintentName == "" {
            showAlert(title: "Lỗi", mess: "Bạn phải chọn bệnh nhân", style: .alert)
        } else if hospitalName == "" {
            showAlert(title: "Lỗi", mess: "Bạn phải chọn Cơ sở khám", style: .alert)
        } else if hiId == "" {
            showAlert(title: "Lỗi", mess: "Bạn phải chọn Bảo hiểm y tế", style: .alert)
        } else if exType == "" {
            showAlert(title: "Lỗi", mess: "Bạn phải chọn Loại hình khám", style: .alert)
        } else if expDocNameOrSpecialtyName == "" {
            if BookingInform.exTypeId == extypeDict[Expert] {
                showAlert(title: "Lỗi", mess: "Bạn phải chọn Chuyên gia", style: .alert)
            } else {
                showAlert(title: "Lỗi", mess: "Bạn phải chọn Chuyên khoa", style: .alert)
            }
        } else if date == "" {
            showAlert(title: "Lỗi", mess: "Bạn phải chọn Ngày giờ", style: .alert)
        } else {
            return true
        }
        return false
    }
}


extension BookingViewController: HopitalViewControllerDelegate {
    func didChooseHospital(hospital: Hospital) {
        BookingInform.hospital = hospital  /// Gán
        self.hospitalTextfield.text = hospital.Name
        self.expDocOrSpecialtyTextfield.text = ""
        self.exTypeTextfield.text = ""
        self.dateAndTimeTextfield.text = ""
    }
}

extension BookingViewController: ChooseSpecialtyViewControllerDelegate {
    func didChooseSpecialty(specialty: Specialty) {
        BookingInform.specialty = specialty /// Gán
        self.expDocOrSpecialtyTextfield.text = specialty.Name
    }
}

extension BookingViewController: ExpDoctorViewControllerDelegate {
    func didSelectDoctor(doctor: Doctor) {
        BookingInform.doctor = doctor  /// Gán
        self.expDocOrSpecialtyTextfield.text = doctor.fullName
    }
}

extension BookingViewController: SchedulersViewControllerDelegate {
    func didSelectTime(time: HealthCareScheduler.Time ) {
        BookingInform.time = time  /// Gán
//        dateAndTimeTextfield.text = time.from
    }
    
    func didSelectScheduler(scheduler: HealthCareScheduler) {
        BookingInform.scheduler = scheduler /// Gán
        dateAndTimeTextfield.text = scheduler.DateView
    }
}
















