//
//  IKNavigationController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class IKNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.arrangeGradientLayer()

        self.arrangeShadowLayer()
    }

    private func arrangeGradientLayer() {

        let layer = CAGradientLayer()

        layer.colors = [UIColor(red: 66/255.0, green: 95/255.0, blue: 87/255.0, alpha: 1.0).cgColor, UIColor(red: 100/255.0, green: 73/255.0, blue: 73/255.0, alpha: 1.0)]

        layer.startPoint = CGPoint(x: 0.0, y: 0.5)

        layer.endPoint = CGPoint(x: 1.0, y: 0.5)

        layer.bounds = CGRect(
            x: 0,
            y: 0,
            width: self.navigationBar.bounds.width,
            height: self.navigationBar.bounds.height
        )

        let image = UIImage.imageFromLayer(layer: layer)

        self.navigationBar.setBackgroundImage(image, for: .topAttached, barMetrics: .default)
    }

    private func arrangeShadowLayer() {

        self.navigationBar.layer.shadowColor = UIColor.black.cgColor

        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4 )

        self.navigationBar.layer.shadowRadius = 4.0

        self.navigationBar.layer.shadowOpacity = 0.25
    }
}

extension UIImage {

    static func imageFromLayer(layer: CALayer) -> UIImage? {

        UIGraphicsBeginImageContext(layer.frame.size)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        layer.render(in: context)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}
