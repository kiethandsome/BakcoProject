//
//  CalendarCell.swift
//  BAKCO VanKhang
//
//  Created by lou on 6/4/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var currentDateMarkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.currentDateMarkView.isHidden = true
    }

}
