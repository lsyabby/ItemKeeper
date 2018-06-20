//
//  ItemListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet weak var itemCategoryCollectionView: UICollectionView!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var categoryContainerView: UIView!
    var isSideMenuHidden = true
    let list: [String] = [ListCategory.total.rawValue, ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
    var itemListChildViewControllers: [UIViewController] = []
    var selectedBooling: [Bool] = []
    private var allCategoryVC: AllCategoryViewController!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupNavigation()

        setupSideMenu()

        setupItemCategoryCollectionView()
    }

    func setupItemCategoryCollectionView() {

        itemCategoryCollectionView.showsHorizontalScrollIndicator = false

        itemCategoryCollectionView.delegate = self

        itemCategoryCollectionView.dataSource = self

        let upnib = UINib(nibName: IKConstants.ItemCategoryRef.collectionViewNib, bundle: nil)

        itemCategoryCollectionView.register(upnib, forCellWithReuseIdentifier: IKConstants.ItemCategoryRef.collectionViewNib)
    }

    func setupSideMenu() {

        sideMenuConstraint.constant = IKConstants.ItemCategoryRef.smConstant

        sideMenuView.layer.shadowColor = IKConstants.ItemCategoryRef.smShadowColor

        sideMenuView.layer.shadowOpacity = IKConstants.ItemCategoryRef.smShadowOpacity

        sideMenuView.layer.shadowOffset = IKConstants.ItemCategoryRef.smShadowOffset

        self.view.bringSubview(toFront: sideMenuView)
    }

    func setupNavigation() {

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        setupNavigationBar()
    }

    private func setupNavigationBar() {

        navigationController?.navigationBar.tintColor = IKConstants.ItemCategoryRef.navTintColor

        navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)

        navigationController?.navigationBar.layer.shadowOffset = IKConstants.ItemCategoryRef.navShadowOffset

        navigationController?.navigationBar.layer.shadowOpacity = IKConstants.ItemCategoryRef.navShadowOpacity

        navigationController?.navigationBar.layer.shadowRadius = IKConstants.ItemCategoryRef.navShadowRadius

        navigationController?.navigationBar.layer.shadowColor = IKConstants.ItemCategoryRef.navShadowColor
    }

    @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {

        if isSideMenuHidden {

            gestureOnSlideMenu(isAble: false, constant: IKConstants.ItemCategoryRef.gestureConstant) { [weak self] in

                self?.sideMenuView.isUserInteractionEnabled = true

                let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self?.swipe))

                swipeLeft.direction = .left

                self?.sideMenuView.addGestureRecognizer(swipeLeft)
            }

        } else {

            gestureOnSlideMenu(isAble: true, constant: IKConstants.ItemCategoryRef.smConstant, gesture: {})
        }

        isSideMenuHidden = !isSideMenuHidden
    }

    private func gestureOnSlideMenu(isAble: Bool, constant: CGFloat, gesture: @escaping () -> Void) {

        itemCategoryCollectionView.isUserInteractionEnabled = isAble

        categoryContainerView.isUserInteractionEnabled = isAble

        sideMenuConstraint.constant = constant

        gesture()

        UIView.animate(withDuration: IKConstants.ItemCategoryRef.delay3) {

            self.view.layoutIfNeeded()
        }
    }

    @objc func swipe(recognizer: UISwipeGestureRecognizer) {

        let point = self.view.center

        if recognizer.direction == .left {

            if point.x >= IKConstants.ItemCategoryRef.gesturePointX {

                sideMenuConstraint.constant = IKConstants.ItemCategoryRef.smConstant

                UIView.animate(withDuration: IKConstants.ItemCategoryRef.delay3) {

                    self.view.layoutIfNeeded()
                }

                itemCategoryCollectionView.isUserInteractionEnabled = true

                categoryContainerView.isUserInteractionEnabled = true

                isSideMenuHidden = !isSideMenuHidden
            }
        }
    }

    private func imageLayerForGradientBackground() -> UIImage {

        var updatedFrame = navigationController?.navigationBar.bounds

        updatedFrame?.size.height += IKConstants.ItemCategoryRef.updatedFrameHeight

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

    func setupListGridView() {

        let screenSize = UIScreen.main.bounds

        if let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {

            categoryCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: itemCategoryCollectionView.frame.height)

            categoryCollectionViewFlowLayout.minimumInteritemSpacing = IKConstants.ItemCategoryRef.layoutItemSpacing

            categoryCollectionViewFlowLayout.minimumLineSpacing = IKConstants.ItemCategoryRef.layoutLineSpacing

            let categoryCollectionViewSectionInset = screenSize.width / 4

            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: IKConstants.ItemCategoryRef.layoutInset, left: categoryCollectionViewSectionInset, bottom: IKConstants.ItemCategoryRef.layoutInset, right: categoryCollectionViewSectionInset)
        }
    }
}

extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IKConstants.ItemCategoryRef.collectionViewNib, for: indexPath as IndexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }

        cell.categoryLabel.text = list[indexPath.row]

        setupListGridView()

        if selectedBooling == [] {

            selectedBooling.append(true)

            for _ in 1...list.count {

                selectedBooling.append(false)
            }
        }

        if selectedBooling[indexPath.item] {

            cell.categoryLabel.textColor = UIColor.white

        } else {

            cell.categoryLabel.textColor = UIColor.lightGray
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? AllCategoryViewController,

            segue.identifier == IKConstants.ItemCategoryRef.allcategoryVC {

            destination.loadViewIfNeeded()

            destination.delegate = self

            self.allCategoryVC = destination
        }
    }
}

extension ItemListViewController: AllCategoryViewControllerDelegate {

    func categoryDidScroll(_ scrollView: UIScrollView, xOffset: CGFloat) {

        guard let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width

        let scrollViewDistanceBetweenItemsCenter = UIScreen.main.bounds.width

        let offsetFactor = categoryDistanceBetweenItemsCenter / scrollViewDistanceBetweenItemsCenter

        let pageNum = Int(round(allCategoryVC.itemScrollView.contentOffset.x / allCategoryVC.itemScrollView.frame.size.width))

        for iii in 0...(selectedBooling.count - 1) {

            selectedBooling[iii] = false
        }

        selectedBooling[pageNum] = true

        itemCategoryCollectionView.reloadData()

        let categoryXOffset = xOffset

        itemCategoryCollectionView.bounds.origin.x = categoryXOffset * offsetFactor
    }
}

extension ItemListViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width

        let scrollViewDistanceBetweenItemsCenter = UIScreen.main.bounds.width

        let offsetFactor = categoryDistanceBetweenItemsCenter / scrollViewDistanceBetweenItemsCenter

        let pageNum = Int(round(allCategoryVC.itemScrollView.contentOffset.x / allCategoryVC.itemScrollView.frame.size.width))

        for iii in 0...(selectedBooling.count - 1) {

            selectedBooling[iii] = false
        }

        selectedBooling[pageNum] = true

        itemCategoryCollectionView.reloadData()

        let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x

        allCategoryVC.itemScrollView.bounds.origin.x = xOffset / offsetFactor
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth: Float = Float(UIScreen.main.bounds.width / 2 ) + 10

        let currentOffSet: Float = Float(scrollView.contentOffset.x)

        let targetOffSet: Float = Float(targetContentOffset.pointee.x)

        var newTargetOffset: Float = 0

        if targetOffSet > currentOffSet {

            newTargetOffset = ceilf(currentOffSet / pageWidth) * pageWidth

        } else {

            newTargetOffset = floorf(currentOffSet / pageWidth) * pageWidth
        }

        if newTargetOffset < 0 {

            newTargetOffset = 0

        } else if newTargetOffset > Float(scrollView.contentSize.width) {

            newTargetOffset = Float(scrollView.contentSize.width)
        }

        targetContentOffset.pointee.x = CGFloat(currentOffSet)

        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: 0), animated: true)
    }
}
