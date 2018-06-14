//
//  TrashViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/22.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import RealmSwift

class TrashViewController: UIViewController {

    @IBOutlet weak var trashCollectionView: UICollectionView!
    @IBOutlet weak var changeGridBtn: UIButton!
    var trashItem: [ItemList] = []
    let firebaseManager = FirebaseManager()

    let foodManager = FoodManager()
    let medicineManager = MedicineManager()
    let makeupManager = MakeupManager()
    let necessaryManager = NecessaryManager()
    let othersManager = OthersManager()
    let taskGroup = DispatchGroup()

    var foodItems: [ItemList] = []
    var medicineItems: [ItemList] = []
    var makeupItems: [ItemList] = []
    var necessaryItems: [ItemList] = []
    var othersItems: [ItemList] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        setupNavigationBar()

        setupTrashTableView()

        getCategoryData()

        changeGridBtn.isSelected = false

        changeGridBtn.setImage(#imageLiteral(resourceName: "nine-square").withRenderingMode(.alwaysTemplate), for: .normal)

        changeGridBtn.setImage(#imageLiteral(resourceName: "four-square").withRenderingMode(.alwaysTemplate), for: .selected)

        setupListGridView(num: 2)
    }

    override func viewWillAppear(_ animated: Bool) {

        getCategoryData()

        trashCollectionView.reloadData()
    }

    @IBAction func changeGridAction(_ sender: UIButton) {

        if sender.isSelected {

            setupListGridView(num: 2)

        } else {

            setupListGridView(num: 3)
        }

        sender.isSelected = !sender.isSelected
    }

    func setupNavigationBar() {

        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        setNavBackground()

        setupNavigationLeftBtn()
    }

    private func setupNavigationLeftBtn() {

        navigationItem.leftBarButtonItem = editButtonItem

        navigationItem.leftBarButtonItem?.title = "編輯"

        navigationItem.rightBarButtonItem?.customView?.snp.makeConstraints({ (make) in

            make.width.equalTo(24)

            make.height.equalTo(24)
        })
    }

    private func setNavBackground() {

        navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)

        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)

        navigationController?.navigationBar.layer.shadowOpacity = 0.3

        navigationController?.navigationBar.layer.shadowRadius = 5

        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    }

    private func imageLayerForGradientBackground() -> UIImage {

        var updatedFrame = navigationController?.navigationBar.bounds

        updatedFrame?.size.height += 20

        let layer = CAGradientLayer.gradientLayerForBounds(
            bounds: updatedFrame!,
            color1: UIColor.white,
            color2: UIColor.white
            )

        UIGraphicsBeginImageContext(layer.bounds.size)

        layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }

    func setupTrashTableView() {

        trashCollectionView.delegate = self

        trashCollectionView.dataSource = self

        registerCell()
    }

    func registerCell() {

        let upnib = UINib(nibName: String(describing: TrashCollectionViewCell.self), bundle: nil)

        trashCollectionView.register(upnib, forCellWithReuseIdentifier: String(describing: TrashCollectionViewCell.self))
    }

    private func getCategoryData() {

        taskGroup.enter()

        foodManager.getFoodItems(success: { [weak self] _, trashItems  in

            self?.foodItems = trashItems

            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)

            self?.taskGroup.leave()
        }

        taskGroup.enter()

        medicineManager.getMedicineItems(success: { [weak self] _, trashItems  in

            self?.medicineItems = trashItems

            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)

            self?.taskGroup.leave()
        }

        taskGroup.enter()

        makeupManager.getMakeupItems(success: { [weak self] _, trashItems  in

            self?.makeupItems = trashItems

            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)

            self?.taskGroup.leave()
        }

        taskGroup.enter()

        necessaryManager.getNecessaryItems(success: { [weak self] _, trashItems  in

            self?.necessaryItems = trashItems

            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)

            self?.taskGroup.leave()
        }

        taskGroup.enter()

        othersManager.getOthersItems(success: { [weak self] _, trashItems  in

            self?.othersItems = trashItems

            self?.taskGroup.leave()

        }) { [weak self] (error) in

            print(error)

            self?.taskGroup.leave()
        }

        taskGroup.notify(queue: .main) { [weak self] in

            guard let strongSelf = self else { return }

            strongSelf.trashItem = strongSelf.foodItems + strongSelf.medicineItems + strongSelf.makeupItems + strongSelf.necessaryItems + strongSelf.othersItems

            strongSelf.trashCollectionView.reloadData()
        }
    }
}

extension TrashViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard self.trashItem.count != 0 else {

            let fullScreenSize = UIScreen.main.bounds

            let imageView = UIImageView(image: #imageLiteral(resourceName: "itemKeeper_icon_v01 -01-2"))

            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

            imageView.center = CGPoint(
                x: fullScreenSize.width * 0.5,
                y: fullScreenSize.height * 0.3 + 44)

            let placeholderView = UIView()

            placeholderView.addSubview(imageView)

            collectionView.backgroundView = placeholderView

            return 0
        }

        collectionView.backgroundView?.isHidden = true

        return trashItem.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // TODO
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TrashCollectionViewCell.self), for: indexPath as IndexPath) as? TrashCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let cell = cell as? TrashCollectionViewCell else { return }

        cell.setupCell(item: trashItem[indexPath.row])

        cell.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let controller = UIStoryboard.itemDetailStoryboard().instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }

        controller.list = trashItem[indexPath.row]

        controller.index = indexPath.row

        show(controller, sender: nil)
    }

    private func setupListGridView(num: CGFloat) {

        let screenSize = UIScreen.main.bounds

        if let categoryCollectionViewFlowLayout = trashCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {

            categoryCollectionViewFlowLayout.itemSize = CGSize(width: (screenSize.width / num) - 2.5, height: (screenSize.width / num) - 2.5)

            categoryCollectionViewFlowLayout.minimumInteritemSpacing = 0

            categoryCollectionViewFlowLayout.minimumLineSpacing = 5

            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5)
        }
    }
}

extension TrashViewController: TrashCollectionViewCellDelegate {

    // MARK: - DELETE ITEM -
    override func setEditing(_ editing: Bool, animated: Bool) {

        super.setEditing(editing, animated: animated)

        if editing {

            self.editButtonItem.title = "完成"

        } else {

            self.editButtonItem.title = "編輯"
        }

        if let indexPaths = trashCollectionView?.indexPathsForVisibleItems {

            for indexPath in indexPaths {

                if let cell = trashCollectionView.cellForItem(at: indexPath) as? TrashCollectionViewCell {

                    cell.isEditing = editing
                }
            }
        }
    }

    func delete(cell: TrashCollectionViewCell) {

        if let indexPath = trashCollectionView.indexPath(for: cell) {

            var trash: [ItemList] = []

            trash = trashItem

            trash.remove(at: indexPath.item)

            self.trashItem = trash

            self.trashCollectionView.performBatchUpdates({

                self.trashCollectionView.deleteItems(at: [indexPath])

            }, completion: nil)

            firebaseManager.deleteData(index: indexPath.item, itemList: trashItem[indexPath.row], updateDeleteInfo: {}, popView: {})

            // MARK: DELETE IN Realm
            do {

                let realm = try Realm()

                let createString = trashItem[indexPath.row].createDate

                let order = realm.objects(ItemInfoObject.self).filter("createDate = %@", createString)

                try realm.write {

                    realm.delete(order)
                }

            } catch let error as NSError {

                print(error)
            }

            trashCollectionView.reloadData()
        }
    }
}
