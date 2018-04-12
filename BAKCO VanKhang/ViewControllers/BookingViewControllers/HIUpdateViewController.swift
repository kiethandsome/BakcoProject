//
//  HIUpdateViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/3/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation
import UIKit
import IQDropDownTextField
import MBProgressHUD
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

class HIUPdateViewController : UIViewController {

    
    @IBOutlet var viewPopupUI: UIView!
    @IBOutlet var healthInsuranceTextfield: UITextField!
    @IBOutlet var issuedPlaceTextfield: UITextField!
    @IBOutlet var startDayTextfield: IQDropDownTextField!
    @IBOutlet var endDayTextfield: IQDropDownTextField!
    @IBOutlet var confirmButton: UIButton!
    
    @IBAction func cancelAction(_ sender: Any) {
        dismissViewWithAnimation()
    }
    
    @IBAction func confirmUpdate(_ sender: Any) {
        let format = "yyyy-MM-dd"
        guard let hiid = healthInsuranceTextfield.text, let hosName = issuedPlaceTextfield.text,
            let startDate = startDayTextfield.date, let endDate = endDayTextfield.date
            else {return}
        
        if hiid == ""  || hosName == "" {
            showAlert(errorMess: "Bạn chưa nhập đủ thông tin")
        } else {
            updateHealthInsurance(userId: MyUser.id,
                                  HIId: hiid,
                                  hospital: hosName,
                                  start: startDate.convertDateToString(with: format),
                                  end: endDate.convertDateToString(with: format))
        }


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showViewWithAnimation()
        setupDropdownTextfield(tf: startDayTextfield)
        setupDropdownTextfield(tf: endDayTextfield)
        
        getHIId()
    }

    
    func setupDropdownTextfield(tf: IQDropDownTextField) {
        tf.isOptionalDropDown = false
        tf.showDismissToolbar = true
        tf.dropDownMode = .datePicker
    }
    
    private func showViewWithAnimation() {
        
        self.view.alpha = 0
        self.viewPopupUI.frame.origin.y = self.view.bounds.height
        
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
            self.viewPopupUI.center.y = self.view.center.y
        }
    }
    
    private func dismissViewWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewPopupUI.frame.origin.y = self.view.bounds.height
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
    }
}

extension HIUPdateViewController {
    
    func updateHealthInsurance(userId: Int, HIId: String, hospital: String, start: String, end: String) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let url = URL(string: _UpdateHIApi)!

        let param : Parameters = ["CustomerId" : userId,
                                  "HealthInsurance_Start_No" : HIId,
                                  "HealthInsurance_Start" : start,
                                  "HealthInsurance_End" : end,
                                  "HealthInsurance_Place" : hospital]

        let headers : HTTPHeaders = ["Accept": "application/json"]
        
        let completionHandler = {(response: DataResponse<String>) -> Void in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if response.result.isSuccess {
                
                let resultString = response.result.value
                
                let httpStatusCode = response.response?.statusCode
                
                print("RESPONSE : \(resultString ?? "No result")")
                
                print("Http Status Code : \(httpStatusCode ?? 10 )")
                
                self.dismissViewWithAnimation()
                
            } else {
                
                self.showAlert(errorMess: (response.error.debugDescription))
            
            }
        }

        Alamofire.request(url,
                          
                          method: .post,
                          
                          parameters: param,
                          
                          encoding: JSONEncoding.default,
                          
                          headers: headers)
            
            .responseString(completionHandler: completionHandler)

    }
    
    func getHIId() {
        
        let format = "yyyy-MM-dd'T'HH:mm:ss"
        
        let url = URL(string: "\(_GetHIApi)?CustomerId=\(MyUser.id)")!

        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if response.result.isSuccess {
                
                let data = response.value?.dictionaryObject
                
                ///Set value for textField.
                let currentHI = HealthInsurance(data: data!)
                
                self.healthInsuranceTextfield.text = currentHI.id
                self.issuedPlaceTextfield.text = currentHI.place
                
                let startDate = currentHI.startDate.convertStringToDate(with: format)
                let endDate = currentHI.endDate.convertStringToDate(with: format)
                
                self.startDayTextfield.setDate(startDate, animated: true)
                self.endDayTextfield.setDate(endDate, animated: true)
                
            } else {
               
                self.showAlert(errorMess: response.error.debugDescription)
                
            }
        }
    }
    
    
    //Mark : Alert
    func showAlert(errorMess: String) {
        
        let alert = UIAlertController(title: "Lỗi", message: errorMess, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


struct JSONDictionaryEncoding: ParameterEncoding {
    
    private let param: Parameters
    
    init(param: Parameters) {
        self.param = param
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let data = try JSONSerialization.data(withJSONObject: param, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        
        return urlRequest
    }
}
























