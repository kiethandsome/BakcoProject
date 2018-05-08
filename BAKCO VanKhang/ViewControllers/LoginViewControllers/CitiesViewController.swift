//
//  CitiesViewController.swift
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

class CitiesViewController: BaseViewController {
    
    @IBOutlet var citiesTableview: UITableView!
    
    var cities = [City]() {
        didSet {
            citiesTableview.reloadData()
        }
    }
    
    let getCitiesUrl = URL(string: API.Location.getCities)!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Các tỉnh thành"
        showCancelButton()
        setupTableview(tv: citiesTableview)
        getCities()
    }
    
    func setupTableview(tv: UITableView) {
        tv.tableFooterView = UIView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 50.0
        tv.separatorInset.left = 0
        
    }
}

extension CitiesViewController {
    
    func getCities() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(getCitiesUrl, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = response.value?.array {
                data.forEach({ (cityData) in
                    let city = City(data: cityData.dictionaryObject!)
                    self.cities.append(city)
                })
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
        
    }
    
}

extension CitiesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = cities[indexPath.row].name
        cell?.textLabel?.textColor = UIColor.specialGreenColor()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        SelectedPlace.city = cities[indexPath.row]
        
        let vc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "DistrictsViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}














