//
//  FLDrawDataTool.h
//  rongXing
///Users/cts/Desktop/alin/tool/tools(2).h/Users/cts/Documents
//  Created by cts on 16/8/10.
//  Copyright © 2016年 cts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLDrawDataTool : NSObject

//data ---> string
+(NSString *)NSDataToNSString:(NSData *)data;

//data --->nsinteger
+(NSInteger)NSDataToNSInteger:(NSData *)data;

//16进制 --->二进制
+(NSString *)NSDataToHex:(NSString *)hex;

+(NSString *)hexStringFromData:(NSData*)data;

+(NSString *)ToHex:(long long int)tmpid;

+(NSData *)longToNSData:(long long)data;

@end
