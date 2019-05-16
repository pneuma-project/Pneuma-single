//
//  FLWrapJson.m
//  rongXing
//
//  Created by cts on 16/8/11.
//  Copyright © 2016年 cts. All rights reserved.
//

#import "FLWrapJson.h"
#import "FLWrapHeaderTool.h"
#import "FLWrapBobyTool.h"
#import "FLDrawDataTool.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
#import "UserDefaultsUtils.h"

@implementation FLWrapJson

+(NSDictionary *)dataToNsDict:(NSData *)data
{
    
    //NSData *newData = [data subdataWithRange:NSMakeRange(0, 11)];
    //NSLog(@"========%@",newData);
    //得到头部header数据
    NSDictionary *headDict = [FLWrapHeaderTool headerDataToJson:[data subdataWithRange:NSMakeRange(0, 11)]];
    
    NSInteger bobyLength = [FLWrapHeaderTool getBobyLength:[data subdataWithRange:NSMakeRange(9, 2)]];
    
    //解析后面的数据
    NSData *bobyData = [data subdataWithRange:NSMakeRange(11, bobyLength)];
    
    NSString *module = [headDict valueForKey:@"module"];
    
    NSMutableDictionary *allDict = [[NSMutableDictionary alloc] init];
    
    if ([module isEqualToString:@"login"]) {
        
        [allDict setObject:[FLWrapBobyTool loginModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];

    }else if ([module isEqualToString:@"profile"]){
        
        [allDict setObject:[FLWrapBobyTool profileModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"beat"]){
        
        [allDict setObject:[FLWrapBobyTool beatModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"update"]){
        
    }else if ([module isEqualToString:@"sync"]){
        
    }else if ([module isEqualToString:@"monitor"]){
        
        [allDict setObject:[FLWrapBobyTool monitorModToJson:bobyData] forKey:@"boby"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"stats"]){
        
        [allDict setObject:[FLWrapBobyTool statsModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"event"]){
        
        [allDict setObject:[FLWrapBobyTool eventModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"alarm"]){
        
        [allDict setObject:[FLWrapBobyTool alarmModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];

    }else if ([module isEqualToString:@"prescription"]){
        
    }else if ([module isEqualToString:@"comfort"]){
        
    }else if ([module isEqualToString:@"setting"]){
        
    }
    return allDict;
}

#pragma mark - 喷雾器蓝牙数据
//时间戳处理
+(NSString *)dataToNSStringTime:(NSData *)data
{
    NSString *timeStr = [FLDrawDataTool hexStringFromData:[data subdataWithRange:NSMakeRange(0, 6)]];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i = timeStr.length; i > 0; i -= 2) {
        [arr addObject:[timeStr substringWithRange:NSMakeRange(i-2, 2)]];
    }
    NSString *time = [arr componentsJoinedByString:@"-"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YY-MM-dd-HH-mm-ss"];
    NSDate *date = [formatter dateFromString:time];
    NSString *timeStamp = [[NSString alloc] initWithFormat:@"%ld",(long)date.timeIntervalSince1970];
    return timeStamp;
}

//喷雾器蓝牙数据入口
+(NSString *)dataToNSString:(NSData *)data
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<data.length; i++) {
        NSInteger yaliData = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0+i, 1)]];
        float yaliNum = (yaliData * 130)/60;
        yaliNum = [self yaliDataCalculate:yaliNum];
        [dataArr addObject:[NSString stringWithFormat:@"%.3f",yaliNum]];
    }
    NSString *yaliStr=[dataArr componentsJoinedByString:@","];
    return yaliStr;
}

//压力公式计算
+(float)yaliDataCalculate:(float)yaliData
{
    if (yaliData <= 0) {
        return 0;
    }else{
        float k1 = 0;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"k1flowValue"]) {
            k1 = 0;
        }else {
            NSString *value = [UserDefaultsUtils valueWithKey:@"k1flowValue"];
            k1 = [value floatValue];
        }
        float k2 = 8.67;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"k2flowValue"]) {
            k2 = 8.67;
        }else {
            NSString *value = [UserDefaultsUtils valueWithKey:@"k2flowValue"];
            k2 = [value floatValue];
        }
        float rate = k1 + k2*sqrtf(yaliData);
        return rate;
    }
}

//数据总和
+(NSString *)dataSumToNSString:(NSData *)data
{
    float sum = 0;
    for (int i = 0; i<data.length; i++) {
        NSInteger yaliData = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0+i, 1)]];
        float yaliNum = (yaliData * 130)/60;
        yaliNum = [self yaliDataCalculate:yaliData];
        sum += yaliData;
    }
    return [NSString stringWithFormat:@"%.3f",sum/600.0];
}

