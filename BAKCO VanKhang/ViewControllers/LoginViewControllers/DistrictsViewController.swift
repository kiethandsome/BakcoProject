//
//  DistrictsViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/3/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import AlamofireSwiftyJSON
import Alamofire

var _selectedDistrict: District!

class DistrictsViewController: BaseViewController {
    
    @IBOutlet var distTableview: UITableView!
    
    var districts = [District]() {
        didSet {
            distTableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Quận huyện"
        showBackButton()
        setupTableview(tv: distTableview)
        getDist(by: _selectedCity.value)
    }
    
    func setupTableview(tv: UITableView) {
        tv.tableFooterView = UIView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 50.0
        tv.separatorInset.left = 0
    }
}

extension DistrictsViewController {
    
    func getDist(by cityCode: String) {
        
        let getDistUrl = URL(string: "\(_GetDistrictsApi)?CityCode=\(cityCode)")!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(getDistUrl, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = response.value?.array {
                data.forEach({ (distData) in
                    let dist = District(data: distData.dictionaryObject!)
                    self.districts.append(dist)
                })
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
        
    }
    
}

extension DistrictsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return districts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = districts[indexPath.row].name
        cell?.textLabel?.textColor = UIColor.specialGreenColor()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        _selectedDistrict = districts[indexPath.row]
        
        let vc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "WardViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



