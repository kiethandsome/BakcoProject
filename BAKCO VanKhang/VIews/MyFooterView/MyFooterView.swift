//
//  MyFooterView.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/15/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit

class MyFooterView: UIView {
    
    @IBOutlet var footerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.brown
    }
    
}
