//
//  ChooseInformViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/6/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import DynamicColor
import Alamofire
import MBProgressHUD
import IQDropDownTextField


let Normal = "Thông thường"
let Service = "Dịch vụ"
let Expert = "Chuyên gia"
let exDict = [Normal: "0", Service: "1"]


class ChooseInformViewController: BaseViewController {
    
    // Property:
    
    var selectedHospital: Hospital?
    var selectedSpecialty: Specialty?
    var selectedUser: User?
    var selectedHealthCareScheduler: HealthCareScheduler?
    var insurance = false
    var selectedType: String?
    var healthcareSchedule = [HealthCareScheduler]() {
        didSet {
            dateCollectionView.reloadData()
        }
    }
    var match = MatchModel()

    @IBOutlet var usernameDropDownTextField: IQDropDownTextField!
    @IBOutlet var dateCollectionView: UICollectionView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var specialtyTextField: UITextField!
    @IBOutlet var exTypeDropDownTextField: IQDropDownTextField!
    @IBOutlet var hospitalNameTextField: UITextField!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var specialtyButton: UIButton!
    
    let attribute: [NSAttributedStringKey : Any] = [.font: UIFont.boldSystemFont(ofSize: 10.0),
                                                    .foregroundColor: UIColor.white,
                                                    .paragraphStyle: NSTextAlignment.center]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton()
        setupDropDownTextField()
        setupUserInterface()
    }
    
    func setupUserInterface() {
        self.yesButton.backgroundColor = UIColor.lightGray
        self.yesButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.noButton.backgroundColor = UIColor.lightGray
        self.noButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dateCollectionView.delegate = self
        self.dateCollectionView.dataSource = self
        self.dateCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "cellId")
        self.dateCollectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.navigationItem.title = "Đăng kí khám bệnh"
        self.confirmButton.layer.cornerRadius = 5.0
        self.confirmButton.clipsToBounds = true
    }
    
    func setupDropDownTextField() {
        setupExaminationTypeTextfield()
        setupUsernameTextfield()
    }
    
    func setupExaminationTypeTextfield() {
        self.exTypeDropDownTextField.isOptionalDropDown = false
        var array = [String]()
        for key in exDict.keys {
            array.append(key)
        }
        self.exTypeDropDownTextField.itemList = array
        self.exTypeDropDownTextField.showDismissToolbar = true
        exTypeDropDownTextField.delegate = self
        exTypeDropDownTextField.dataSource = self
        selectedType = exTypeDropDownTextField.selectedItem
    }
    
    func setupUsernameTextfield() {
        let usernames: [String] = [MyUser.name]
        self.usernameDropDownTextField.itemList = usernames
        self.usernameDropDownTextField.showDismissToolbar = true
        self.usernameDropDownTextField.delegate = self
        self.usernameDropDownTextField.dataSource = self
        self.usernameDropDownTextField.isOptionalDropDown = false
    }
    
    func validateTextField(textField: UITextField) -> Bool {
        if textField.text == "" || textField.text == nil || self.healthcareSchedule.count == 0 {
            return false
        }
        return true
    }
    
    func gethealthCareScheduler(hospitalId: Int, healthcareId: Int, type: String) {
        let parameters: Parameters = ["HospitalId": hospitalId,
                                      "HealthCareId": healthcareId,
                                      "Type": type]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string: API.getHealthCareScheduler)!, method: .get, parameters: parameters).responseSwiftyJSON { (response) in
                MBProgressHUD.hide(for: self.view, animated: true)
                print(response)

            if let error = response.error {
                self.showAlert(title: "Lỗi", mess: error.localizedDescription, style: .alert)
            } else {
                self.healthcareSchedule.removeAll()
                response.value?.forEach({ (json) in
                    let newHealthCareScheduler = HealthCareScheduler(data: json.1.dictionaryObject!)
                    self.healthcareSchedule.append(newHealthCareScheduler)
                })
            }
        }
    }
    
    func getMatch(hospital: Hospital, paintentID: Int, specialty: Specialty, date: HealthCareScheduler, typeId: String) {
        let date1 : String = date.Date
        let index = date1.index(date1.startIndex, offsetBy: 10)
        let dateString = date1[..<index] /// substring
        
        let URLString = API.createExaminationNote
        let parameters: Parameters = ["CustomerId": paintentID,
                                      "HospitalId": hospital.Id,
                                      "HealthCareId": specialty.Id,
                                      "IsMorning": true,
                                      "Date": dateString,
                                      "Type": typeId]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        requestAPIwith(urlString: URLString, method: .post, params: parameters) { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("Match: \(response)")
            self.match.initWithData(data: response)
            
            //
            let firstAppointment = MyStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ReviewSpecialtyViewController") as! FirstAppointmentViewController
            firstAppointment.currentHospital = hospital
            firstAppointment.day = date
            firstAppointment.specialty = specialty
            firstAppointment.type = self.selectedType
            firstAppointment.currentMatch = self.match
            firstAppointment.didHaveInsurance = self.insurance
            self.navigationController?.pushViewController(firstAppointment, animated: true)
        }
    }
}

