//
//  DetailViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import RealmSwift
import ParallaxHeader
import SnapKit

protocol DetailViewControllerDelegate: class {

    func updateDeleteInfo(type: ListCategory.RawValue, index: Int, data: ItemList)

    func updateEditInfo(type: ListCategory.RawValue, index: Int, data: ItemList)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    weak var headerImageView: UIView?
    var ref: DatabaseReference!
    var list: ItemList?
    var index: Int?
    var deleteIsHidden = false
    weak var delegate: DetailViewControllerDelegate?
    let firebaseManager = FirebaseManager()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupDetailTableView()

        setupParallaxHeader()

        editBtn.setImage(#imageLiteral(resourceName: "pencil").withRenderingMode(.alwaysTemplate), for: .normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let destination = segue.destination as? EditViewController else { return }

        destination.delegate = self

        destination.list = list
    }

    func setupDetailTableView() {

        detailTableView.delegate = self

        detailTableView.dataSource = self

        registerCell()
    }

    func registerCell() {

        let upNib = UINib(nibName: "DetailUpTableViewCell", bundle: nil)

        detailTableView.register(upNib, forCellReuseIdentifier: "DetailUpTableCell")

        let downNib = UINib(nibName: "DetailDownTableViewCell", bundle: nil)

        detailTableView.register(downNib, forCellReuseIdentifier: "DetailDownTableCell")
    }

    @IBAction func editAction(_ sender: UIButton) {

        performSegue(withIdentifier: "ShowEditItem", sender: self)
    }

    // MARK: - DELETE ITEM FROM DATABASE AND STORAGE -
    @objc func deleteItem() {

        let alertController = UIAlertController(title: nil, message: "確定要刪除嗎？", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        let okAction = UIAlertAction(title: "刪除", style: .destructive) { _ in

            if let index = self.index, let itemList = self.list {

                self.firebaseManager.deleteData(index: index, itemList: itemList, updateDeleteInfo: { [weak self] in

                    // MARK: DELETE IN Realm
                    do {

                        let realm = try Realm()

                        let createString = itemList.createDate

                        let order = realm.objects(ItemInfoObject.self).filter("createDate = %@", createString)

                        try realm.write {

                            realm.delete(order)
                        }

                    } catch let error as NSError {

                        print(error)
                    }

                    self?.delegate?.updateDeleteInfo(type: itemList.category, index: index, data: itemList)

                }, popView: {

                    self.navigationController?.popViewController(animated: true)
                })
            }
        }

        alertController.addAction(cancelAction)

        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: private
    private func setupParallaxHeader() {

        guard let detailList = list else { return }

        let imageView = UIImageView()

        imageView.sd_setImage(with: URL(string: detailList.imageURL))

        imageView.contentMode = .scaleAspectFill

        //setup blur vibrant view
        imageView.blurView.setup(style: UIBlurEffectStyle.dark, alpha: 0).enable()

        headerImageView = imageView

        detailTableView.parallaxHeader.view = imageView

        detailTableView.parallaxHeader.height = 280

        detailTableView.parallaxHeader.minimumHeight = 0

        detailTableView.parallaxHeader.mode = .topFill

        detailTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in

            //update alpha of blur view on top of image view
            parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
        }

        // Label for vibrant text
        let vibrantLabel = UILabel()

        vibrantLabel.text = detailList.name

        vibrantLabel.font = UIFont.systemFont(ofSize: 30.0)

        vibrantLabel.sizeToFit()

        vibrantLabel.textAlignment = .center

        imageView.blurView.vibrancyContentView?.addSubview(vibrantLabel)

        //add constraints using SnapKit library
        vibrantLabel.snp.makeConstraints { make in

            make.edges.equalTo(imageView.blurView.vibrancyContentView!).inset(UIEdgeInsets(top: 20, left: 20, bottom: 150, right: 20))
        }
    }

    // MARK: actions
    @objc private func imageDidTap(gesture: UITapGestureRecognizer) {

        UIView.animate(withDuration: 0.3) {

            if self.detailTableView.parallaxHeader.height == 280 {

                self.detailTableView.parallaxHeader.height = 100

            } else {

                self.detailTableView.parallaxHeader.height = 280
            }
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let upcell = tableView.dequeueReusableCell(withIdentifier: "DetailUpTableCell", for: indexPath) as? DetailUpTableViewCell,

            let downcell = tableView.dequeueReusableCell(withIdentifier: "DetailDownTableCell", for: indexPath) as? DetailDownTableViewCell,

            let item = list else { return UITableViewCell() }

        upcell.selectionStyle = .none

        downcell.selectionStyle = .none

        if indexPath.row == 0 {

            let cell = upcell

            cell.setupUpCell(item: item)

            if deleteIsHidden == true {

                cell.deleteBtn.isHidden = true

            } else {

                cell.deleteBtn.isHidden = false

                cell.deleteBtn.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
            }

            return cell

        } else if indexPath.row == 1 {

            let cell = downcell

            cell.setupDownCell(item: item)

           return cell

        } else {

            return UITableViewCell()
        }
    }
}

extension DetailViewController: EditViewControllerDelegate {

    func passFromEdit(data: ItemList) {

        self.list = data

        self.detailTableView.reloadData()

        guard let index = self.index else { return }

        self.delegate?.updateEditInfo(type: data.category, index: index, data: data)
    }
}
