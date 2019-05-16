//
//  Model.h
//  SY_CheShi
//
//  Created by FangLin on 16/1/26.
//  Copyright © 2016年 FangLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface Model : NSObject

@property (nonatomic, strong)CBPeripheral * peripheral;
@property (nonatomic, assign)int num;
@property (nonatomic, copy)NSString *macAddress;
@property (nonatomic, assign)BOOL isLinking;


@end
