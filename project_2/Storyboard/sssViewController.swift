//
//  sssViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class sssViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Sss", bundle: nil)
        
        let firstvc = storyboard.instantiateViewController(withIdentifier: "A") as! firstViewController
        let secondvc = storyboard.instantiateViewController(withIdentifier: "B") as! secondViewController
        let thirdvc = storyboard.instantiateViewController(withIdentifier: "C") as! thirdViewController
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        myScrollView.contentSize = CGSize(width: 3 * width, height: height)
        
        let vc = [firstvc, secondvc, thirdvc]
        
        var idx: Int = 0
        
        for v in vc {
            addChildViewController(v)
            let originX: CGFloat = CGFloat(idx) * width
            v.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
            myScrollView.addSubview(v.view)
            v.didMove(toParentViewController: self)
            idx += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
