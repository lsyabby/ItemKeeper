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


class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZHDropDownMenuDelegate, AddImageDelegate {

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
//        guard let photoVC = UIStoryboard.addItemStoryboard().instantiateViewController(withIdentifier: String(describing: AddImageViewController.self)) as? AddImageViewController else { return }
//
//        photoVC.addImageView.image = UIImage(named: "image_placeholder")
        addNameTextField.text = ""
        addIdTextField.text = ""
        categoryDropDownMenu.contentTextField.text = ""
        priceTextField.text = ""
        enddateTextField.text = ""
        numberTextField.text = ""
        instockSwitch.isOn = false
        othersTextView.text = ""
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
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
//            if granted {
//                print("允許")
//            } else {
//                print("不允許")
//            }
//        }
        
        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let createdate = String(Int(Date().timeIntervalSince1970))
        guard addNameTextField.text != "" else {
            addNameTextField.layer.cornerRadius = 5
            addNameTextField.layer.borderWidth = 1
        return addNameTextField.layer.borderColor = UIColor.red.cgColor }
        let name = addNameTextField.text
        let itemid = Int(addIdTextField.text!) ?? 0
        guard categoryDropDownMenu.contentTextField.text != "" else {
            categoryDropDownMenu.contentTextField.layer.cornerRadius = 5
            categoryDropDownMenu.contentTextField.layer.borderWidth = 1
            return categoryDropDownMenu.contentTextField.layer.borderColor = UIColor.red.cgColor }
        let category = categoryDropDownMenu.contentTextField.text
        let enddate = enddateTextField.text ?? "無期限"
        let alertdate = alertdateTextField.text ?? "不提醒"
        let instock = Int(numberTextField.text!) ?? 1
        let isinstock = instockSwitch.isOn
        let alertinstock = Int(alertNumTextField.text!) ?? 0
        let price = Int(priceTextField.text!) ?? 0
        let others = othersTextView.text ?? "無"
        
        let value = ["createdate": createdate, "imageURL": "", "name": name, "id": itemid, "category": category, "enddate": enddate, "alertdate": alertdate, "instock": instock, "isInstock": isinstock, "alertInstock": alertinstock, "price": price, "others": others] as [String : Any]
    
        // animation for loading
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
        
        saveBtn.isHidden = true
        saveBtn.isUserInteractionEnabled = false
        
        if let photo = self.newImage {
            let filename = String(Int(Date().timeIntervalSince1970))
            let storageRef = Storage.storage().reference().child("items/\(filename).png")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            if let uploadData = UIImageJPEGRepresentation(photo, 0.1) {
                storageRef.putData(uploadData, metadata: metadata, completion: { (_, error) in
                    if error != nil {
                        print("Error: \(String(describing: error?.localizedDescription))")
                    } else {
                        storageRef.downloadURL(completion: { (url, error) in
                            if error == nil {
                                if let downloadUrl = url {
                                    var tempData = value
                                    tempData["imageURL"] = downloadUrl.absoluteString
                                    if let tempCreateDate = tempData["createdate"] as? String,
                                        let tempImageURL = tempData["imageURL"] as? String,
                                            let tempName = tempData["name"] as? String,
                                        let tempID = tempData["id"] as? Int,
                                        let tempCategory = tempData["category"] as? ListCategory.RawValue,
                                        let tempEnddate = tempData["enddate"] as? String,
                                        let tempAlertdate = tempData["alertdate"] as? String,
                                        let tempInstock = tempData["instock"] as? Int,
                                        let tempIsInstock = tempData["isInstock"] as? Bool,
                                        let tempAlertInstock = tempData["alertInstock"] as? Int,
                                        let tempPrice = tempData["price"] as? Int,
                                        let tempOthers = tempData["others"] as? String {
                                        let info = ItemList(createDate: tempCreateDate, imageURL: tempImageURL, name: tempName, itemId: tempID, category: tempCategory, endDate: tempEnddate, alertDate: tempAlertdate, instock: tempInstock, isInstock: tempIsInstock, alertInstock: tempAlertInstock, price: tempPrice, others: tempOthers)
                                        self.ref.child("items/\(userId)").childByAutoId().setValue(tempData)
                                        
                                        let notificationName = Notification.Name("AddItem")
                                        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": info])
                                        
//                                        animationView.stop()
                                        
                                        DispatchQueue.main.async {
                                            AppDelegate.shared.switchToMainStoryBoard()
                                        }
                                        
                                        // MARK: - NOTIFICATION - send alert date
//                                        let content = UNMutableNotificationContent()
//                                        content.title = info.name
//                                        content.body = "有效期限到 \(info.endDate) 喔!!!"
//                                        content.badge = 1
//                                        content.sound = UNNotificationSound.default()
//                                        if let attachment = try? UNNotificationAttachment(identifier: info.createDate, url: URL(string: info.imageURL)!, options: nil) {
//                                            content.attachments = [attachment]
//                                        }
//                                        let dateformatter: DateFormatter = DateFormatter()
//                                        dateformatter.dateFormat = "yyyy - MM - dd"
//                                        let alertDate: Date = dateformatter.date(from: info.alertDate)!
//                                        let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//                                        let components = gregorianCalendar.components([.year, .month, .day], from: alertDate)
//                                        print("========= components ========")
//                                        print("\(components.year) \(components.month) \(components.day)")
//                                        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//                                        let request = UNNotificationRequest(identifier: info.createDate, content: content, trigger: trigger)
//                                        UNUserNotificationCenter.current().add(request) { (error) in
//                                            print("build alertdate notificaion successful !!!")
//                                        }

                                    }
                                }
                            } else {
                                print("Error: \(String(describing: error?.localizedDescription))")
                            }
                        })
                    }
                })
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
//            alertNumTextField.isHidden = false
            alertNumTextField.isHidden = true
        } else {
            alertNumTextField.isHidden = true
        }
    }
    
    
    
    
    func setNavBackground() {
        navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
        navigationController?.navigationBar.layer.shadowRadius = 5
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = navigationController?.navigationBar.bounds
        // take into account the status bar
        updatedFrame?.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(
            bounds: updatedFrame!,
            color1: UIColor(red: 244/255.0, green: 238/255.0, blue: 225/255.0, alpha: 1.0),
            //            UIColor(red: 100/255.0, green: 186/255.0, blue: 226/255.0, alpha: 1.0),
            color2: UIColor(red: 244/255.0, green: 238/255.0, blue: 225/255.0, alpha: 1.0),
            //            UIColor(red: 244/255.0, green: 218/255.0, blue: 222/255.0, alpha: 1.0),
            color3: UIColor(red: 244/255.0, green: 238/255.0, blue: 225/255.0, alpha: 1.0)
            //            UIColor(red: 182/255.0, green: 222/255.0, blue: 215/255.0, alpha: 1.0)
        )
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}


extension AddItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageVC = segue.destination as? AddImageViewController {
            imageVC.delegate = self
        }
    }
    
    func getAddImage(image: UIImage?) {
        self.newImage = image
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
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
    
}
