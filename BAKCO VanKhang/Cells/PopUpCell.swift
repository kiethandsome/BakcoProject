//
//  PopUpCell.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/31/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

class PopUpCell: UICollectionViewCell {
    
    var key = String()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .red
        addSubview(imageView)
        addSubview(nameLabel)
        addContraintsWithFormat(format: "H:|-10-[v0(50)]-10-|", views: imageView)
        addContraintsWithFormat(format: "V:|[v0(50)]-2-[v1(30)]|", views: imageView, nameLabel)
        addContraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
