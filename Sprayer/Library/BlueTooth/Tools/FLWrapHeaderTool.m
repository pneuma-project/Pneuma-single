//
//  FLWrapHeaderTool.m
//  rongXing
//
//  Created by cts on 16/8/10.
//  Copyright © 2016年 cts. All rights reserved.
//

#import "FLWrapHeaderTool.h"
#import "FLDrawDataTool.h"
#import "FLByteUtil.h"


enum
{
    IFP_ACT_GET			= 0x01,
    IFP_ACT_SET			= 0x02,
    IFP_ACT_DEL			= 0x03,
    IFP_ACT_ADD			= 0x04,
    IFP_ACT_ACK         = 0x1f,
}IFP_ACT_T;

@implementation FLWrapHeaderTool

+(NSDictionary *)headerDataToJson:(NSData *)data
{
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    
    NSInteger msg_id = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(1, 1)]];

    NSString *dev_id = [FLDrawDataTool hexStringFromData:[data subdataWithRange:NSMakeRange(2, 6)]];
    
    NSString *actionType = [FLDrawDataTool NSDataToHex:[FLDrawDataTool hexStringFromData:[data subdataWithRange:NSMakeRange(0, 1)]]];
    NSLog(@"actionType = %@",actionType);
    
    NSString *action;
    if ([actionType isEqualToString:@"01"]) {
        action = @"get";
    }else if ([actionType isEqualToString:@"02"]){
        action = @"set";
    }else if ([actionType isEqualToString:@"03"]){
        action = @"del";
    }else if ([actionType isEqualToString:@"04"]){
        action = @"add";
    }else if ([actionType isEqualToString:@"1f"]){
        action = @"ack";
    }
    
    NSString *moduleStr = [FLDrawDataTool hexStringFromData:[data subdataWithRange:NSMakeRange(8, 1)]];
    NSString *module = [FLByteUtil NSStringToModuleString:moduleStr];
    
    [headerDict setObject:dev_id forKey:@"dev_id"];
    [headerDict setObject:action forKey:@"action"];
    [headerDict setObject:module forKey:@"module"];
    [headerDict setObject:[NSNumber numberWithInteger:msg_id] forKey:@"msg_id"];
    
    return headerDict;
}

//得到boby数据长度
+(NSInteger)getBobyLength:(NSData *)data
{
   // NSLog(@"----data %@",data);
    NSInteger bobyLength = [FLDrawDataTool NSDataToNSInteger:data];
    return bobyLength;
}


@end
