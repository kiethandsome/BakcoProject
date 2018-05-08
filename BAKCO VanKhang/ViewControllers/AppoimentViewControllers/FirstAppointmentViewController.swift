//
//  ReviewSpecialtyViewController.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/14/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import AlamofireSwiftyJSON
import Alamofire
import MBProgressHUD

var _selectedHospital: Hospital?
var _selectedSpecialty: Specialty?
var _selectedScheduler: HealthCareScheduler?
var _selectedInsurance = ""
var _selectedExamType = ""
var _selectedDetail: DetailModel?
var _selectedRoom: Room?
var _selectedMatch: MatchModel?

class FirstAppointmentViewController: BaseViewController {

    @IBOutlet var srollView: UIScrollView!
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var insuranceIDLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var exTypeLabel: UILabel!
    @IBOutlet var InsuranceLabel: UILabel!
    @IBOutlet var exDayLabel: UILabel!
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var roomNumberLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    
    var specialty: Specialty!{
        didSet {
            _selectedSpecialty = specialty
        }
    }
    var day: HealthCareScheduler! {
        didSet {
            _selectedScheduler = day
        }
    }
    var currentHospital: Hospital! {
        didSet {
            _selectedHospital = currentHospital
        }
    }
    var type: String! {
        didSet {
            _selectedExamType = type
        }
    }
    var didHaveInsurance: Bool!{
        didSet {
            _selectedInsurance = didHaveInsurance ? "Sử dụng BHYT: Có" : "Sử dụng BHYT: Không"
        }
    }
    var detail : DetailModel! {
        didSet {
            _selectedDetail = detail
        }
    }

    var room: Room! {
        didSet {
            _selectedRoom = room
        }
    }
    
    var currentMatch = MatchModel() {
        didSet {
            _selectedMatch = currentMatch
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Xác nhận"
        showBackButton()
        setupContent()

        if let healthCareId = currentMatch.HealthCareSchedulerId, let userId = currentMatch.CustomerId {
            getAppointMent(healthCareSchedulerId: healthCareId, customerId: userId)
        } else {
            showAlert(title: "Lỗi", mess: "Vui lòng kiểm tra lại", style: .alert)
        }
        
    }
    
    fileprivate func setupContent() {
        lblHospitalName.text = BookingInform.hospital.Name
        lblAddress.text = BookingInform.hospital.Address
        exDayLabel.text = BookingInform.scheduler.DateView
        InsuranceLabel.text = BookingInform.didUseHI ? "Sử dụng BHYT: Có" : "Sử dụng BHYT: Không"
        exTypeLabel.text = BookingInform.exTypeName
        ///
        userNameLabel.text = "Bệnh nhân: \(MyUser.name)"
        insuranceIDLabel.text = "BHYT: \(MyUser.insuranceId)"
        birthdayLabel.text = "Ngày sinh: \(MyUser.birthday)"
        phoneNumberLabel.text = "ĐT: \(MyUser.phone)"
    }
    
    @IBAction func confirm(_ sender: Any) {
        let next = MyStoryboard.paymentStoryboard.instantiateViewController(withIdentifier: "PayViewController")
        navigationController?.pushViewController(next, animated: true)
    }
    
    
    func getAppointMent(healthCareSchedulerId: Int, customerId: Int) {
        let urlString = API.getFirstAppointment
        let parameters: Parameters = [ "HasHealthInsurance" : self.didHaveInsurance,
                                       "HealthCareSchedulerId": healthCareSchedulerId,
                                       "CustomerId": customerId,
                                       "Type": exDict[type] as Any]
        
        requestAPIwith(urlString: urlString, method: .post, params: parameters) { (response) in
            print("Appointment: \(response)")
            
            let keys = response.keys
            keys.forEach({ (key) in
                switch key  {
                case "Room":
                    print("Room: \(response[key]!)")
                    self.room = Room(data: response[key] as! [String: Any])
                    guard let roomName = self.room.Name
                        else { return }
                    self.roomNumberLabel.text = roomName
                    break
                
                case "Detail":
                    print("Detail: \(response[key]!)")

                    self.detail = DetailModel(data: response[key] as! [String : Any])
                    self.timeLabel.text = self.detail.from
                    break
                    
                default:
                    break
                }
            })
        }
    }
}

//    func getAppointment(_healthCareSchedulerId: Int, _customerId: Int) {
//
//        let urlApiGetAppointment = "http://api.vkhs.vn/api/BkMedicalExaminationNote/Create"
//
//        let parameters: Parameters = ["HealthCareSchedulerId": _healthCareSchedulerId,
//                                      "CustomerId": _customerId,
//                                      "PatientId": _customerId,
//                                      "Type": 0]
//
//        Alamofire.request(URL(string: urlApiGetAppointment)!,
//                          method: .post,
//                          parameters: parameters,
//                          encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
//
//
//                            //Parse to models
//            print("/n/nResponse ở đay nhé! \n\(response.value as Any)")
//            response.value?.forEach({ (string, json) in
//                switch string {
//                case "Room":
//                    self.room.initWithData(data: json.dictionaryObject!)
//                    break
//                case "Hospital":
//                    self.hospital.initWithData(data: json.dictionaryObject!)
//                    //   print("\nHospital address:\(hospital.Address!)")
//                    break
//                case "Detail":
//                    self.detail.initWithData(data: json.dictionaryObject!)
//                    //print("\nTime:\(detail.Time!)")
//                    break
//                case "Customer":
//                    self.customer.initWithData(data: json.dictionaryObject!)
//                    //print("\nCustomer fullname:\(customer.FullName!)")
//                    break
//                case "Doctor":
//                    self.doctor.initWithData(data: json.dictionaryObject!)
//                    //print("\nDoctor fullname:\(doctor.FullName!)")
//                    break
//                default: break
//
//                }
//
//            })
//            DispatchQueue.main.async {
//
//            }
//        }
//    }
//



//    func getUserInfo() {
//        MBProgressHUD.showAdded(to: view, animated: true)
//        Alamofire.request(URL(string: "http://api.vkhs.vn/api/BkCustomer/GetById/15")!, method: .get).responseSwiftyJSON { (response) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            print(response.value as Any)
//            DispatchQueue.main.async {
//                self.currentUser.initWithData(data: response.value?.dictionaryObject!)
//            }
//        }
//    }



//
//urlApiGetMatch = "http://api.vkhs.vn/api/BkMedicalExaminationNote/CreateForNonmember"
//let member = [
//    "FullName": txtFullName.text!,
//    "Phone": txtPhone.text!,
//    "Email": txtEmail.text!,
//    "HealthInsurance": txtHealthInsurance.text!,
//    "Password": "123"
//]
//parameters = ["HospitalId": 1, "HealthCareId": 4, "IsMorning": true, "Member": member]



//            response.value?.array?.forEach({ (json) in
//                var model = AppointmentModel()
//                model.parse(data: json.dictionaryObject)
//                print("\nhospital name\(String(describing: model.Hospital?.Name!))")
//
//            })
























