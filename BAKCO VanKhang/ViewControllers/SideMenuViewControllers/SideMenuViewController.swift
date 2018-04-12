//
//  SideMenu.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 11/23/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

class SideMenuViewController: BaseViewController {
    
    @objc func dismissWithAnmation() {
        hero_dismissViewController()
    }
    
    @IBOutlet var sideTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin cá nhân"
        setupBackDownButton()
        configTableView(tv: sideTableView)
    }
    
    func setupBackDownButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Cancel2"), style: .plain, target: self, action: #selector(dismissWithAnmation))
    }
    
    func configTableView(tv: UITableView) {
        tv.delegate = self
        tv.dataSource = self
        tv.register(NormalCell.self, forCellReuseIdentifier: "Cell")
        tv.register(BigCell.self, forCellReuseIdentifier: "BigCell")
        tv.separatorColor = UIColor.specialGreenColor()
        tv.separatorInset.left = 0
        tv.tableFooterView = UIView()
        tv.contentInset.bottom = 20.0
    }
}

let images = [#imageLiteral(resourceName: "new_user"), #imageLiteral(resourceName: "calendar"), #imageLiteral(resourceName: "information.png"), #imageLiteral(resourceName: "logout")]
let titles = [MyUser.name, "Lịch khám chữa bệnh", "Thông tin VKHS", "Đăng xuất"]


extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigCell", for: indexPath) as! BigCell
            cell.avatarImageView.image = images[indexPath.row]
            cell.avatarImageView.layer.cornerRadius = 25.0
            cell.avatarImageView.layer.masksToBounds = true
            cell.userNameLabel.text = titles[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NormalCell
        cell.cellImageView.image = images[indexPath.row]
        cell.selectionStyle = .blue
        cell.cellTitle.text = titles[indexPath.row]

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            
            break
            
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HealthSchedulersViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
            break
            
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VkhsInfoViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
            break
        
        case 3:
            let alert = UIAlertController(title: "Xác nhận", message: "Bạn chắc chắn muốn đăng xuất?", preferredStyle: .alert)
            let okACtion = UIAlertAction(title: "Đăng xuất", style: .destructive, handler: { (action) in
                let loginVc = MyStoryboard.loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
                UserDefaults.standard.set(false, forKey: DidLogin)
                guard let window = UIApplication.shared.keyWindow else { return }
                UIView.transition(with: window, duration: 0.5, options: .transitionCurlDown, animations: {
                    window.rootViewController = loginVc
                    window.makeKeyAndVisible()
                })
            })
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel)
            alert.addAction(okACtion)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
            break
        default:
            break
        }

    }

}








