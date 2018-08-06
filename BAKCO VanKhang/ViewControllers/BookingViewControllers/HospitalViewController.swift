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

protocol HospitalViewControllerDelegate: class {
    func didChooseHospital(hospital: Hospital)
}

class HospitalViewController: BaseViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var hospitalCollection: UICollectionView!
    
    @IBOutlet var hospitalSearchBar: UISearchBar!
    
    let hospitalSearchController = UISearchController(searchResultsController: nil)
    
    var hospitals = [Hospital]()
    
    var filterredHospitals = [Hospital]()
    
    var url = URL(string: API.getHospitalsForm1)!
    
    weak var delegate: HospitalViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        navigationItem.title = "Chọn bệnh viện"
        hospitalCollection.isScrollEnabled = true
        hospitalCollection.delegate = self
        hospitalCollection.dataSource = self
        hospitalCollection.contentInset = UIEdgeInsetsMake(20, 30, 0, 30)
        hospitalCollection.register(HospitalCell.self, forCellWithReuseIdentifier: "cellId")
        getHospitals()
        showCancelButton()
        
    }
    
    private func setupSearchBar() {
        if #available(iOS 11.0, *) {
            self.hospitalSearchController.searchResultsUpdater = self
            self.hospitalSearchController.obscuresBackgroundDuringPresentation = false
            self.hospitalSearchController.searchBar.placeholder = "Tìm bệnh viện ..."
            self.hospitalSearchController.searchBar.tintColor = UIColor.specialGreenColor()
            self.hospitalSearchController.searchBar.isExclusiveTouch = true
            definesPresentationContext = true
            self.navigationItem.searchController = hospitalSearchController
        }
    }
    
    func getHospitals() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            
            if (response.error != nil) { /// error
                self.showAlert(title: "Lỗi", mess: "Ko tìm thấy bệnh viện nào", style: .alert)
            } else {
                response.result.value?.forEach({ (json) in
                    let data = json.1.dictionaryObject
                    let newHospital: Hospital = Hospital(data: data!)
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
            return (hospital.Name.lowercased().contains(searchText.lowercased()))
        })
        self.hospitalCollection.reloadData()
    }
    
    func isFiltering() -> Bool {
        return hospitalSearchController.isActive && !searchBarIsEmpty()
    }
}


extension HospitalViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var currentHospital: Hospital
        if isFiltering() {
            currentHospital = filterredHospitals[indexPath.row]
        } else {
            currentHospital = hospitals[indexPath.row]
        }
        self.delegate.didChooseHospital(hospital: currentHospital)
        self.navigationController?.dismiss(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filterredHospitals.count
        }
        return hospitals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! HospitalCell

        var currentHospital: Hospital
        
        if isFiltering() {
            currentHospital = filterredHospitals[indexPath.row]
        } else {
            currentHospital = hospitals[indexPath.row]
        }
        
        let fontAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray,
                             NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 11.0)]
            as [NSAttributedStringKey : Any]
        cell.hospitalImageView.layer.cornerRadius = 15.0
        cell.hospitalImageView.clipsToBounds = true
        cell.hospitalImageView.layer.borderWidth = 1.0
        cell.hospitalImageView.layer.borderColor = UIColor.black.cgColor
        cell.hospitalImageView.sd_setImage(with: URL(string: currentHospital.Image), placeholderImage: #imageLiteral(resourceName: "hospital"))
        cell.hospitalNameLabel.attributedText = NSAttributedString(string: currentHospital.Name,
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













