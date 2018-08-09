//
//  ChooseSpecialtyViewController.swift
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

protocol ChooseSpecialtyViewControllerDelegate: class {
    func didChooseSpecialty(specialty: Specialty)
}

class ChooseSpecialtyViewController: BaseViewController, CustomSearchControllerDelegate {

    @IBOutlet weak var specialtyList: UITableView!
    var specialties = [Specialty]()
    weak var delegate: ChooseSpecialtyViewControllerDelegate?
    var hospitalName:String!
    var hospitalAddress:String!
    var hospitalService:String!
    
    var form = Int()
    
    var direction: DirectViewController! {
        didSet {
            if direction == .booking {
                self.form = 1
            } else {
                self.form = 2
            }
        }
    }

    
    let searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false
    var filteredArray = [Specialty]()
    var customSearchController: CustomSearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chuyên khoa"
        showCancelButton()
        specialtyList.dataSource = self
        specialtyList.delegate = self
        specialtyList.tableFooterView = UIView()
        specialtyList.rowHeight = 60.0
        //configSearchController()
        configureCustomSearchController()
        
//        guard let hospitalID = hospitalId, let type = type
//            else { return }
        
        getSpecialties(hospitalId: BookingInfo.hospital.Id, type: BookingInfo.serviceType.id, form: form)
        showCancelButton()
    }
    
//    func configSearchController() {
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = true
//        searchController.searchBar.placeholder = "Tìm kiếm..."
//        searchController.searchBar.delegate = self
//        searchController.searchBar.sizeToFit()
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.searchBarStyle = .prominent
//        specialtyList.tableHeaderView = searchController.searchBar
//    }
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: specialtyList.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.specialGreenColor(), searchBarTintColor: .white)
        
        customSearchController.customSearchBar.placeholder = "Tìm kiếm chuyên khoa ..."
        specialtyList.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customDelegate = self
    }
    
    
    func getSpecialties(hospitalId:Int, type: Int, form: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string: API.getHealthCareByHospital + "?HospitalId=\(hospitalId)&Type=\(type)&Form=\(form)")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            response.result.value?.forEach({ (json) in
                var newSpecialty = Specialty()
                newSpecialty.initWithData(data: json.1.dictionaryObject!)
                self.specialties.append(newSpecialty)
            })
            self.specialtyList.reloadData()
        }
        
    }
    
    // Mark: Custom search Controller Delegare funcs
    
    func didStartSearching() {
        shouldShowSearchResults = true
        specialtyList.reloadData()
    }
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        specialtyList.reloadData()
    }
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            specialtyList.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func didChangeSearchText(searchText: String) {
        /// Filter the data array and get only those countries that match the search text.
        filteredArray = specialties.filter({ (specialty) -> Bool in
            let countryText = specialty.Name
            
            return (countryText.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        })
        /// Reload the tableview.
        specialtyList.reloadData()
    }
}

extension ChooseSpecialtyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let specialtyCell = tableView.dequeueReusableCell(withIdentifier: "specialtyCell", for: indexPath)
        if shouldShowSearchResults {
            specialtyCell.textLabel?.text = filteredArray[indexPath.row].Name
            specialtyCell.detailTextLabel?.text = String(filteredArray[indexPath.row].Price)
        } else {
            specialtyCell.textLabel?.text = specialties[indexPath.row].Name
            specialtyCell.detailTextLabel?.text = String(specialties[indexPath.row].Price)
        }
        return specialtyCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return specialties.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if shouldShowSearchResults {
            self.delegate?.didChooseSpecialty(specialty: filteredArray[indexPath.row])
        } else {
            self.delegate?.didChooseSpecialty(specialty: specialties[indexPath.row])
        }
        dismiss(animated: true)
    }

}

//extension ChooseSpecialtyViewController: UISearchResultsUpdating, UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchString = searchController.searchBar.text
//
//        // Filter the data array and get only those countries that match the search text.
//        filteredArray = specialties.filter({ (specialty) -> Bool in
//            let countryText = specialty.Name
//
//            return (countryText?.range(of: searchString!, options: .caseInsensitive, range: nil, locale: nil) != nil)
//        })
//
//        // Reload the tableview.
//        specialtyList.reloadData()
//    }
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        shouldShowSearchResults = true
//        specialtyList.reloadData()
//    }
//
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        shouldShowSearchResults = false
//        specialtyList.reloadData()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if !shouldShowSearchResults {
//            shouldShowSearchResults = true
//            specialtyList.reloadData()
//        }
//
//        searchController.searchBar.resignFirstResponder()
//    }
//}







