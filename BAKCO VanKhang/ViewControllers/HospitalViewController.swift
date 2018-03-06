//
//  HospitalViewController.swift
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

protocol HopitalViewControllerDelegate: class {
    func didChooseHospital(hospital: HospitalModel)
}

class HospitalViewController: BaseViewController {
    
    @IBOutlet weak var hospitalCollection: UICollectionView!
    @IBOutlet var hospitalSearchBar: UISearchBar!
    
    var hospitals = [HospitalModel]()
    
    weak var delegate: HopitalViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chọn bệnh viện"
        hospitalCollection.delegate = self
        hospitalCollection.dataSource = self
        hospitalCollection.contentInset = UIEdgeInsetsMake(20, 30, 0, 30)
        hospitalCollection.register(HospitalCell.self, forCellWithReuseIdentifier: "cellId")
        getHospitals()
        showCancelButton()
    }
    
    
    func getHospitals() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string:"http://api.vkhs.vn/api/BkHospital/Get")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            
            if (response.error != nil) { // error
                self.showAlert(title: "Lỗi", mess: "Ko tìm thấy bệnh viện nào", style: .alert)
            } else {
                response.result.value?.forEach({ (json) in
                    let data = json.1.dictionaryObject
                    let newHospital: HospitalModel = HospitalModel(data: data!)
                    self.hospitals.append(newHospital)
                })
                self.hospitalCollection.reloadData()
            }
        }
    }
}


extension HospitalViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let currentHospital = hospitals[indexPath.item]
        dismiss(animated: true) {
            self.delegate.didChooseHospital(hospital: currentHospital)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hospitals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! HospitalCell

        let fontAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray,
                             NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 11.0)]
            as [NSAttributedStringKey : Any]
        cell.hospitalImageView.layer.cornerRadius = 15.0
        cell.hospitalImageView.clipsToBounds = true
        cell.hospitalImageView.layer.borderWidth = 1.0
        cell.hospitalImageView.layer.borderColor = UIColor.black.cgColor
        let imageLink = hospitals[indexPath.item].Image!
        cell.hospitalImageView.sd_setImage(with: URL(string: imageLink), placeholderImage: #imageLiteral(resourceName: "hospital"))
        cell.hospitalNameLabel.attributedText = NSAttributedString(string: hospitals[indexPath.item].Name!,
                                                                   attributes: fontAttribute)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 70 + 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}












//    public func alert(with hospital: HospitalModel) -> UIAlertController {
//        let alert = UIAlertController(title: "Loại hình khám bệnh khám bệnh",
//                                      message: "",
//                                      preferredStyle: .actionSheet)
//
//        let redAction = UIAlertAction(title: "Khám thông thường", style: .default) { (action) in
//            let chooseSpecialtyScreen = self.storyboard?.instantiateViewController(withIdentifier: "ChooseSpecialtyViewController") as! ChooseSpecialtyViewController
//            chooseSpecialtyScreen.hospitalName = hospital.Name
//            chooseSpecialtyScreen.hospitalAddress = hospital.Address
//            chooseSpecialtyScreen.hospitalService = "Khám thông thường"
//            self.navigationController?.pushViewController(chooseSpecialtyScreen, animated: true)
//        }
//        let greenAction = UIAlertAction(title: "Khám dịch vụ", style: .default) { (action) in
//
//        }
//        let blueAction = UIAlertAction(title: "Khám chuyên khoa", style: .default) { (action) in
//
//        }
//        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
//
//        alert.addAction(redAction)
//        alert.addAction(greenAction)
//        alert.addAction(blueAction)
//        alert.addAction(cancelAction)
//        return alert
//    }






