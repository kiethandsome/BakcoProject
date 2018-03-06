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

class HospitalViewController: BaseViewController {
    
    @IBOutlet weak var hospitalCollection: UICollectionView!
    
    var hospitals = [HospitalModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Bệnh Viện"
        hospitalCollection.delegate = self
        hospitalCollection.dataSource = self
        hospitalCollection.contentInset = UIEdgeInsetsMake(20, 30, 0, 30)
        hospitalCollection.register(HospitalCell.self, forCellWithReuseIdentifier: "cellId")
        getHospitals()
        showBackButton()
    }
    
    func getHospitals() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string:"http://api.vkhs.vn/api/BkHospital/Get")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            response.result.value?.forEach({ (json) in
                var newHospital = HospitalModel()
                newHospital.initWithData(data: json.1.dictionaryObject!)
                self.hospitals.append(newHospital)
            })
            self.hospitalCollection.reloadData()
        }
    }
    
    public func alert(withHospital: HospitalModel) -> UIAlertController {
        let alert = UIAlertController(title: "Hãy chọn một phương thức khám bệnh",
                                      message: "",
                                      preferredStyle: .actionSheet)
        
        let redAction = UIAlertAction(title: "Khám thông thường", style: .destructive) { (action) in
            let chooseSpecialtyScreen = self.storyboard?.instantiateViewController(withIdentifier: "ChooseSpecialtyViewController") as! ChooseSpecialtyViewController
            chooseSpecialtyScreen.hospitalName = withHospital.Name
            chooseSpecialtyScreen.hospitalAddress = withHospital.Address
            chooseSpecialtyScreen.hospitalService = "Khám thông thường"
            self.navigationController?.pushViewController(chooseSpecialtyScreen, animated: true)
        }
        let greenAction = UIAlertAction(title: "Khám dịch vụ", style: .destructive) { (action) in
            
        }
        let blueAction = UIAlertAction(title: "Khám chuyên khoa", style: .destructive) { (action) in
            
        }
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        
        alert.addAction(redAction)
        alert.addAction(greenAction)
        alert.addAction(blueAction)
        alert.addAction(cancelAction)
        return alert
    }
}

extension HospitalViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let alert1 = alert(withHospital: hospitals[indexPath.item])
        present(alert1, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hospitals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! HospitalCell
        let imageLink = hospitals[indexPath.item].Image!
        cell.hospitalImageView.sd_setImage(with: URL(string: imageLink), placeholderImage: #imageLiteral(resourceName: "hospital"))
        cell.hospitalImageView.layer.cornerRadius = 15.0
        cell.hospitalImageView.clipsToBounds = true
        cell.hospitalImageView.layer.borderWidth = 1.0
        cell.hospitalImageView.layer.borderColor = UIColor.black.cgColor
        
        let fontAttribute = [NSAttributedStringKey.font: UIFont.init(name: "Avenir Book", size: 12.0) as Any]
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

class HospitalCell: UICollectionViewCell {
    
    let hospitalImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let hospitalNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(hospitalImageView)
        addSubview(hospitalNameLabel)
        addContraintsWithFormat(format: "H:|-15-[v0(70)]-15-|", views: hospitalImageView)
        addContraintsWithFormat(format: "V:|[v0(70)]-2-[v1(40)]|", views: hospitalImageView, hospitalNameLabel)
        addContraintsWithFormat(format: "H:|[v0]|", views: hospitalNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


















