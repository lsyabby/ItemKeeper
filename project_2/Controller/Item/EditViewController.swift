//
//  EditViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/18.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import ZHDropDownMenu
import UserNotifications

protocol EditViewControllerDelegate: class {
    func passFromEdit(data: ItemList)
}

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZHDropDownMenuDelegate {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var categoryDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var enddateTextField: UITextField!
    @IBOutlet weak var alertdateTextField: UITextField!
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var alertInstockSwitch: UISwitch!
    @IBOutlet weak var othersTextView: UITextView!
    weak var delegate: EditViewControllerDelegate?
    var ref: DatabaseReference!
    var list: ItemList?
    var editItem: ItemList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOthersTextView()
        
        setupDropDownMenu()
        
        setupEditItems()
        
        setupDatePicker()
        
        setupSwitch()
        
    }
    
    @IBAction func enddateAction(_ sender: UITextField) {
        setDatePicker(sender: sender, action: #selector(enddatePickerValueChanged(sender:)))
    }
    
    @IBAction func alertdateAction(_ sender: UITextField) {
        setDatePicker(sender: sender, action: #selector(alertdatePickerValueChanged(sender:)))
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        ref = Database.database().reference()
        guard let item = list else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let updatedate = String(Int(Date().timeIntervalSince1970))
        let name = nameTextField.text ?? item.name
        let id = Int(idTextField.text!) ?? item.itemId
        let category = categoryDropDownMenu.contentTextField.text ?? item.createDate
        let enddate = enddateTextField.text ?? item.endDate
        let alertdate = alertdateTextField.text ?? item.alertDate
        let instock = Int(numTextField.text!) ?? item.instock
        let isinstock = alertInstockSwitch.isOn
        let alertinstock = item.alertInstock
        let price = Int(priceTextField.text!) ?? item.price
        let others = othersTextView.text ?? item.others
        
        // "imageURL": "",
        let editValue = ["updatedate": updatedate, "name": name, "id": id, "category": category, "enddate": enddate, "alertdate": alertdate, "instock": instock, "isInstock": isinstock, "alertInstock": alertinstock, "price": price, "others": others] as [String : Any]
        
        self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").queryEqual(toValue: item.createDate).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for info in (value?.allKeys)! {
                print("======= edit item !!!! @@@@ ======")
                print(info)
                self.ref.child("items/\(userId)/\(info)").updateChildValues(editValue)
            }
        }
        
        // MARK: - NOTIFICATION - send alert date
        guard let editAlertdate = alertdateTextField.text else { return }
        if editAlertdate != "不提醒" {
            
            if let editName = editValue["name"] as? String, let editEnddate = editValue["enddate"] as? String {
                let content = UNMutableNotificationContent()
                content.title = editName
                content.userInfo = ["alertDate": editAlertdate, "createDate": item.createDate, "id": item.itemId]
                content.body = "有效期限到 \(editEnddate)"
                content.badge = 1
                content.sound = UNNotificationSound.default()
                
                guard let imageData = NSData(contentsOf: URL(string: item.imageURL)!) else { return }
                guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "img.jpeg", data: imageData, options: nil) else { return }
                content.attachments = [attachment]
                
                let dateformatter: DateFormatter = DateFormatter()
                dateformatter.dateFormat = "yyyy - MM - dd"
                //            let alertDate: Date = dateformatter.date(from: editAlertdate)!
                let alertDate: Date = dateformatter.date(from: editEnddate)!
                let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                let components = gregorianCalendar.components([.year, .month, .day], from: alertDate)
                print("========= components ========")
                print("\(components.year) \(components.month) \(components.day)")
                //            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
                let request = UNNotificationRequest(identifier: item.createDate, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    print("build alertdate notificaion successful !!!")
                }
                
            }
        }
        self.delegate?.passFromEdit(data: ItemList(createDate: item.createDate, imageURL: item.imageURL, name: self.nameTextField.text!, itemId: Int(self.idTextField.text!)!, category: self.categoryDropDownMenu.contentTextField.text!, endDate: self.enddateTextField.text!, alertDate: self.alertdateTextField.text!, instock: Int(self.numTextField.text!)!, isInstock: self.alertInstockSwitch.isOn, alertInstock: item.alertInstock, price: Int(self.priceTextField.text!)!, others: self.othersTextView.text))
        dismiss(animated: true, completion: nil)
    }
}


extension EditViewController {
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print(text)
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print(index)
    }
    
    func setupEditItems() {
        guard let item = list else { return }
        itemImageView.sd_setImage(with: URL(string: item.imageURL))
        nameTextField.text = item.name
        idTextField.text = String(describing: item.itemId)
        categoryDropDownMenu.contentTextField.text = item.category
        priceTextField.text = String(describing: item.price)
        enddateTextField.text = item.endDate
        alertdateTextField.text = item.alertDate
        numTextField.text = String(describing: item.instock)
        alertInstockSwitch.isOn = item.isInstock
        othersTextView.text = item.others
    }
    
    func setupOthersTextView() {
        othersTextView.layer.cornerRadius = 5
        othersTextView.layer.borderWidth = 1
        othersTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupDropDownMenu() {
        categoryDropDownMenu.options = [ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
        categoryDropDownMenu.contentTextField.text = list?.category
        categoryDropDownMenu.editable = false
        categoryDropDownMenu.delegate = self
    }
    
    func setupDatePicker() {
        setDatePickerToolBar(dateTextField: enddateTextField)
        setDatePickerToolBar(dateTextField: alertdateTextField)
    }
    
    func setupSwitch() {
        alertInstockSwitch.setOn(false, animated: true)
        alertInstockSwitch.onTintColor = UIColor.darkGray
    }
    
    func setDatePickerToolBar(dateTextField: UITextField) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height / 6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let okBarBtn = UIBarButtonItem(title: "確定", style: .done, target: self, action: #selector(donePressed(sender:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 15)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "請選擇日期"
        label.textAlignment = .center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace, textBtn, flexSpace, okBarBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        enddateTextField.resignFirstResponder()
        alertdateTextField.resignFirstResponder()
    }
    
    @objc func enddatePickerValueChanged(sender: UIDatePicker) {
        setDateFormatter(dateTextField: self.enddateTextField, sender: sender)
    }
    
    @objc func alertdatePickerValueChanged(sender: UIDatePicker) {
        setDateFormatter(dateTextField: self.alertdateTextField, sender: sender)
    }
    
    private func setDateFormatter(dateTextField: UITextField, sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy - MM - dd"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    private func setDatePicker(sender: UITextField, action: Selector) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.locale = Locale(identifier: "zh_TW")
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: action, for: .valueChanged)
    }
    
}
