//
//  WardViewController.swift
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

protocol WardViewControllerDelegate: class {
    func didSelectedWard(ward: Ward)
}

class WardViewController: BaseViewController {
    
    @IBOutlet var wardTableview: UITableView!
    
    var wards = [Ward]() {
        didSet {
            wardTableview.reloadData()
        }
    }
    weak var delegate: WardViewControllerDelegate!
    
    var selectedDistrict: District?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Phường xã"
        showCancelButton()
        setupTableview(tv: wardTableview)
        guard let dist = selectedDistrict else { return }
        getWard(by: dist.value)
    }
    
    func setupTableview(tv: UITableView) {
        tv.tableFooterView = UIView()
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 50.0
        tv.separatorInset.left = 0
    }
}

extension WardViewController {
    
    func getWard(by distCode: String) {
        let getDistUrl = URL(string: "\(API.Location.getWards)?DistrictCode=\(distCode)")!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(getDistUrl, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = response.value?.array {
                data.forEach({ (wardData) in
                    let ward = Ward(data: wardData.dictionaryObject!)
                    self.wards.append(ward)
                })
            } else {
                self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
            }
        }
    }
}

extension WardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = wards[indexPath.row].name
        cell?.textLabel?.textColor = UIColor.darkGray
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let selectedWard = wards[indexPath.row]
        self.delegate.didSelectedWard(ward: selectedWard)
        
        navigationController?.dismiss(animated: true)
    }
    
}















