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
    
    let images = [#imageLiteral(resourceName: "new_user"), #imageLiteral(resourceName: "user (1)"), #imageLiteral(resourceName: "open-book"), #imageLiteral(resourceName: "information.png"), #imageLiteral(resourceName: "phoe"), #imageLiteral(resourceName: "logout")]
    let titles = [MyUser.name, PersonalInforTitle, ServiceIntroductionTitle, "Thông tin VKHS", "Liên hệ", "Đăng xuất"]
    
    @objc func dismissWithAnmation() {
        dismiss(animated: true)
    }
    
    @IBOutlet var sideTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tuỳ chọn thông tin"
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
        tv.separatorInset.left = 0
        tv.tableFooterView = UIView()
        tv.contentInset.bottom = 20.0
    }
}



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
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NormalCell
        cell.cellImageView.image = images[indexPath.row]
        cell.selectionStyle = .blue
        cell.cellTitle.text = titles[indexPath.row]
        cell.accessoryType  = .disclosureIndicator
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
            
        case 0:
            break
            
        case 1: /// Thong tin ca nhan
            let vc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "SelectIntroductionViewController") as! SelectIntroductionViewController
            vc.title = PersonalInforTitle
            self.navigationController?.pushViewController(vc, animated: true)
            break

            
//        case 2: /// Hướng dẫn sử dụng
//            let vc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "SelectIntroductionViewController") as! SelectIntroductionViewController
//            vc.title = GuildlineTitle
//            self.navigationController?.pushViewController(vc, animated: true)
//            break
            
        case 2: /// Gioi thieu dich vu
            let vc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "SelectIntroductionViewController") as! SelectIntroductionViewController
            vc.title = ServiceIntroductionTitle
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
            
        case 3: /// Thông tin ứng dụng
            let vc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "VkhsInfoViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 4: /// Liên hệ
            let vc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "IntroductionViewController") as! IntroductionViewController
            vc.content = MyIntroductionText.contactInformation
            vc.title = "Liên hệ"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        
        case 5: /// Đăng xuất
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









