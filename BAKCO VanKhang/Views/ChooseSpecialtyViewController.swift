//
//  ChooseSpecialtyViewController.swift
//  BAKCO VanKhang
//
//  Created by Pham An on 11/14/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireSwiftyJSON
import SDWebImage
import MBProgressHUD

class ChooseSpecialtyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var specialtyList: UITableView!
    var specialties = [SpecialtyModel]()
    
    var hospitalName:String!
    var hospitalAddress:String!
    var hospitalService:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specialtyList.dataSource = self
        specialtyList.delegate = self
        self.navigationItem.title = "Kham dich vu"
        self.navigationItem.backBarButtonItem?.title = "Trở lại"
        getSpecialties()
        showBackButton()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let specialtyCell = tableView.dequeueReusableCell(withIdentifier: "specialtyCell")
        specialtyCell?.textLabel?.text = specialties[indexPath.row].Name
        specialtyCell?.detailTextLabel?.text = String(specialties[indexPath.row].Price!)
        return specialtyCell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialties.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reviewSpecialtyScreen = storyboard?.instantiateViewController(withIdentifier: "ReviewSpecialtyViewController") as! ReviewSpecialtyViewController
        reviewSpecialtyScreen.hospitalName = hospitalName
        reviewSpecialtyScreen.hospitalAddress = hospitalAddress
        reviewSpecialtyScreen.hospitalService = hospitalService
        reviewSpecialtyScreen.specialty = specialties[indexPath.row].Name
        reviewSpecialtyScreen.price = specialties[indexPath.row].Price
        
        navigationController?.pushViewController(reviewSpecialtyScreen, animated: true)
    }
    
    func getSpecialties() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string:"http://api.vkhs.vn/api/BkHospitalHealthCare/GetByHospitalId?HospitalId=1&Type=0")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            response.result.value?.forEach({ (json) in
                var newSpecialty = SpecialtyModel()
                newSpecialty.initWithData(data: json.1.dictionaryObject!)
                self.specialties.append(newSpecialty)
            })
            self.specialtyList.reloadData()
        }
    }
}
