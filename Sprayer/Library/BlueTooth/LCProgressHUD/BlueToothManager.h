//
//  BlueToothManager.h
//  BlueToothTest
//
//  Created by FangLin on 15/12/28.
//  Copyright © 2015年 FangLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "LCProgressHUD.h"
#import "Model.h"

@interface BlueToothManager : NSObject
<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager * _manager;
    CBPeripheral * _per;
    CBCharacteristic * _char;
    CBCharacteristic * _readChar;
    
    NSMutableArray * _peripheralList;
    NSData * _responseData;
    
}

/**
 *  创建BlueToothManager单例
 *
 *  @return BlueToothManager单例
 */
+(instancetype)getInstance;

/**
 *  开始扫描
 */
- (void)startScan;

/**
 *  停止扫描
 */
-(void)stopScan;

/**
 *  获得设备列表
 *
 *  @return 设备列表
 */
-(NSMutableArray *)getNameList;

/**
 *  连接设备
 *
 *  @param per 选择的设备
 */
-(void)connectPeripheralWith:(Model *)model;

/**
 *  打开通知
 */
-(void)openNotify;

/**
 *  关闭停止
 */
-(void)cancelNotify;

/**
 *  发送信息给蓝牙
 *
 *  @param str 遵循通信协议的设定
 */
- (void)sendDataWithString:(NSData *)data;

/**
 *  展示蓝牙返回的结果
 */
-(void)showResult;

/**
 *  断开连接
 *
 *  @param per 连接的per
 */
-(void)cancelPeripheralWith:(CBPeripheral *)per;


/**
 *  连接成功
 *
 *
 */
-(BOOL)connectSucceed;

 
@end
