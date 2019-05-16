//
//  BlueWriteData.h
//  Sprayer
//
//  Created by FangLin on 17/3/22.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueWriteData : NSObject

+(void)bleConfigWithData:(NSData *)data;

+(void)inquireCurrentDrugInfo:(NSData *)data;

+(void)startTrainData:(NSData *)data;

+(void)stopTrainData:(NSData *)data;

+(void)sparyData:(NSData *)data;

+(void)confirmCodeHistoryData;

+(void)confirmCodePresentData;

@end
