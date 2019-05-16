//
//  FLWrapHeaderTool.h
//  rongXing
//
//  Created by cts on 16/8/10.
//  Copyright © 2016年 cts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLWrapHeaderTool : NSObject

+(NSDictionary *)headerDataToJson:(NSData *)data;

+(NSInteger)getBobyLength:(NSData *)data;


@end
