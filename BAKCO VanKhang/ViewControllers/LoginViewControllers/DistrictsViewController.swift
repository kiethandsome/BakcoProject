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

protocol DistrictsViewControllerDelegate: class {
    func didSelectDistrict(dist: District)
}

class DistrictsViewController: BaseViewController {
    
    @IBOutlet var distTableview: UITableView!
    
    var districts = [District]() {
        didSet {
            distTableview.reloadData()
        }
    }
    
    var selectedCity: City?
    
    weak var delegate: DistrictsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Quận huyện"
        showCancelButton()
        setupTableview(tv: distTableview)
        guard let city = selectedCity else { return }
        getDist(by: city.value)
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
        
        let getDistUrl = URL(string: "\(API.Location.getDistricts)?CityCode=\(cityCode)")!
        
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
        cell?.textLabel?.textColor = UIColor.darkGray
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let district = districts[indexPath.row]
        self.delegate.didSelectDistrict(dist: district)
        self.navigationController?.dismiss(animated: true)
    }
    
}















  
