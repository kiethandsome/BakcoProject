//
//  PaintentCell.swift
//  BAKCO VanKhang
//
//  Created by Lou on 2/27/1397 AP.
//  Copyright © 1397 Lou. All rights reserved.
//

import UIKit
import Foundation

class PatientCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
