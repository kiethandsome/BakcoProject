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
    func didChooseSpecialty(specialty: SpecialtyModel)
}

class ChooseSpecialtyViewController: BaseViewController, CustomSearchControllerDelegate {

    @IBOutlet weak var specialtyList: UITableView!
    var specialties = [SpecialtyModel]()
    weak var delegate: ChooseSpecialtyViewControllerDelegate?
    var hospitalName:String!
    var hospitalAddress:String!
    var hospitalService:String!
    
    var hospitalId:Int!
    var type:String!
    var naviTitle:String!
    
    let searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false
    var filteredArray = [SpecialtyModel]()
    var customSearchController: CustomSearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = naviTitle
        showCancelButton()
        specialtyList.dataSource = self
        specialtyList.delegate = self
        //configSearchController()
        configureCustomSearchController()
        
        guard let hospitalID = hospitalId, let type = type
            else { return }
        
        getSpecialties(hospitalId: hospitalID, type: type)
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
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: specialtyList.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: .orange, searchBarTintColor: .black)
        
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        specialtyList.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customDelegate = self
    }
    
    
    func getSpecialties(hospitalId:Int, type:String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(URL(string:"http://api.vkhs.vn/api/BkHospitalHealthCare/GetByHospitalId?HospitalId=\(hospitalId)&Type=\(type)")!, method: .get).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.value as Any)
            response.result.value?.forEach({ (json) in
                var newSpecialty = SpecialtyModel()
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
        // Filter the data array and get only those countries that match the search text.
        filteredArray = specialties.filter({ (specialty) -> Bool in
            let countryText = specialty.Name
            
            return (countryText?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        })
        // Reload the tableview.
        specialtyList.reloadData()
    }
}

extension ChooseSpecialtyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let specialtyCell = tableView.dequeueReusableCell(withIdentifier: "specialtyCell")
        
        if shouldShowSearchResults {
            specialtyCell?.textLabel?.text = filteredArray[indexPath.row].Name
//            specialtyCell?.detailTextLabel?.text = String(filteredArray[indexPath.row].Price!)
        } else {
            specialtyCell?.textLabel?.text = specialties[indexPath.row].Name
//            specialtyCell?.detailTextLabel?.text = String(specialties[indexPath.row].Price!)
        }
        return specialtyCell!
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
            dismiss(animated: true)
        }
        else {
            self.delegate?.didChooseSpecialty(specialty: specialties[indexPath.row])
            dismiss(animated:true)
        }
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







