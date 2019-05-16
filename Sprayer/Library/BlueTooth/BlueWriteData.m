//
//  BlueWriteData.m
//  Sprayer
//
//  Created by FangLin on 17/3/22.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "BlueWriteData.h"
#import "FLWrapJson.h"
#import "FLWrapJson.h"
#import "FLDrawDataTool.h"

@implementation BlueWriteData

//上电信息
+(void)bleConfigWithData:(NSData *)data
{
    Byte dataByte[8];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x01;//类型
    dataByte[2] = 0x04;//长度
//    NSString *userId = [FLWrapJson requireUserIdFromDb][0];
//    dataByte[3] = [self intHexByte:[userId intValue]];//用户ID
    Byte *timeByte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        dataByte[3+i] = timeByte[i];
    }
    dataByte[7] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"newdata == %@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

//查询当前药品信息
+(void)inquireCurrentDrugInfo:(NSData *)data
{
    Byte dataByte[8];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x05;//类型
    dataByte[2] = 0x04;//长度
//    NSString *userId = [FLWrapJson requireUserIdFromDb][0];
//    dataByte[3] = [self intHexByte:[userId intValue]];//用户ID
    Byte *timeByte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        dataByte[3+i] = timeByte[i];
    }
    dataByte[7] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"newdata == %@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

//开始训练
+(void)startTrainData:(NSData *)data
{
    Byte dataByte[8];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x02;//类型
    dataByte[2] = 0x04;//长度
//    NSString *userId = [FLWrapJson requireUserIdFromDb][0];
//    dataByte[3] = [self intHexByte:[userId intValue]];//用户ID
    Byte *timeByte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        dataByte[3+i] = timeByte[i];
    }
    dataByte[7] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"newdata === %@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

//结束训练
+(void)stopTrainData:(NSData *)data
{
    Byte dataByte[8];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x03;//类型
    dataByte[2] = 0x04;//长度
//    NSString *userId = [FLWrapJson requireUserIdFromDb][0];
//    dataByte[3] = [self intHexByte:[userId intValue]];//用户ID
    Byte *timeByte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        dataByte[3+i] = timeByte[i];
    }
    dataByte[7] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"newdata == %@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

//实时监测
+(void)sparyData:(NSData *)data
{
    Byte dataByte[8];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x04;//类型
    dataByte[2] = 0x04;//长度
//    NSString *userId = [FLWrapJson requireUserIdFromDb][0];
//    dataByte[3] = [self intHexByte:[userId intValue]];//用户ID
    Byte *timeByte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        dataByte[3+i] = timeByte[i];
    }
    dataByte[7] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"newdata == %@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

//历史确认码
+(void)confirmCodeHistoryData
{
    Byte dataByte[8];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x0B;//类型
    dataByte[2] = 0x04;//长度
    long long time = [DisplayUtils getNowTimestamp];
    NSData *timeData = [FLDrawDataTool longToNSData:time];
    Byte *timeByte = (Byte *)[timeData bytes];
    for (int i = 0; i<[timeData length]; i++) {
        dataByte[3+i] = timeByte[i];
    }
    dataByte[7] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"确定码:---%@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

//实时数据确认码
+(void)confirmCodePresentData
{
    Byte dataByte[8];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x0A;//类型
    dataByte[2] = 0x04;//长度
    long long time = [DisplayUtils getNowTimestamp];
    NSData *timeData = [FLDrawDataTool longToNSData:time];
    Byte *timeByte = (Byte *)[timeData bytes];
    for (int i = 0; i<[timeData length]; i++) {
        dataByte[3+i] = timeByte[i];
    }
    dataByte[7] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"确定码:---%@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(Byte)intHexByte:(int)userId
{
    Byte newByte[1];
    switch (userId) {
        case 1:
            newByte[0] = 0x01;
            break;
        case 2:
            newByte[0] = 0x02;
            break;
        case 3:
            newByte[0] = 0x03;
            break;
        case 4:
            newByte[0] = 0x04;
            break;
        case 5:
            newByte[0] = 0x05;
            break;
        default:
            break;
    }
    return newByte[0];
}


@end
