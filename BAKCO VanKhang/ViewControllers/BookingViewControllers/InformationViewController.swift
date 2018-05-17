//
//  InformationViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 12/13/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import IQDropDownTextField
import DropDown

protocol InformationViewControllerDelegate: class {
    func didSelectUser(with user: User)
}

class InformationViewController: BaseViewController {
    
    var selectedPaintent: User?
    var isMale = true
    weak var delegate: InformationViewControllerDelegate?
    var patientList = [String]()

    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var dropdownTextField: IQDropDownTextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var insuranceIDTextField: UITextField!
    @IBOutlet var idNumberTextField: UITextField!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femailButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Thông tin đăng kí"
        self.maleButton.backgroundColor = UIColor.lightGray
        self.maleButton.setImage(UIImage(named: "no-image"), for: .normal)
        self.femailButton.backgroundColor = UIColor.lightGray
        self.femailButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        showCancelButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dropdownTextField.isOptionalDropDown = false
        self.dropdownTextField.delegate = self
        patientList.append(MyUser.name)
        
        self.dropdownTextField.itemList = patientList
    }
    
    @IBAction func addMorePaintent(_ sender: Any) {
        clearAllTextField()
    }
    
    @IBAction func maleSelected(_ sender: Any) {
        isMale = true
        maleButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        femailButton.setImage(UIImage(named: "no-image"), for: .normal)
    }

    @IBAction func femaleSelected(_ sender: Any) {
        isMale = false
        femailButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        maleButton.setImage(UIImage(named: "no-image"), for: .normal)
    }
    
    @IBAction func confirm(_ sender: Any) {
        guard let user = selectedPaintent
            else { return }
        self.delegate?.didSelectUser(with: user)
        dismiss(animated: true)
    }
    
    override func popToBack() {
        self.dismiss(animated: true)
    }
    
    func clearAllTextField() {
        
    }
    
    func fillAllTextField() {
        fullNameTextField.text = MyUser.name
        phoneTextField.text = MyUser.phone
        emailTF.text = MyUser.email
    }
}

extension InformationViewController: IQDropDownTextFieldDelegate{
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        fillAllTextField()
        
    }
}









