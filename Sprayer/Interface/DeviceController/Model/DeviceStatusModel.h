//
//  DeviceStatusModel.h
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "JSONModel.h"

@interface DeviceStatusModel : JSONModel

@property (nonatomic,copy)NSString *device;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)BOOL status;

@end
