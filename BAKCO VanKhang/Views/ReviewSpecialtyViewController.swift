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

class ReviewSpecialtyViewController: UIViewController {

    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblSpecialty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    var hospitalName:String!
    var hospitalAddress:String!
    var hospitalService:String!
    var specialty:String!
    var price:Int!
    var isMember:Bool!
    
    @IBOutlet weak var swtIsPatient: UISwitch!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtHealthInsurance: UITextField!
    
    var currentUser = CustomerModel()
    var currentMatch = MatchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblHospitalName.text = hospitalName
        lblAddress.text = hospitalAddress
        lblService.text = hospitalService
        lblSpecialty.text = specialty
        lblPrice.text = "\(price!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actIsPatient(_ sender: Any) {
        if swtIsPatient.isOn{
            clearTextBox()
        }
        else{
            fillTextBox()
        }
    }
    @IBAction func actContinue(_ sender: Any) {
        getMatch()
        let reviewAppointmentScreen = storyboard?.instantiateViewController(withIdentifier: "ReviewAppointmentViewController") as! ReviewAppointmentViewController
        reviewAppointmentScreen.hospitalName = hospitalName
        reviewAppointmentScreen.hospitalAddress = hospitalAddress
        reviewAppointmentScreen.specialty = specialty
        reviewAppointmentScreen.date = ""
        reviewAppointmentScreen.time = ""
        reviewAppointmentScreen.roomNumber = ""
        
        navigationController?.pushViewController(reviewAppointmentScreen, animated: true)
    }
    func getUserInfo() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(URL(string:"http://api.vkhs.vn/api/BkCustomer/GetById/15")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            DispatchQueue.main.async {
                self.currentUser.initWithData(data: response.value?.dictionaryObject!)
                self.fillTextBox()
            }            
        }
    }
    func getMatch() {
        var urlApiGetMatch:String!
        var parameters:Parameters
        
        if(isMember == true)
        {
            urlApiGetMatch = "http://api.vkhs.vn/api/BkMedicalExaminationNote/CreateForMember"
            parameters = ["CustomerId": 15,"HospitalId":1,"HealthCareId":4,"IsMorning":true]
        }
        else{
            urlApiGetMatch = "http://api.vkhs.vn/api/BkMedicalExaminationNote/CreateForNonmember"
            let member = [
                "FullName": txtFullName.text!,
                "Phone": txtPhone.text!,
                "Email": txtEmail.text!,
                "HealthInsurance":txtHealthInsurance.text!,
                "Password":"123"
                ]
            parameters = ["HospitalId":1,"HealthCareId":4,"IsMorning":true,"Member":member]
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(URL(string:urlApiGetMatch)!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            DispatchQueue.main.async {
                self.currentMatch.initWithData(data: response.value?.dictionaryObject!)
                self.getAppointment(_healthCareSchedulerId: self.currentMatch.HealthCareSchedulerId, _customerId: self.currentMatch.CustomerId)
            }
        }
    }
    func getAppointment(_healthCareSchedulerId:Int,_customerId:Int) {
        let urlApiGetAppointment = "http://api.vkhs.vn/api/BkMedicalExaminationNote/Create"
        let parameters: Parameters = ["HealthCareSchedulerId": _healthCareSchedulerId,"CustomerId":_customerId,"Type":0]
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(URL(string:urlApiGetAppointment)!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            /*guard let value = response.result.value as? [String: Any],
                let rows = value["Room"] as? [String: Any] else {
                    print("Malformed data received from fetchAllRooms service")
                    return
                }
            print(rows)*/
        }
    }
    func clearTextBox() {
        txtFullName.text = ""
        txtPhone.text = ""
        txtEmail.text = ""
        txtHealthInsurance.text = ""
        isMember = false
    }
    func fillTextBox() {
        txtFullName.text = self.currentUser.FullName
        txtPhone.text = self.currentUser.Phone
        txtEmail.text = self.currentUser.Email
        txtHealthInsurance.text = self.currentUser.HealthInsurance
        isMember = true
    }
    
    
    
    func textFieldDidChange(textField: UITextField) {
        if txtFullName.text == "" || txtPhone.text == "" || txtEmail.text == "" || txtHealthInsurance.text == "" {
            //Disable button
            print("dis")
        } else {
            print("ena")
        }
    }
}
