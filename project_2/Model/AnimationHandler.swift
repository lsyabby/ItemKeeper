//
//  AnimationHandler.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/15.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import UIKit
import Lottie

struct AnimationHandler {

    static func loadingAnimation(animationName: String, view: UIView, rvView: @escaping (UIView) -> Void) {

        let animationView = LOTAnimationView(name: animationName)

        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)

        animationView.center = CGPoint(x: view.center.x, y: view.bounds.height / 2 - 35)

        animationView.contentMode = .scaleAspectFill

        let blankView = UIView()

        blankView.backgroundColor = UIColor.white

        blankView.frame = UIScreen.main.bounds

        view.addSubview(blankView)

        blankView.addSubview(animationView)

        animationView.loopAnimation = false

        animationView.play { (_) in

            rvView(blankView)
        }
    }
}
