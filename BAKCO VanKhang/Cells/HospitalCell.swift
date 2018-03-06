//
//  HospitalCell.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/31/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

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
