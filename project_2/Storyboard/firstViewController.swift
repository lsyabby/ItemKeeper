//
//  firstViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore
import SDWebImage

class FirstViewController: UIViewController {

//    @IBOutlet weak var upCollectionView: UICollectionView!
//    @IBOutlet weak var downCollectionView: UICollectionView!
//    var ref: DatabaseReference!
//    var items: [ItemList] = []
//    var categoryList: [String] = ["食品", "藥品", "美妝", "日用品", "其他"]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("1st view did load")
//        upCollectionView.delegate = self
//        upCollectionView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        print("1st view will appear")
    }

    override func viewDidAppear(_ animated: Bool) {
        print("1st view did appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }

//    override func viewDidLayoutSubviews() {
//        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
