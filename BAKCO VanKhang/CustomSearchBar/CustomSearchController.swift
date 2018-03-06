//
//  CustomSearchController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 11/28/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit

protocol CustomSearchControllerDelegate {
    func didStartSearching()
    
    func didTapOnSearchButton()
    
    func didTapOnCancelButton()
    
    func didChangeSearchText(searchText: String)
}

class CustomSearchController: UISearchController {

    var customSearchBar: CustomSearchBar!
    var customDelegate: CustomSearchControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        customSearchBar = CustomSearchBar(frame: frame, font: font , textColor: textColor)
        
        customSearchBar.barTintColor = bgColor
        customSearchBar.tintColor = textColor
        customSearchBar.showsBookmarkButton = true
        customSearchBar.delegate = self
    }
}

extension CustomSearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        customSearchBar.setShowsCancelButton(true, animated: true)
        customDelegate.didStartSearching()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.setShowsCancelButton(false, animated: true)
        customSearchBar.endEditing(true)
        customDelegate.didTapOnSearchButton()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.setShowsCancelButton(false, animated: true)
        customSearchBar.endEditing(true)
        customDelegate.didTapOnCancelButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        customDelegate.didChangeSearchText(searchText: searchText)
    }
}













