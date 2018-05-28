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

class TrashViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TrashCollectionViewCellDelegate {
    
    @IBOutlet weak var trashCollectionView: UICollectionView!
    @IBOutlet weak var changeGridBtn: UIButton!
    var trashItem: [ItemList]?
    var firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        trashCollectionView.delegate = self
        trashCollectionView.dataSource = self
        
        setNavBackground()
        
        registerCell()
        
        getTrashItem()
        
        changeGridBtn.isSelected = false
        changeGridBtn.setImage(#imageLiteral(resourceName: "nine-square").withRenderingMode(.alwaysTemplate), for: .normal)
        changeGridBtn.setImage(#imageLiteral(resourceName: "four-square").withRenderingMode(.alwaysTemplate), for: .selected)
        setupListGridView(num: 2)
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.title = "編輯"
        navigationItem.rightBarButtonItem?.customView?.snp.makeConstraints({ (make) in
            make.width.equalTo(24)
            make.height.equalTo(24)
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTrashItem()
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

//}


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




extension TrashViewController {
    
    func registerCell() {
        let upnib = UINib(nibName: String(describing: TrashCollectionViewCell.self), bundle: nil)
        trashCollectionView.register(upnib, forCellWithReuseIdentifier: String(describing: TrashCollectionViewCell.self))
    }
    
    func getTrashItem() {
        if let tabbarVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController {
            self.trashItem = tabbarVC.trashItem
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trashList = self.trashItem else { return 0 }
        
        if trashList.count == 0 {
            let fullScreenSize = UIScreen.main.bounds
            let imageView = UIImageView(image: #imageLiteral(resourceName: "itemKeeper_icon_v01 -01-2"))
            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            imageView.center = CGPoint(
                x: fullScreenSize.width * 0.5,
                y: fullScreenSize.height * 0.3 + 44)
            let placeholderView = UIView()
            placeholderView.addSubview(imageView)
            collectionView.backgroundView = placeholderView
        } else {
            collectionView.backgroundView?.isHidden = true
        }
        return trashList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: TrashCollectionViewCell.self),
                for: indexPath as IndexPath
                ) as? TrashCollectionViewCell
        else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? TrashCollectionViewCell,
              let trashList = self.trashItem
        else { return }
        
        cell.deleteBtnVisualEffectView.isHidden = !isEditing
        cell.trashImageView.sd_setImage(with: URL(string: trashList[indexPath.row].imageURL))
        cell.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let controller = UIStoryboard.itemDetailStoryboard().instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
        guard let trashList = self.trashItem else { return }
        controller.list = trashList[indexPath.row]
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
        if let indexPath = trashCollectionView.indexPath(for: cell), let trashList = self.trashItem {
            var trash: [ItemList] = []
            trash = trashList
            trash.remove(at: indexPath.item)
            self.trashItem = trash
            self.trashCollectionView.performBatchUpdates({
                self.trashCollectionView.deleteItems(at: [indexPath])
            }, completion: nil)
            firebaseManager.deleteData(index: indexPath.item, itemList: trashList[indexPath.row], updateDeleteInfo: {}, popView: {})
            trashCollectionView.reloadData()
        }
    }
    
}
