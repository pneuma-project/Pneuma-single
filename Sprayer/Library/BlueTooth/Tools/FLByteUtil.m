//
//  FLByteUtil.m
//  rongXing
//
//  Created by cts on 16/8/10.
//  Copyright © 2016年 cts. All rights reserved.
//

#import "FLByteUtil.h"

typedef NS_ENUM(NSInteger,IFP_MOD_T)
{
    IFP_MOD_LOGIN		= 11,
    IFP_MOD_PROFILE		= 12,
    IFP_MOD_BEAT		= 13,
    IFP_MOD_UPDATE		= 14,
    IFP_MOD_SYNC        = 15,
    IFP_MOD_MONITOR		= 21,
    IFP_MOD_STATS		= 22,
    IFP_MOD_EVENT		= 23,
    IFP_MOD_ALARM		= 24,
    IFP_MOD_PRESCRIPTION= 41,
    IFP_MOD_COMFORT		= 42,
    IFP_MOD_SETTING		= 43,
};


@implementation FLByteUtil

+(NSInteger)NSDataToActionNSInteget:(NSData *)data
{

    Byte *bytes = (Byte *)[data bytes];
    
    Byte newBytes[data.length];
    for (NSInteger i = 0; i<data.length; i++) {
        newBytes[i] = bytes[i];
    }
    
    unsigned int val;
    val = (bytes[0] << 24)&0xff000000;
    val = (bytes[1] << 16)&0x00ff0000;
    val = (bytes[2] << 8)&0x0000ff00;
    val = bytes[3]&0x000000ff;
    
    return val;
}

+(NSString *)NSStringToModuleString:(NSString *)moduleStr
{
    IFP_MOD_T type = [moduleStr integerValue];
    NSString *module;
    switch (type) {
        case IFP_MOD_LOGIN:
            module = @"login";
            break;
        case IFP_MOD_PROFILE:
            module = @"profile";
            break;
        case IFP_MOD_BEAT:
            module = @"beat";
            break;
        case IFP_MOD_UPDATE:
            module = @"update";
            break;
        case IFP_MOD_SYNC:
            module = @"sync";
            break;
        case IFP_MOD_MONITOR:
            module = @"monitor";
            break;
        case IFP_MOD_STATS:
            module = @"stats";
            break;
        case IFP_MOD_EVENT:
            module = @"event";
            break;
        case IFP_MOD_ALARM:
            module = @"alarm";
            break;
        case IFP_MOD_PRESCRIPTION:
            module = @"prescription";
            break;
        case IFP_MOD_COMFORT:
            module = @"comfort";
            break;
        case IFP_MOD_SETTING:
            module = @"setting";
            break;
        default:
            break;
    }
    
    return module;
}



@end