// MARK: IBACTIONS

extension ChooseInformViewController {

    @IBAction func chooseHospital(_ sender: Any) {
        let next = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "HospitalViewController") as! HospitalViewController
        next.delegate = self
        let nav = BaseNavigationController(rootViewController: next)
        self.present(nav, animated: true)
    }
    
    @IBAction func showSpecialtyList(_ sender: Any) {
        let next = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "ChooseSpecialtyViewController") as! ChooseSpecialtyViewController
        next.hospitalId = selectedHospital?.Id
        next.type = exDict[exTypeDropDownTextField.selectedItem!]
        next.naviTitle = exTypeDropDownTextField.selectedItem!
        next.delegate = self
        let nav = BaseNavigationController(rootViewController: next)
        self.present(nav, animated: true)
    }
    
    @IBAction func yes(_ sender: Any) {
        
        if !insurance {
            /// show pop up
            let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "HIUPdateViewController") as! HIUPdateViewController
            self.tabBarController?.view.addSubview(vc.view)
            self.tabBarController?.addChildViewController(vc)

        }
        
        insurance = true
        yesButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        noButton.setImage(UIImage(named: "no-image"), for: .normal)
    }
    
    @IBAction func no(_ sender: Any) {
        insurance = false
        noButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        yesButton.setImage(UIImage(named: "no-image"), for: .normal)
    }
    
    @IBAction func confirm(_ sender: Any) {
        if let hospital = self.selectedHospital,
            let date = self.selectedHealthCareScheduler,
            let specialty = self.selectedSpecialty,
            let typeId = exDict[self.selectedType!]
        {
            getMatch(hospital: hospital, paintentID: MyUser.id, specialty: specialty, date: date, typeId: typeId)
        } else {
            showAlert(title: "Lỗi", mess: "Chưa đủ thông tin đề xuất ra phiếu hẹn", style: .alert)
        }
    }
}

// MARK: DELEGATES

extension ChooseInformViewController: HopitalViewControllerDelegate, ChooseSpecialtyViewControllerDelegate, InformationViewControllerDelegate {
    func didSelectUser(with user: User) {
        self.selectedUser = user
    }
    
    func didChooseSpecialty(specialty: Specialty) {
        self.specialtyTextField.text = specialty.Name
        self.selectedSpecialty = specialty
        ///
        if let hospitalId = selectedHospital?.Id,
            let heathCareId = selectedSpecialty?.Id,
            let type = exTypeDropDownTextField.selectedItem {
            gethealthCareScheduler(hospitalId: hospitalId, healthcareId: heathCareId, type: exDict[type]!)
        } else {
            showAlert(title: "Lỗi", mess: "Bạn chưa chọn bệnh viện", style: .alert)
        }
    }
    
    func didChooseHospital(hospital: Hospital) {
        self.hospitalNameTextField.text = hospital.Name
        self.selectedHospital = hospital
        
        /// delete specialty
        self.specialtyTextField.text = ""
        self.selectedSpecialty = nil
    }
}

// MARK: COLLECTION VIEW DELEGATES

extension ChooseInformViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if healthcareSchedule.count > 0 {
            return healthcareSchedule.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! DateCell
        cell.title.textColor = UIColor.white
        cell.title.font = UIFont.boldSystemFont(ofSize: 10.0)
        cell.title.textAlignment = NSTextAlignment.center

        if healthcareSchedule.count > 0 {
            cell.title.text = healthcareSchedule[indexPath.item].DateView
        } else {
            cell.title.text = "..."
            cell.backgroundColor = UIColor.specialGreenColor()
        }
        
        if cell.isSelected {
            cell.backgroundColor = UIColor.orange
        } else {
            cell.backgroundColor = UIColor.specialGreenColor()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        if healthcareSchedule.count > 0 {
            cell.backgroundColor = .orange
            selectedHealthCareScheduler = healthcareSchedule[indexPath.item]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { /// deselect là bỏ chọn chứ ko phải nhấp lại
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.specialGreenColor()
    }
}

// MARK : IQDROPDOWN DELEGATE DATASOURCES

extension ChooseInformViewController: IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        if textField == self.exTypeDropDownTextField {
            self.selectedType = textField.selectedItem
        }
        
        if textField == self.usernameDropDownTextField {
//            self.selectedUser = userDict[textField.selectedItem!]
//            print("selected User: \(self.selectedUser?.fullName! ?? "No user")")
        }
    }

}













