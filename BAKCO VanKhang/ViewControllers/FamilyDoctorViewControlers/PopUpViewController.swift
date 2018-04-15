//
//  PopUpViewController.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 11/24/17.
//  Copyright © 2017 Pham An. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON
import MBProgressHUD

struct SelectedFDItem {
    static var serviceId = String()
    static var serviceName = String()
}


class PopUpViewController: UIViewController { ///Cant use baseViewCOntroller and dont know why
    
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    @IBOutlet var dismissPopUpButton: UIButton!
    @IBOutlet var popUpCollectionView: UICollectionView!
    
    let images = [#imageLiteral(resourceName: "ic_doctor"), #imageLiteral(resourceName: "ic-dieuduong"), #imageLiteral(resourceName: "ic_chamsocgiamnhe"), #imageLiteral(resourceName: "ic_vltlieu"), #imageLiteral(resourceName: "ic-yhctruyen")]
    let cellNames = ["Bác sĩ GD", "Điều dưỡng", "Chăm sóc giảm nhẹ", "Vật lí trị liệu", "Y học cổ truyền", "Vận chuyển"]
    private let keys = ["BSGD", "DDTN", "CSGN", "VLTL", "YHCT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showViewWithAnimation()
        viewPopupUI.layer.cornerRadius = 15.0
        viewPopupUI.clipsToBounds = true
        popUpCollectionView.delegate = self
        popUpCollectionView.dataSource = self
        popUpCollectionView.register(PopUpCell.self, forCellWithReuseIdentifier: "cellId")
        popUpCollectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        self.hideViewWithAnimation()
    }
    
    //MARK: - Animation Method
    
    private func showViewWithAnimation() {
        
        self.view.alpha = 0
        self.viewPopupUI.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.viewPopupUI.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1
        }
    }
    
    private func hideViewWithAnimation() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewPopupUI.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
    }
    
    /// alert
    private func showAlert(title: String, mess: String, style: UIAlertControllerStyle, isSimpleAlert: Bool = true) {
        let alertController = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            self.okAction()
        }
        alertController.addAction(okAction)
        if !isSimpleAlert { ///simple alert
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        present(alertController, animated: true)
    }
    
    private func okAction() {
        let vc = MyStoryboard.familyDoctorStoryboard.instantiateViewController(withIdentifier: "HomedTreatmentViewController") as! HomedTreatmentViewController
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true) {
        }
    }
}

extension PopUpViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Mark: Data source
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! PopUpCell
        self.requestService(with: cell.key)
        SelectedFDItem.serviceName = cell.nameLabel.text!
        SelectedFDItem.serviceId = cell.key

    }
    
    private func requestService(with serviceId: String) {
        let url = URL(string: "\(FamilyDocrorApi.serviceDetail)?ServiceId=\(serviceId)")!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseSwiftyJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = response.value?.dictionaryObject  {
                let dataResponse = FamilyDoctorResponse(data: data)
                let title = dataResponse.fdData?.title
                let introText = dataResponse.fdData?.introText
                self.showAlert(title: title ?? "Ko tìm thấy", mess: introText ?? "", style: .alert, isSimpleAlert: false)
            }
        }
    }

    
    //Mark: delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PopUpCell
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configCell(cell: PopUpCell, indexPath: IndexPath) {
        cell.imageView.image = images[indexPath.item]
        cell.imageView.layer.cornerRadius = 15.0
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.borderWidth = 1.0
        cell.imageView.layer.borderColor = UIColor.black.cgColor
        cell.key = keys[indexPath.item]
        let fontAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 11.0)] as [NSAttributedStringKey : Any]
        cell.nameLabel.attributedText = NSAttributedString(string: cellNames[indexPath.item],
                                                           attributes: fontAttribute)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 82)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    

}



