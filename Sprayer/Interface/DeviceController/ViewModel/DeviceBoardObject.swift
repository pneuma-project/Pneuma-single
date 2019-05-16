//
//  DeviceBoardObject.swift
//  Sprayer
//
//  Created by fanglin on 2019/4/29.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class DeviceBoardObject: NSObject {
    private static var _sharedInstance:DeviceBoardObject?
    private override init() {
        
    }
    
    class func shared() -> DeviceBoardObject {
        guard let instance = _sharedInstance else {
            _sharedInstance = DeviceBoardObject()
            return _sharedInstance!
        }
        return instance
    }
    
    class func destory() {
        _sharedInstance = nil
    }
    
    lazy var blueView:BlueDeviceListView = {
        let queue = BlueDeviceListView()
        return queue
    }()
}
