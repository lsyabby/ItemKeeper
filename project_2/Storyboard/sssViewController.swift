//
//  sssViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class SssViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Sss", bundle: nil)
//        CategoryCollectionCell

//        guard let firstvc = storyboard.instantiateViewController(withIdentifier: "A") as? FirstViewController,
//            let secondvc = storyboard.instantiateViewController(withIdentifier: "B") as? SecondViewController,
//            let thirdvc = storyboard.instantiateViewController(withIdentifier: "C") as? ThirdViewController else { return }
//
//        let bounds = UIScreen.main.bounds
//        let width = bounds.size.width
//        let height = bounds.size.height
//
//        myScrollView.contentSize = CGSize(width: 3 * width, height: height)
//
//        let vcArray = [firstvc, secondvc, thirdvc]
//
//        var idx: Int = 0
//
//        for vvv in vcArray {
//            addChildViewController(vvv)
//            let originX: CGFloat = CGFloat(idx) * width
//            vvv.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
//            myScrollView.addSubview(vvv.view)
//            vvv.didMove(toParentViewController: self)
//            idx += 1
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
