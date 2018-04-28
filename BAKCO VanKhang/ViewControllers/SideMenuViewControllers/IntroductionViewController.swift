//
//  IntroductionViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/18/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import UIKit

class IntroductionViewController: BaseViewController {
    
    @IBOutlet var textView: UITextView!
    
    var content = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        textView.text = content
        showBackButton()
    }
    
    
}
