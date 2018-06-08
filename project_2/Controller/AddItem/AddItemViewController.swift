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
import FirebaseStorage
import FirebaseCore
import SDWebImage
import AVFoundation
import ZHDropDownMenu
import UserNotifications
import Lottie
import RealmSwift

class AddItemViewController: UIViewController {

    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var addIdTextField: UITextField!
    @IBOutlet weak var categoryDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var enddateTextField: UITextField!
    @IBOutlet weak var alertdateTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var instockSwitch: UISwitch!
    @IBOutlet weak var alertNumTextField: UITextField!
    @IBOutlet weak var othersTextView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!

    let firebaseManager = FirebaseManager()
    var ref: DatabaseReference!
    var newImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 182/255.0, green: 222/255.0, blue: 215/255.0, alpha: 1.0)

        saveBtn.isHidden = false
        saveBtn.isUserInteractionEnabled = true

        setNavBackground()

        setupOthersTextView()

        setupDropDownMenu()

        setupDatePicker()

        setupSwitch()

        // MARK: - NOTIFICATION - get barcode result
        let notificationName = Notification.Name("BarcodeScanResult")
        NotificationCenter.default.addObserver(self, selector: #selector(getScanResult(noti:)), name: notificationName, object: nil)

    }

    @IBAction func addItemAction(_ sender: UIButton) {
        
        saveToFirebase(sender: sender)
    
    }

    @IBAction func cancelItemAction(_ sender: UIButton) {

        DispatchQueue.main.async {
            AppDelegate.shared.switchToMainStoryBoard()
        }
        
    }

    @IBAction func enddateAction(_ sender: UITextField) {
        setDatePicker(sender: sender, action: #selector(enddatePickerValueChanged(sender:)))
    }

    @IBAction func alertdateAction(_ sender: UITextField) {
        setDatePicker(sender: sender, action: #selector(alertdatePickerValueChanged(sender:)))
    }

    func saveToFirebase(sender: UIButton) {
        // request for local notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        }

        let createdate = String(Int(Date().timeIntervalSince1970))
        guard addNameTextField.text != "" else { return  setupTextField(textf: addNameTextField) }
        let name = addNameTextField.text
        let itemid = Int(addIdTextField.text!) ?? 0
        guard categoryDropDownMenu.contentTextField.text != "" else { return setupTextField(textf: categoryDropDownMenu.contentTextField) }
        let category = categoryDropDownMenu.contentTextField.text
        guard enddateTextField.text != "" else { return setupTextField(textf: enddateTextField) }
        let enddate = enddateTextField.text

        guard let originalertdate = alertdateTextField.text else { return }
        let alertdate = originalertdate == "" ? "不提醒": originalertdate
        let instock = Int(numberTextField.text!) ?? 1
        let isinstock = instockSwitch.isOn
        let alertinstock = Int(alertNumTextField.text!) ?? 0
        let price = Int(priceTextField.text!) ?? 0
        guard let originothers = othersTextView.text else { return }
        let others = originothers == "" ? "無": originothers

        let value = ["createdate": createdate, "imageURL": "", "name": name, "id": itemid, "category": category, "enddate": enddate, "alertdate": alertdate, "instock": instock, "isInstock": isinstock, "alertInstock": alertinstock, "price": price, "others": others] as [String: Any]

        // animation for loading
        loadingAnimation()

        saveBtn.isHidden = true
        saveBtn.isUserInteractionEnabled = false

        if let photo = self.newImage {
            
            firebaseManager.addNewData(photo: photo, value: value) { (info) in
                self.setupLocalNotification(info: info)
            }
            
        }
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

    @objc func donePressed(sender: UIBarButtonItem) {
        enddateTextField.resignFirstResponder()
        alertdateTextField.resignFirstResponder()
    }

    @objc func getScanResult(noti: Notification) {
        guard let pass = noti.userInfo!["PASS"] as? String else { return }
        self.addIdTextField.text = pass
    }

    @objc func setSwitchColor(sender: UISwitch) {
        if sender.isOn {
            alertNumTextField.isHidden = true
        } else {
            alertNumTextField.isHidden = true
        }
    }

    func setNavBackground() {
        navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
    }

    private func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = navigationController?.navigationBar.bounds
        updatedFrame?.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(
            bounds: updatedFrame!,
            color1: UIColor(red: 213/255.0, green: 100/255.0, blue: 124/255.0, alpha: 1.0),
            color2: UIColor(red: 213/255.0, green: 100/255.0, blue: 124/255.0, alpha: 1.0)
        )
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    private func setupTextField(textf: UITextField) {
        textf.layer.cornerRadius = 5
        textf.layer.borderWidth = 1
        textf.layer.borderColor = UIColor.red.cgColor
    }

    func setupLocalNotification(info: ItemList) {

        // MARK: - NOTIFICATION - send alert date
        let content = UNMutableNotificationContent()
        content.title = info.name
        content.userInfo = [
            "createDate": info.createDate,
            "imageURL": info.imageURL,
            "name": info.name,
            "itemId": info.itemId,
            "category": info.category,
            "endDate": info.endDate,
            "alertDate": info.alertDate,
            "instock": info.instock,
            "isInstock": info.isInstock,
            "alertInstock": info.alertInstock,  // delete
            "price": info.price,
            "others": info.others
        ]
        content.body = "有效期限到 \(info.endDate)"
//        content.badge = 1 //
        content.sound = UNNotificationSound.default()

        guard let imageData = NSData(contentsOf: URL(string: info.imageURL)!) else { return }
        guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "img.jpeg", data: imageData, options: nil) else { return }
        content.attachments = [attachment]

        let dateformatter: DateFormatter = DateFormatter()
        dateformatter.dateFormat = "yyyy - MM - dd"
        if info.alertDate != "不提醒" {
            let alertDate: Date = dateformatter.date(from: info.alertDate)!
//            let alertDate: Date = dateformatter.date(from: info.endDate)!
            let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let components = gregorianCalendar.components([.year, .month, .day], from: alertDate)
            print("========= components ========")
            print("\(components.year) \(components.month) \(components.day)")
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
            let request = UNNotificationRequest(identifier: info.createDate, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (_) in
                print("build alertdate notificaion successful !!!")
            }

            // MARK: SAVE IN Realm
            do {
                let realm = try Realm()
                let order: ItemInfoObject = ItemInfoObject()

                order.alertCreateDate = "\(info.alertDate)_\(info.createDate)"
                order.isRead = false
                order.alertNote = "有效期限到 \(info.endDate)"
                let dateformatter: DateFormatter = DateFormatter()
                dateformatter.dateFormat = "yyyy - MM - dd"
                let eString = info.alertDate
                let alertDF: Date = dateformatter.date(from: eString)!
                order.alertDateFormat = alertDF
                order.createDate = info.createDate
                order.imageURL = info.imageURL
                order.name = info.name
                order.itemId = info.itemId
                order.category = info.category
                order.endDate = info.endDate
                order.alertDate = info.alertDate
                order.instock = info.instock
                order.isInstock = info.isInstock
                order.alertInstock = info.alertInstock // delete
                order.price = info.price
                order.others = info.others

                try realm.write {
                    realm.add(order)
                }
                print("@@@ fileURL @@@: \(String(describing: realm.configuration.fileURL))")
            } catch let error as NSError {
                print(error)
            }

        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageVC = segue.destination as? AddImageViewController {
            imageVC.delegate = self
        }
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
    
    func setupOthersTextView() {
        othersTextView.layer.cornerRadius = 5
        othersTextView.layer.borderWidth = 1
        othersTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupDropDownMenu() {
        categoryDropDownMenu.options = [ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
        categoryDropDownMenu.editable = false //不可编辑
        categoryDropDownMenu.delegate = self
    }
    
    func setupDatePicker() {
        setDatePickerToolBar(dateTextField: enddateTextField)
        setDatePickerToolBar(dateTextField: alertdateTextField)
    }
    
    func setupSwitch() {
        alertNumTextField.isHidden = true
        instockSwitch.setOn(false, animated: true)
        instockSwitch.onTintColor = UIColor.darkGray
        instockSwitch.addTarget(self, action: #selector(setSwitchColor(sender:)), for: .valueChanged)
    }
    
    private func setDatePicker(sender: UITextField, action: Selector) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.locale = Locale(identifier: "zh_TW")
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: action, for: .valueChanged)
    }
    
    func loadingAnimation() {
        let animationView = LOTAnimationView(name: "3d_rotate_loading_animation")
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height / 2 - 35)
        animationView.contentMode = .scaleAspectFill
        let blankView = UIView()
        blankView.backgroundColor = UIColor.white
        blankView.frame = UIScreen.main.bounds
        view.addSubview(blankView)
        blankView.addSubview(animationView)
        animationView.loopAnimation = true
        animationView.play()
    }

}


extension AddItemViewController: ZHDropDownMenuDelegate {
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }
    
}


extension AddItemViewController: AddImageDelegate {

    func getAddImage(image: UIImage?) {
        self.newImage = image
    }

}
