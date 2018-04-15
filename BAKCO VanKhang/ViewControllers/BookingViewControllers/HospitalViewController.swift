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

class HospitalViewController: BaseViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var hospitalCollection: UICollectionView!
    
    @IBOutlet var hospitalSearchBar: UISearchBar!
    
    let hospitalSearchController = UISearchController()
    
    var hospitals = [HospitalModel]()
    
    var filterredHospitals = [HospitalModel]()
    
    weak var delegate: HopitalViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chọn bệnh viện"
        hospitalCollection.isScrollEnabled = true
        hospitalCollection.delegate = self
        hospitalCollection.dataSource = self
        hospitalCollection.contentInset = UIEdgeInsetsMake(20, 30, 0, 30)
        hospitalCollection.register(HospitalCell.self, forCellWithReuseIdentifier: "cellId")
        getHospitals()
        showCancelButton()
        
        if #available(iOS 11.0, *) {
            setupSearchBar()
        }
    }
    
    private func setupSearchBar() {
        if #available(iOS 11.0, *) {
            self.hospitalSearchController.searchResultsUpdater = self
            self.hospitalSearchController.obscuresBackgroundDuringPresentation = false
            self.hospitalSearchController.searchBar.placeholder = "con chim non"
            definesPresentationContext = true
            
            self.navigationItem.searchController = hospitalSearchController

        } else {

        }
    }
    
    func getHospitals() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string:"http://api.vkhs.vn/api/BkHospital/Get")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            
            if (response.error != nil) { /// error
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

extension HospitalViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func searchBarIsEmpty() -> Bool {
        return hospitalSearchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.filterredHospitals = hospitals.filter({ (hospital) -> Bool in
            return (hospital.Name?.lowercased().contains(searchText.lowercased()))!
        })
        self.hospitalCollection.reloadData()
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













