//
//  Extension.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 11/23/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit
import DynamicColor


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func specialGreenColor() -> UIColor {
        let color = DynamicColor(hexString: "4095A3")
        return color
    }
    
}

extension UIView {
    func addContraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: viewsDictionary))
    }
}







