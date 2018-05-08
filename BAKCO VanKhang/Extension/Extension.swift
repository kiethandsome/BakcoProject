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
import Alamofire

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


extension Date { /// Convert from date to string
    
    func convertDateToString(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


extension String { /// Convert from String to Date
    
    func convertStringToDate(with format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "vi_VN")
        
        guard let result = dateFormatter.date(from: self) else { return Date() }
        return result
    }
}


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}




