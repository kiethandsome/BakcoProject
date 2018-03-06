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

class ReviewSpecialtyViewController: BaseViewController {

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
    
    var specialty: SpecialtyModel!
    var day: HealthCareSchedulerModel!
    var currentHospital: HospitalModel!
    var type: String!
    var didHaveInsurance: Bool!

    var room = RoomModel()
    var currentMatch = MatchModel()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Xác nhận"
        showBackButton()
        
        lblHospitalName.text = currentHospital.Name
        lblAddress.text = currentHospital.Address
        exDayLabel.text = day.DateView
        InsuranceLabel.text = didHaveInsurance ? "Sử dụng BHYT: Có" : "Sử dụng BHYT: Không"
        exTypeLabel.text = type
        
        getMatch2()
    }
    
    @IBAction func confirm(_ sender: Any) {
        let next = storyboard?.instantiateViewController(withIdentifier: "PayViewController")
        navigationController?.pushViewController(next!, animated: true)
    }

    
    func getMatch2() {
        let date1 : String = day.Date!
        let index = date1.index(date1.startIndex, offsetBy: 10)
        let dateString = date1[..<index] // substring
        
        let URLString = "http://api.vkhs.vn/api/BkMedicalExaminationNote/CreateForMember"
        let parameters: Parameters = ["CustomerId": 14,
                                      "HospitalId": currentHospital.Id!,
                                      "HealthCareId": specialty.Id!,
                                      "IsMorning": true,
                                      "Date": dateString,
                                      "Type": exDict[type]!]
        
        requestAPIwith(urlString: URLString, method: .post, params: parameters) { (response) in
            print("Match: \(response)")
            self.currentMatch.initWithData(data: response)
            self.getAppointMent(healthCareSchedulerId: self.currentMatch.HealthCareSchedulerId!,
                                customerId: self.currentMatch.CustomerId!)
        }
    }
    
    func getAppointMent(healthCareSchedulerId: Int, customerId: Int) {
        let urlString = "http://api.vkhs.vn/api/BkMedicalExaminationNote/Create"
        let parameters: Parameters = ["HealthCareSchedulerId": healthCareSchedulerId,
                                      "CustomerId": customerId,
                                      "PatientId": customerId,
                                      "Type": exDict[type] as Any]
        
        requestAPIwith(urlString: urlString, method: .post, params: parameters) { (response) in
            print("Appointment: \(response)")
            
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
























