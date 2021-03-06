//
//  IntroductionVie.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/18/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit

let ServiceIntroductionTitle = "Giới thiệu dịch vụ"
let GuildlineTitle = "Hướng dẫn sử dụng"
let PersonalInforTitle = "Trang cá nhân"

class SelectIntroductionViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var selectionIntroduceTableview: UITableView!

    var cellTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        selectionIntroduceTableview.delegate = self
        selectionIntroduceTableview.dataSource = self
        selectionIntroduceTableview.separatorInset.left = 0
        selectionIntroduceTableview.rowHeight = 60.0
        selectionIntroduceTableview.tableFooterView = UIView()
        
        switch self.title! {
            
        case ServiceIntroductionTitle:
            self.cellTitles = ["Thông tin VKHS", "Gọi cấp cứu SOS", "Tư vấn sức khoẻ từ xa", "Chữa bệnh tại nhà", "Đặt lịch khám chữa bệnh"]
            break
            
        case GuildlineTitle:
            self.cellTitles = ["True Conf"]
            break
            
        case PersonalInforTitle:
            self.cellTitles = ["Thông tin cá nhân", "Lịch sử sử dụng dịch vụ", "Đổi mật khẩu", "Hồ sơ sức khỏe cá nhân (PHR)"]
            break
            
        default:
            break
        }
    }
    
    
    // Mark : Delegate & Data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntroductionCell", for: indexPath)
        cell.textLabel?.text = cellTitles[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        guard let titleText = cell.textLabel?.text else { return }
        
        let vc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "IntroductionViewController") as! IntroductionViewController

        switch titleText {
            
        case "Thông tin VKHS":
            let viewController = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "VkhsInfoViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
            break
            
        case "Gọi cấp cứu SOS":
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "Gọi cấp cứu SOS"
            vc.content = MyIntroductionText.sosIntroduction
            break
            
        case "Tư vấn sức khoẻ từ xa" :
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "Tư vấn sức khoẻ từ xa"
            vc.content = MyIntroductionText.teleHealth
            break
        
        case "Chữa bệnh tại nhà" :
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "Chữa bệnh tại nhà"
            vc.content = MyIntroductionText.familyDoctor
            break
            
        case "Đặt lịch khám chữa bệnh" :
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "Đăng kí khám chữa bệnh"
            vc.content = MyIntroductionText.booking
            break
            
        case "Lịch sử sử dụng dịch vụ" :
            let healthSchedulerVc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "HealthSchedulersViewController")
            self.navigationController?.pushViewController(healthSchedulerVc, animated: true)
            break
            
        case "Thông tin cá nhân" :
            let updateInformVc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "UpdateInfoViewController") as! UpdateInfoViewController
            self.navigationController?.pushViewController(updateInformVc, animated: true)
            updateInformVc.userId = MyUser.id
            break
            
        case "Đổi mật khẩu" :
            let changePassVc = MyStoryboard.sideMenuStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.navigationController?.pushViewController(changePassVc, animated: true)
            break
            
        case "Hồ sơ sức khỏe cá nhân (PHR)":
            break
        
        default:
            break
        }
    }
}
































