//
//  AddItemViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/9.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore
import SDWebImage
import AVFoundation
import ZHDropDownMenu

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZHDropDownMenuDelegate {

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var addIdTextField: UITextField!
    @IBOutlet weak var categoryDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var enddateTextField: UITextField!
    @IBOutlet weak var alertdateTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var instockSwitch: UISwitch!
    @IBOutlet weak var alertNumTextField: UITextField!
    @IBOutlet weak var othersTextField: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveToFirebase(sender:)))
        // addImage
        addImageView.isUserInteractionEnabled = true
        let touch = UITapGestureRecognizer(target: self, action: #selector(bottomAlert))
        addImageView.addGestureRecognizer(touch)
        
        // dropDownMenu
        categoryDropDownMenu.options = ["食品", "藥品", "美妝", "日用品", "其他"]
        categoryDropDownMenu.editable = false //不可编辑
        categoryDropDownMenu.delegate = self
        
        // datePicker
        setDatePickerToolBar(dateTextField: enddateTextField)
        setDatePickerToolBar(dateTextField: alertdateTextField)
        
        // notification
        let notificationName = Notification.Name("BarcodeScanResult")
        NotificationCenter.default.addObserver(self, selector: #selector(getScanResult(noti:)), name: notificationName, object: nil)
        
        // switch
        alertNumTextField.isHidden = true
        instockSwitch.setOn(false, animated: true)
        instockSwitch.onTintColor = UIColor.darkGray
        instockSwitch.addTarget(self, action: #selector(setSwitchColor(sender:)), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        addImageView.image = image
        //        firebaseManager.updateProfilePhoto(uploadimage: image)
        dismiss(animated: true, completion: nil)
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }
    
    // ??? why
    @IBAction func scanAction(_ sender: UIButton) {
    }
    
    @IBAction func enddateAction(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(enddatePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @IBAction func alertdateAction(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(alertdatePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    func setDatePickerToolBar(dateTextField: UITextField) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height / 6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(sender:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select a due date"
        label.textAlignment = .center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
    }
    
    @objc func saveToFirebase(sender: UIButton) {
        print("save!!!!!!!!!")
        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let createdate = String(Int(Date().timeIntervalSince1970))
        let image = "???"
        let name = addNameTextField.text ?? ""
        let id = Int(addIdTextField.text!) ?? 0
        let category = categoryDropDownMenu.contentTextField.text
        let enddate = enddateTextField.text
        let alertdate = alertdateTextField.text ?? ""
        let remainday = 3
        let instock = Int(numberTextField.text!) ?? 0
        let isinstock = instockSwitch.isOn
        let alertinstock = Int(alertNumTextField.text!) ?? 0
        let price = Int(priceTextField.text!) ?? 0
        let others = othersTextField.text ?? ""
        
        let value = ["createdate": createdate, "imageURL": image, "name": name, "id": id, "category": category, "enddate": enddate, "alertdate": alertdate, "remainday": remainday, "instock": instock, "isInstock": isinstock, "alertInstock": alertinstock, "price": price, "others": others] as [String : Any]
        
        if instockSwitch.isOn {
            let key = self.ref.child("instocks/\(userId)").childByAutoId().key
            let childUpdate = ["\(key)": value]
            ref.child("instocks/\(userId)").updateChildValues(childUpdate)
        } else {
            let key = self.ref.child("items/\(userId)").childByAutoId().key
            let childUpdate = ["\(key)": value]
            ref.child("items/\(userId)").updateChildValues(childUpdate)
        }
    }
    
    @objc func enddatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        enddateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func alertdatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        alertdateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        enddateTextField.resignFirstResponder()
        alertdateTextField.resignFirstResponder()
    }
    
    @objc func bottomAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let photoAction = UIAlertAction(title: "相片", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "相機", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved", message: "Your picture has been saved to your photo library.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func getScanResult(noti: Notification) {
        guard let pass = noti.userInfo!["PASS"] as? String else { return }
        self.addIdTextField.text = pass
    }
    
    @objc func setSwitchColor(sender: UISwitch) {
        if sender.isOn {
            alertNumTextField.isHidden = false
        } else {
            alertNumTextField.isHidden = true
        }
    }

}
