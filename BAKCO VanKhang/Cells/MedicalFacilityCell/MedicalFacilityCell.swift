//
//  MedicalFacilityCell.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/22/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import UIKit
import SDWebImage

class MedicalFacilityCell: UITableViewCell {
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var hospitalImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(hospital: Hospital) {
        self.hospitalImageView.sd_setImage(with: URL(string: hospital.Image), placeholderImage: #imageLiteral(resourceName: "hospital"))
        self.addressLabel.text = hospital.Address
        self.emailLabel.text = hospital.Website
        self.hospitalNameLabel.text = hospital.Name
    }
    
}
