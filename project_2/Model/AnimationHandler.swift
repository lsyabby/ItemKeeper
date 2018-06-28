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

    static func onetimeAnimation(animationName: String, view: UIView, rvView: @escaping (UIView) -> Void) {

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

    static func loadingAnimation(animationName: String, view: UIView, todoAction: @escaping () -> Void, rvView: @escaping (UIView) -> Void) {

        let animationView = LOTAnimationView(name: animationName)

        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)

        animationView.center = CGPoint(x: view.center.x, y: view.bounds.height / 2 - 35)

        animationView.contentMode = .scaleAspectFill

        let blankView = UIView()

        blankView.backgroundColor = UIColor.white

        blankView.frame = UIScreen.main.bounds

        blankView.addSubview(animationView)

        animationView.loopAnimation = true

        animationView.play(fromProgress: 0, toProgress: 1, withCompletion: nil)

        view.addSubview(blankView)

        todoAction()

        animationView.completionBlock = { (result: Bool) in ()

            rvView(blankView)
        }

        animationView.loopAnimation = false
    }
}
