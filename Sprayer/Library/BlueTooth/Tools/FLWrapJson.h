//
//  FLWrapJson.h
//  rongXing
//
//  Created by cts on 16/8/11.
//  Copyright © 2016年 cts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLWrapJson : NSObject

//数据入口
+(NSDictionary *)dataToNsDict:(NSData *)data;

//时间戳处理
+(NSString *)dataToNSStringTime:(NSData *)data;

//喷雾器蓝牙数据入口
+(NSString *)dataToNSString:(NSData *)data;

//数据总和
+(NSString *)dataSumToNSString:(NSData *)data;

//BCD编码
+(NSData *)bcdCodeString:(NSString *)bcdstr;

//获取用户id
+(NSArray *)requireUserIdFromDb;

//获取药品名称
+(NSString *)getMedicineNameToInt:(NSData *)data;
//获取药品信息
+(NSString *)getMedicineInfo:(NSData *)data AndDrugInjectionTime:(NSData *)data1 AndDrugExpirationTime:(NSData *)data2 AndDrugOpeningTime:(NSData *)data3 AndVolatilizationTime:(NSData *)data4;

@end