//BCD编码
+(NSData *)bcdCodeString:(NSString *)bcdstr
{
    int leng = (int)bcdstr.length/2;
    if (bcdstr.length%2 == 1) //判断奇偶数
    {
        leng +=1;
    }
    Byte bbte[leng];
    for (int i = 0; i<leng-1; i++)
    {
        bbte[i] = (int)strtoul([[bcdstr substringWithRange:NSMakeRange(i*2, 2)]UTF8String], 0, 16);
    }
    if (bcdstr.length%2 == 1)
    {
        bbte[leng-1] = (int)strtoul([[bcdstr substringWithRange:NSMakeRange((leng - 1)*2, 1)]UTF8String], 0, 16) *16;
    }else
    {
        bbte[leng-1] = (int)strtoul([[bcdstr substringWithRange:NSMakeRange((leng - 1)*2, 2)]UTF8String], 0, 16);
    }
    NSData *de = [[NSData alloc]initWithBytes:bbte length:leng];
    return de;
}


#pragma mark ---- 获取用户ID和名称
+(NSArray *)requireUserIdFromDb
{
    NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
    if (arr.count!=0) {
        for (AddPatientInfoModel * model in arr) {
            if (model.isSelect == 1) {
                return @[[NSString stringWithFormat:@"%d",model.userId],model.name];
            }
        }
    }
    return nil;
}

//获取药品名称
+(NSString *)getMedicineNameToInt:(NSData *)data
{
    NSInteger type = [FLDrawDataTool NSDataToNSInteger:data];
    if (type == 1 || type == 3) { //Albutero
        return @"Albuterol sulfate";
    }else if (type == 2 || type == 4) { //Tiotropium
        return @"Tiotropium bromide";
    }else if (type == 5 || type == 0) {  //无药瓶
        return @"No cartridge";
    }
    return @"";
}

//获取药品信息
+(NSString *)getMedicineInfo:(NSData *)data AndDrugInjectionTime:(NSData *)data1 AndDrugExpirationTime:(NSData *)data2 AndDrugOpeningTime:(NSData *)data3 AndVolatilizationTime:(NSData *)data4
{
    NSInteger type = [FLDrawDataTool NSDataToNSInteger:data];
    NSString *timeStamp1 = [NSString stringWithFormat:@"%ld",(long)[FLDrawDataTool NSDataToNSInteger:data1]];
    NSString *timeStamp2 = [NSString stringWithFormat:@"%ld",(long)[FLDrawDataTool NSDataToNSInteger:data2]];
    NSString *timeStamp3 = [NSString stringWithFormat:@"%ld",(long)[FLDrawDataTool NSDataToNSInteger:data3]];
    NSInteger volatilizationTime = [FLDrawDataTool NSDataToNSInteger:data4];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:[timeStamp1 doubleValue]];
    NSString * confromTimespStr1 = [formatter stringFromDate:confromTimesp1];
    NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:[timeStamp2 doubleValue]];
    NSString * confromTimespStr2 = [formatter stringFromDate:confromTimesp2];
    NSDate *confromTimesp3 = [NSDate dateWithTimeIntervalSince1970:[timeStamp3 doubleValue]];
    NSString * confromTimespStr3 = [formatter stringFromDate:confromTimesp3];
    if (type == 1) { //Albutero
        return [NSString stringWithFormat: @"Drug: Albuterol sulfate\nDose: 108 mcg (equivalent to 90 mcg albuterol base)\nLot #:  231-148-321\nFill date: %@\nExpiration date: %@\nData of first use: %@\nTotal evaporation time: %lds",confromTimespStr1,confromTimespStr2,confromTimespStr3,(long)volatilizationTime];
    }else if (type == 2) { //Tiotropium
        return [NSString stringWithFormat: @"Drug: Tiotropium bromide\nDose: 2.5 mcg\nLot #: 232-147-112\nFill date: %@\nExpiration date: %@\nData of first use: %@\nTotal evaporation time: %lds",confromTimespStr1,confromTimespStr2,confromTimespStr3,(long)volatilizationTime];
    }else if (type == 3) {
        return [NSString stringWithFormat: @"Drug: Albuterol sulfate\nDose: 108 mcg (equivalent to 90 mcg albuterol base)\nLot #:  231-148-323\nFill date: %@\nExpiration date: %@\nData of first use: %@\nTotal evaporation time: %lds",confromTimespStr1,confromTimespStr2,confromTimespStr3,(long)volatilizationTime];
    }else if (type == 4) {
        return [NSString stringWithFormat: @"Drug: Tiotropium bromide\nDose: 2.5 mcg\nLot #: 232-147-114\nFill date: %@\nExpiration date: %@\nData of first use: %@\nTotal evaporation time: %lds",confromTimespStr1,confromTimespStr2,confromTimespStr3,(long)volatilizationTime];
    }else if (type == 5 || type == 0) {  //无药瓶
        return @"No cartridge";
    }
    return @"";
}

@end
