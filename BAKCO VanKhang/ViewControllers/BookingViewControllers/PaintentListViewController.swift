//
//  PaintentListViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/17/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import AlamofireSwiftyJSON
import Alamofire
import MBProgressHUD
import UIKit
import SwiftyJSON

public enum DirectViewController {
    case booking
    case teleHealth
}

/// Mark: Properties
class PaintentListViewController: BaseViewController {

    var paintentList: [User?] = [MyUser.current] {
        didSet {
            self.paintentTableview.reloadData()
        }
    }

    var direct: DirectViewController!

    @IBOutlet weak var paintentTableview: UITableView!
}

/// Mark: Methods
extension PaintentListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bệnh nhân"
        showCancelButton()
        self.config(tv: paintentTableview)
        setupAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPaintentList()
    }
    
    func setupAddButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func add() {
        let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "AddPaintentViewController") as! AddPaintentViewController
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func config(tv: UITableView) {
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        tv.separatorColor = UIColor.specialGreenColor()
        tv.separatorInset.left = 0.0
        tv.rowHeight = 70.0
        tv.register(UINib(nibName: "PaintentCell", bundle: nil), forCellReuseIdentifier: "PaintentCell")
    }
    
    func getPaintentList() {
        let api = URL(string: API.getPaintents + "?CustomerId=\(MyUser.id)")!
        let completionHandler = { (response: DataResponse<JSON>) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.parseToSystemPaintentList(with: response)
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(api, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON(completionHandler: completionHandler)

    }
    
    func parseToSystemPaintentList(with response: DataResponse<JSON>) {
        print(response)
        paintentList = [MyUser.current!]
        if response.result.isSuccess {
            guard let dataArray = response.value?.array else { return }
            dataArray.forEach({ (Json) in
                guard let data = Json.dictionaryObject else {return}
                let paintent = User(data: data)
                paintentList.append(paintent)
            })
        } else {
            self.showAlert(title: "Lỗi", mess: response.error.debugDescription, style: .alert)
        }
    }
}

extension PaintentListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paintentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaintentCell", for: indexPath) as! PaintentCell
        cell.nameLabel.text = paintentList[indexPath.row]?.fullName
        cell.phoneNumLabel.text = paintentList[indexPath.row]?.phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedUser = paintentList[indexPath.row]  else { return }
        let vc = MyStoryboard.bookingStoryboard.instantiateViewController(withIdentifier: "PaintentInfoViewController") as! PaintentInfoViewController
        vc.userId = selectedUser.id
        vc.direct = self.direct
        navigationController?.pushViewController(vc, animated: true)
    }
}




















