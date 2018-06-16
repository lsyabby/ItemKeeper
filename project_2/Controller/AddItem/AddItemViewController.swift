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

        setupNavigationBar()

        saveBtn.isHidden = false
        saveBtn.isUserInteractionEnabled = true

        setupOthersTextView()

        setupDropDownMenu()

        setupDatePicker()

        setupSwitch()

        addIdTextField.delegate = self

        numberTextField.delegate = self

        priceTextField.delegate = self

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

        let value = ["createdate": createdate, "imageURL": "", "name": name!, "id": itemid, "category": category!, "enddate": enddate!, "alertdate": alertdate, "instock": instock, "isInstock": isinstock, "alertInstock": alertinstock, "price": price, "others": others] as [String: Any]

        // animation for loading
        AnimationHandler.loadingAnimation(animationName: "3d_rotate_loading_animation", view: self.view) { [weak self] (_) in
            self?.saveBtn.isHidden = true

            self?.saveBtn.isUserInteractionEnabled = false

//            let url = URL(string: "https://images.pexels.com/photos/1055712/pexels-photo-1055712.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=350")
//            var imagePlaceholder = UIImage()
//            if let data = try? Data(contentsOf: url!) {
//                imagePlaceholder = UIImage(data: data)!
//            }
            let imagep: UIImage = #imageLiteral(resourceName: "itemKeeper_icon_v01 -01-2")

            let photo = self?.newImage ?? imagep

            self?.firebaseManager.addNewData(photo: photo, value: value) { [weak self] (info) in

                self?.setupLocalNotification(info: info)
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

    @objc func getScanResult(noti: Notification) {

        guard let pass = noti.userInfo!["PASS"] as? String else { return }

        self.addIdTextField.text = pass
    }

    func setupNavigationBar() {

        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.barTintColor = UIColor(red: 182/255.0, green: 222/255.0, blue: 215/255.0, alpha: 1.0)

        setNavBackground()
    }

    private func setNavBackground() {

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

        content.userInfo = ItemList.notiContentInfo(item: info, itemInfo: info)

        content.body = "有效期限到 \(info.endDate)"

        content.sound = UNNotificationSound.default()

        guard let imageData = NSData(contentsOf: URL(string: info.imageURL)!) else { return }

        guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "img.jpeg", data: imageData, options: nil) else { return }

        content.attachments = [attachment]

        let dateformatter: DateFormatter = DateFormatter()

        dateformatter.dateFormat = "yyyy - MM - dd"

        if info.alertDate != "不提醒" {

            let alertDate: Date = dateformatter.date(from: info.alertDate)!

            let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

            let components = gregorianCalendar.components([.year, .month, .day], from: alertDate)

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(identifier: info.createDate, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { (_) in

                print("build alertdate notificaion successful !!!")
            }

            // MARK: SAVE IN Realm
            do {

                let realm = try Realm()

                let order = ItemList.createRealm(info: info)

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

    @objc func donePressed(sender: UIBarButtonItem) {

        enddateTextField.resignFirstResponder()

        alertdateTextField.resignFirstResponder()
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

        DateHandler.setDatePickerToolBar(dateTextField: enddateTextField, view: self.view, btnAction: { () -> UIBarButtonItem in
            UIBarButtonItem(title: "確定", style: .done, target: self, action: #selector(self.donePressed(sender:)))
        })

        DateHandler.setDatePickerToolBar(dateTextField: alertdateTextField, view: self.view, btnAction: { () -> UIBarButtonItem in
            UIBarButtonItem(title: "確定", style: .done, target: self, action: #selector(self.donePressed(sender:)))
        })
    }

    func setupSwitch() {

        alertNumTextField.isHidden = true

        instockSwitch.setOn(false, animated: true)

        instockSwitch.onTintColor = UIColor.darkGray
    }

    private func setDatePicker(sender: UITextField, action: Selector) {

        let datePickerView: UIDatePicker = UIDatePicker()

        datePickerView.locale = Locale(identifier: "zh_TW")

        datePickerView.datePickerMode = .date

        sender.inputView = datePickerView

        datePickerView.addTarget(self, action: action, for: .valueChanged)
    }
}

extension AddItemViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard NSCharacterSet(charactersIn: "0123456789").isSuperset(of: NSCharacterSet(charactersIn: string) as CharacterSet) else {

            return false
        }

        return true
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
