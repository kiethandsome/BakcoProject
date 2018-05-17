//
//  PaintentCell.swift
//  BAKCO VanKhang
//
//  Created by Lou on 2/27/1397 AP.
//  Copyright © 1397 Lou. All rights reserved.
//

import UIKit
import Foundation
import DropDown

class PaintentCell: DropDownCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.optionLabel = nameLabel
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            backgroundColor = .lightGray
        }
    }
    
}
