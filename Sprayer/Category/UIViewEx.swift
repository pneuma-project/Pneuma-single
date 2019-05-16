//
//  UIViewEx.swift
//  Sheng
//
//  Created by DS on 2018/1/4.
//  Copyright © 2018年 First Cloud. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView类别
extension UIView{

    /// 设置视图部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    ///   - rect:  控件bounds
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat, rect:CGRect) {
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}
