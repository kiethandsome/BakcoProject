//
//  BaseNavigationController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 11/22/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import DynamicColor

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = .white
        navigationBar.tintColor = UIColor.specialGreenColor()
        navigationBar.layer.shadowColor = UIColor.specialGreenColor().cgColor
        
        let fontSizeAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
                                 NSAttributedStringKey.foregroundColor: UIColor.specialGreenColor()]
        navigationBar.titleTextAttributes = fontSizeAttribute
        navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.isHidden = false
    }
    

}
