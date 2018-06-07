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

    let categoryVCs = [TotalViewController(), FoodViewController(), MedicineViewController(), MakeupViewController(), NecessaryViewController(), OthersViewController()]
    let list: [String] = [ListCategory.total.rawValue, ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
    var itemListChildViewControllers: [UIViewController] = []

    var selectIndex: Int?

    var pageNum: Int?

    var selectedBooling: [Bool] = []

    private var tttvc: AllCategoryViewController!

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

        let upnib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)

        itemCategoryCollectionView.register(upnib, forCellWithReuseIdentifier: "CategoryCollectionCell")

    }

    func setupSideMenu() {

        sideMenuConstraint.constant = -300

        sideMenuView.layer.shadowColor = UIColor.black.cgColor

        sideMenuView.layer.shadowOpacity = 0.3

        sideMenuView.layer.shadowOffset = CGSize(width: 5, height: 0)

        self.view.bringSubview(toFront: sideMenuView)

    }

    func setupNavigation() {

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        setupNavigationBar()

    }

    private func setupNavigationBar() {

        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0)

        navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)

        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)

        navigationController?.navigationBar.layer.shadowOpacity = 0.3

        navigationController?.navigationBar.layer.shadowRadius = 5

        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    }

    @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {

        if isSideMenuHidden {

            gestureOnSlideMenu(isAble: false, constant: 0) {

                self.sideMenuView.isUserInteractionEnabled = true

                let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))

                swipeLeft.direction = .left

                self.sideMenuView.addGestureRecognizer(swipeLeft)
            }

        } else {

            gestureOnSlideMenu(isAble: true, constant: -300, gesture: {})

        }
        isSideMenuHidden = !isSideMenuHidden
    }

    private func gestureOnSlideMenu(isAble: Bool, constant: CGFloat, gesture: @escaping () -> Void) {

        itemCategoryCollectionView.isUserInteractionEnabled = isAble

        categoryContainerView.isUserInteractionEnabled = isAble

        sideMenuConstraint.constant = constant

        gesture()

        UIView.animate(withDuration: 0.3) {

            self.view.layoutIfNeeded()

        }
    }

    @objc func swipe(recognizer: UISwipeGestureRecognizer) {
        let point = self.view.center
        if recognizer.direction == .left {
            if point.x >= 150 {
                sideMenuConstraint.constant = -300
                UIView.animate(withDuration: 0.3) {
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
        // take into account the status bar
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

    func setupListGridView() {
        let screenSize = UIScreen.main.bounds
        if let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            categoryCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: itemCategoryCollectionView.frame.height)
            categoryCollectionViewFlowLayout.minimumInteritemSpacing = 0
            categoryCollectionViewFlowLayout.minimumLineSpacing = 10
            let categoryCollectionViewSectionInset = screenSize.width / 4
            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: categoryCollectionViewSectionInset, bottom: 10, right: categoryCollectionViewSectionInset)
        }
    }

}

extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath as IndexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }

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

//        let itemNum = indexPath.item
//        itemListScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(itemNum), y: 0), animated: true)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.selectIndex = indexPath.item
        tttvc.categoryIndex = indexPath.item

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AllCategoryViewController,
            segue.identifier == "AllCategoryVC" {
            self.tttvc = destination
        }

    }
}

extension ItemListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width
//        let scrollViewDistanceBetweenItemsCenter = UIScreen.main.bounds.width
//        let offsetFactor = categoryDistanceBetweenItemsCenter / scrollViewDistanceBetweenItemsCenter
//
//        // test for color
//        let pageNum = Int(round(itemListScrollView.contentOffset.x / itemListScrollView.frame.size.width))

        for iii in 0...(selectedBooling.count - 1) {
            selectedBooling[iii] = false
        }

        guard let index = self.selectIndex else { return }

        selectedBooling[index] = true

        itemCategoryCollectionView.reloadData()

//    else if scrollView === itemListScrollView {
//            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
//            itemCategoryCollectionView.bounds.origin.x = xOffset * offsetFactor
//        }
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
