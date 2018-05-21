//
//  LoadingViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/21.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let animationView = LOTAnimationView(name: "3d_rotate_loading_animation")
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(animationView)
        
        animationView.play()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
