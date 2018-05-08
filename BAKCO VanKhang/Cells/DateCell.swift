//
//  DateCell.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/31/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

class DateCell: UICollectionViewCell {
    
    let textAttributes : [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0)]

    let title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        backgroundColor = UIColor.specialGreenColor()
        addContraintsWithFormat(format: "H:|[v0]|", views: title)
        addContraintsWithFormat(format: "V:|[v0]|", views: title)
        layer.cornerRadius = 8.0
        clipsToBounds = true
        title.attributedText = NSAttributedString(string: "", attributes: textAttributes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
