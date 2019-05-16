//
//  Common.swift
//  Sheng
//
//  Created by DS on 2017/7/10.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
 宏定义
 */

import UIKit
// MARK: - 沙盒路径
let PATH_OF_CACHE = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let PATH_OF_DOCUMENT = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let PATH_OF_LIBRARY = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]


// MARK: - 尺寸相关
/// 屏幕分辨率
let Screen_Scale = UIScreen.main.scale

//屏幕宽高
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

/// 是否是刘海屏
let ISHairHead = (ISIPHONEX || ISIPHONEXR)
/// 是否是414的宽屏
let IS414SWidth = (ISIPHONE6p || ISIPHONEXR)

//状态栏高度 44.0 20.0
let STATUSBAR_HEIGHT:CGFloat = ISHairHead ? 44.0:20.0//UIApplication.shared.statusBarFrame.size.height
//系统导航条高度
let NavbarHeight:CGFloat = 44.0
/// 导航栏高度(导航条和状态栏总高度)
let NEWNAVHEIGHT = (STATUSBAR_HEIGHT + NavbarHeight)
// Tabbar高度
let TabbarHeight:CGFloat = 49.0 + IPHONEX_BH
// iPhone X底部多余的高度
let IPHONEX_BH:CGFloat = ISIPHONEX ? 34.0:0.0

/// 是否是指定尺寸的IPHONE
let ISIPHONE4 = (SCREEN_WIDTH == 320.0 && SCREEN_HEIGHT == 480.0)
let ISIPHONE5 = (SCREEN_WIDTH == 320.0 && SCREEN_HEIGHT == 568.0)
let ISIPHONE6 = (SCREEN_WIDTH == 375.0 && SCREEN_HEIGHT == 667.0)
let ISIPHONE6p = (SCREEN_WIDTH == 414.0 && SCREEN_HEIGHT == 736.0)
let ISIPHONEX = (SCREEN_WIDTH == 375.0 && SCREEN_HEIGHT == 812.0)  //X,XS
let ISIPHONEXR = (SCREEN_WIDTH == 414.0 && SCREEN_HEIGHT == 896.0)  //XR XSMAX

/// 比例
let IPONE_SCALE: Float = (ISIPHONE6p || ISIPHONEXR) ? (414.0/375.0):((ISIPHONE6||ISIPHONEX) ? 1.0:(320.0/375.0))  //手机屏宽的比例
let IPONE_SCALEH: Float = ISIPHONE4 ? (480.0/667.0) : (ISIPHONE5 ? (568.0/667.0) : (ISIPHONE6 ? 1.0 : (ISIPHONE6p ? (736.0/667.0) : (667.0/667.0))))

///相关主题色
let BRed_Color:UIColor = HEXCOLOR(h: 0xFF535E, alpha: 1) //贝语主题红

let Main_Color:UIColor = HEXCOLOR(h: 0x58C4AE, alpha: 1)

// MARK: - 版本号相关
/// App版本号
let APP_VERSION = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let BUNDLE_VERSION = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
/// 系统版本
let IOS_VERSION = UIDevice.current.systemVersion._bridgeToObjectiveC().doubleValue

// MARK: - 系统相关
//是否是真机
func ISIPHONE() -> Bool {
    #if TARGET_OS_IPHONE
        return true
    #endif
    #if TARGET_IPHONE_SIMULATOR
        return false
    #endif
    return false
}

// MARK: - 颜色相关
//根据十六进制数生成颜色 HEXCOLOR(h:0xe6e6e6,alpha:0.8)
func HEXCOLOR(h:Int,alpha:CGFloat) ->UIColor {
    return RGBCOLOR(r: CGFloat(((h)>>16) & 0xFF), g:   CGFloat(((h)>>8) & 0xFF), b:  CGFloat((h) & 0xFF),alpha: alpha)
}
//根据R,G,B生成颜色
func RGBCOLOR(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}
//随机色
func RANDOMCOLOR() -> UIColor {
    return RGBCOLOR(r: CGFloat(arc4random()%256), g: CGFloat(arc4random()%256), b: CGFloat(arc4random()%256),alpha: 1)
}

// MARK: - DEBUG模式下打印(Swift)
func Dprint(filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
        let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print("class:" + fileName + "  line:" + "\(rowCount)" + "\n")
    #endif
}
func Dprint<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
        let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print("class:" + fileName + "  line:" + "\(rowCount)" + "  \(message)" + "\n")
    #endif
}

