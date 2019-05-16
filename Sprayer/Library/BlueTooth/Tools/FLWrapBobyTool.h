//
//  FLWrapBobyTool.h
//  rongXing
//
//  Created by cts on 16/8/10.
//  Copyright © 2016年 cts. All rights reserved.
//

#import "FLWrapHeaderTool.h"


@interface FLWrapBobyTool : FLWrapHeaderTool


+(NSDictionary *)loginModToJson:(NSData *)data;

+(NSDictionary *)profileModToJson:(NSData *)data;

+(NSDictionary *)beatModToJson:(NSData *)data;

+(NSDictionary *)statsModToJson:(NSData *)data;

+(NSDictionary *)alarmModToJson:(NSData *)data;

+(NSDictionary *)eventModToJson:(NSData *)data;

+(NSDictionary *)monitorModToJson:(NSData *)data;


@end
