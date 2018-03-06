//
//  MenuCell.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/31/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import Foundation
import UIKit

class NormalCell: UITableViewCell {
    
    let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.specialGreenColor()
        return iv
    }()
    
    let cellTitle: UILabel = {
        let lb = UILabel()
        lb.contentMode = .center
        lb.textAlignment = .justified
        return lb
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(cellTitle)
        self.addSubview(cellImageView)
        separatorInset.left = 0
        
        addContraintsWithFormat(format: "H:|-10-[v0(30)]-15-[v1]|", views: cellImageView, cellTitle)
        addContraintsWithFormat(format: "V:|-20-[v0(20)]", views: cellImageView)
        addContraintsWithFormat(format: "V:|-20-[v0(20)]", views: cellTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BigCell: UITableViewCell {
    
    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.bounds.size = CGSize(width: 100, height: 100)
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let lb = UILabel()
        lb.contentMode = .center
        lb.textAlignment = .center
        return lb
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset.left = 0
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        
        addContraintsWithFormat(format: "V:|-20-[v0]-20-[v1]", views: avatarImageView, userNameLabel)
        NSLayoutConstraint(item: avatarImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: userNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
