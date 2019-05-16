//
//  UIViewControllerEx.swift
//  Sheng
//
//  Created by fanglin on 2019/04/02.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
 UIViewController类扩展
 */

import Foundation
import UIKit

extension UIViewController{
    
    /// 使嵌入的横向滚动视图不影响控制器的拖返功能
    ///
    /// - Parameter scrollV: 嵌入的横向滚动视图,它也可能是UICollectionView或UITableView
    func notDistrubSlipBack(with scrollV:UIScrollView) {
        if let gestureArr = self.navigationController?.view.gestureRecognizers{
            for gesture in gestureArr {
                if (gesture as AnyObject).isKind(of:UIScreenEdgePanGestureRecognizer.self){
                    scrollV.panGestureRecognizer.require(toFail: gesture)
                }
            }
        }
    }
    
    /// 获取当前视图控制器
    ///
    /// - Returns: 当前视图控制器
    class func getCurrentViewCtrl()->UIViewController{
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for subWin in windows {
                if subWin.windowLevel == UIWindowLevelNormal {
                    window = subWin
                    break
                }
            }
        }
        if let frontView = window?.subviews.first{
            let nextResponder = frontView.next
            if nextResponder?.classForCoder == UIViewController.classForCoder(){
                return nextResponder as! UIViewController
            }else if nextResponder is UINavigationController {
                return (nextResponder as! UINavigationController).visibleViewController!
            }else if nextResponder is UITabBarController {
                let tabbarCtrl = nextResponder as! UITabBarController
                var tabbarSelCtrl = tabbarCtrl.selectedViewController
                if tabbarSelCtrl == nil{
                    tabbarSelCtrl = tabbarCtrl.viewControllers?.first
                }
                return tabbarSelCtrl!
            }
        }
        if window?.rootViewController is UINavigationController {
            return (window?.rootViewController as! UINavigationController).visibleViewController!
        }else if window?.rootViewController is UITabBarController {
            let tabbarCtrl = window?.rootViewController as! UITabBarController
            var tabbarSelCtrl = tabbarCtrl.selectedViewController
            if tabbarSelCtrl == nil{
                tabbarSelCtrl = tabbarCtrl.viewControllers?.first
            }
            if tabbarSelCtrl is UINavigationController {
                if let navRootCtrl = (tabbarSelCtrl as! UINavigationController).visibleViewController{
                    return navRootCtrl
                }
                return tabbarSelCtrl!
            }else{
                return tabbarSelCtrl!
            }
        }else{
            return (window?.rootViewController)!
        }
    }
}
