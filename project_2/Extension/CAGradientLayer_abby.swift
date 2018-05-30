//
//  CAGradientLayer_abby.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/29.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    class func gradientLayerForBounds(bounds: CGRect, color1: UIColor, color2: UIColor, color3: UIColor) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        //        layer.startPoint = CGPoint(x: 0, y: 0.5)
        //        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }
    
}
