//
//  FLWrapBobyTool.m
//  rongXing
//
//  Created by cts on 16/8/10.
//  Copyright © 2016年 cts. All rights reserved.
//

#import "FLWrapBobyTool.h"
#import "FLWrapHeaderTool.h"
#import "FLDrawDataTool.h"


@implementation FLWrapBobyTool

+(NSDictionary *)loginModToJson:(NSData *)data
{
    NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
    
    NSInteger productionDate = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0, 4)]];
    
    NSInteger version = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(4, 4)]];
    
    NSString *model = [FLDrawDataTool NSDataToNSString:[data subdataWithRange:NSMakeRange(8, 32)]];
    
    [loginDict setObject:[NSString stringWithFormat:@"%ld",(long)productionDate] forKey:@"PRODUCTION_DATE"];
    [loginDict setObject:[NSString stringWithFormat:@"%ld",(long)version] forKey:@"VERSION"];
    [loginDict setObject:model forKey:@"MODEL"];
    
    return loginDict;
}

+(NSDictionary *)profileModToJson:(NSData *)data
{
    NSMutableDictionary *profileDict = [[NSMutableDictionary alloc] init];
    
    NSInteger result_code = [FLDrawDataTool NSDataToNSInteger:data];
    
    [profileDict setObject:@(result_code) forKey:@"result_code"];
    
    return profileDict;
}

+(NSDictionary *)beatModToJson:(NSData *)data
{
    NSMutableDictionary *beatDict = [[NSMutableDictionary alloc] init];
    
    NSInteger beatCount = [FLDrawDataTool NSDataToNSInteger:data];
    
    [beatDict setObject:[NSString stringWithFormat:@"%ld",(long)beatCount] forKey:@"beat_count"];

    return beatDict;
}

+(NSDictionary *)statsModToJson:(NSData *)data
{
    NSMutableDictionary *statsDcit = [[NSMutableDictionary alloc] init];
    
    NSInteger ventid = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0, 1)]];
    NSInteger timestamp = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(1, 4)]];
    NSInteger usage = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(5, 4)]];
    NSInteger usage_humid = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(9, 4)]];
    NSInteger timePB = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(13, 4)]];
    NSInteger AHI = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(17, 2)]];
    NSInteger OAI = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(19, 2)]];
    NSInteger CAI = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(21, 2)]];
    NSInteger AI = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(23, 2)]];
    NSInteger HI = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(25, 2)]];
    NSInteger RERA = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(27, 2)]];
    NSInteger SNI = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(29, 2)]];
    NSInteger breath_count = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(31, 4)]];
    NSInteger oneself_breath_count = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(35, 4)]];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)ventid] forKey:@"ventid"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)timestamp] forKey:@"timestamp"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)usage] forKey:@"usage"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)usage_humid] forKey:@"usage_humid"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)timePB] forKey:@"TIMEPB"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)AHI] forKey:@"AHI"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)OAI] forKey:@"OAI"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)CAI] forKey:@"CAI"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)AI] forKey:@"AI"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)HI] forKey:@"HI"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)RERA] forKey:@"RERA"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)SNI] forKey:@"SNI"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)breath_count] forKey:@"BREATH_COUNT"];
    [statsDcit setObject:[NSString stringWithFormat:@"%ld",(long)oneself_breath_count] forKey:@"ONESELF_BREATH_COUNT"];

    return statsDcit;
}

+(NSDictionary *)alarmModToJson:(NSData *)data
{
    NSMutableDictionary *alarmDict = [[NSMutableDictionary alloc] init];
    
    NSString *mode;
    NSInteger modeNum = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0, 1)]];
    if (modeNum == 0) {
        mode = @"HISTORY";
    }else if (modeNum == 1){
        mode = @"REAL";
    }
    
    NSMutableArray *alarm_list_arr = [[NSMutableArray alloc] init];
    //警报次数
    NSInteger alarmNum = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(1, 1)]];
    for (int i = 0; i<alarmNum; i++) {
        
        NSData *alarm_list_data = [data subdataWithRange:NSMakeRange(2, data.length - 2)];
        NSInteger oneLength = alarm_list_data.length / alarmNum;
        
        NSInteger ventid = [FLDrawDataTool NSDataToNSInteger:[alarm_list_data subdataWithRange:NSMakeRange(i*oneLength, 1)]];
        NSInteger alarm_id = [FLDrawDataTool NSDataToNSInteger:[alarm_list_data subdataWithRange:NSMakeRange(i*oneLength+1, 1)]];
        NSInteger grade = [FLDrawDataTool NSDataToNSInteger:[alarm_list_data subdataWithRange:NSMakeRange(i*oneLength+2, 1)]];
        NSInteger timestamp = [FLDrawDataTool NSDataToNSInteger:[alarm_list_data subdataWithRange:NSMakeRange(i*oneLength+3, 4)]];
        NSInteger duration = [FLDrawDataTool NSDataToNSInteger:[alarm_list_data subdataWithRange:NSMakeRange(i*oneLength+7, 4)]];
        
        //[alarm_list_dict setObject:ventid forKey:@"ventid"];
        char buf[1000] = {0};
        buf[0] = 0;
        sprintf(buf, "{DURATION=%ld,timestamp=%ld,ventid=%ld,GRADE=%ld,ALARM_ID=%ld}",(long)duration,timestamp,ventid,grade,alarm_id);
        NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
        
        [alarm_list_arr addObject:bufStr];
        
     }
    [alarmDict setObject:mode forKey:@"mode"];
    [alarmDict setObject:alarm_list_arr forKey:@"alarm_lists"];
    return alarmDict;
}

+(NSDictionary *)eventModToJson:(NSData *)data
{
    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc] init];
    
    NSString *mode;
    NSInteger modeNum = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0, 1)]];
    if (modeNum == 0) {
        mode = @"HISTORY";
    }else if (modeNum == 1){
        mode = @"REAL";
    }
    
    NSMutableArray *event_list_Arr = [[NSMutableArray alloc] init];
    
    //警报次数
    NSInteger eventNum = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(1, 1)]];
    
    for (int i = 0; i<eventNum; i++) {
        NSData *event_list_data = [data subdataWithRange:NSMakeRange(2, data.length - 2)];
        NSInteger oneLength = event_list_data.length/eventNum;
        
        NSInteger ventid = [FLDrawDataTool NSDataToNSInteger:[event_list_data subdataWithRange:NSMakeRange(i*oneLength, 1)]];
        NSInteger event_id = [FLDrawDataTool NSDataToNSInteger:[event_list_data subdataWithRange:NSMakeRange(i*oneLength+1, 1)]];
        NSInteger timestamp = [FLDrawDataTool NSDataToNSInteger:[event_list_data subdataWithRange:NSMakeRange(i*oneLength+2, 4)]];
        NSInteger duration = [FLDrawDataTool NSDataToNSInteger:[event_list_data subdataWithRange:NSMakeRange(i*oneLength+6, 4)]];
        
        char buf[1000] = {0};
        buf[0] = 0;
        sprintf(buf, "{DURATION=%ld,timestamp=%ld,ventid=%ld,EVENT_ID=%ld,}",(long)duration,(long)timestamp,(long)ventid,(long)event_id);
        NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
        
        [event_list_Arr addObject:bufStr];
    }
    
    [eventDict setObject:mode forKey:@"mode"];
    [eventDict setObject:event_list_Arr forKey:@"event_lists"];
    
    return eventDict;
}


+(NSDictionary *)monitorModToJson:(NSData *)data
{
    NSMutableDictionary *monitorDict = [[NSMutableDictionary alloc] init];
    NSString *mode;
    NSInteger modeNum = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0, 1)]];
    if (modeNum == 0) {
        mode = @"HISTORY";
    }else if (modeNum == 1){
        mode = @"REAL";
    }
    
    NSInteger ventid = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(1, 1)]];
    
    NSInteger timestamp = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(2, 4)]];
    
    NSInteger rate = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(6, 2)]];
    
    NSInteger collect_num = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(8, 1)]];
    
    NSInteger channel_num = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(9, 1)]];
    
    NSMutableArray *monitor_listsArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<channel_num; i++) {
        NSMutableArray *channel_numArr = [[NSMutableArray alloc] init];
        
        for (int j = 0; j<collect_num; j++) {
            NSInteger monitor_num = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(i*41+1+j*2+10, 2)]];
            [channel_numArr addObject:[NSNumber numberWithInteger:monitor_num]];
        //[NSString stringWithFormat:@"%.1f",monitor_num/100.0]
        }
        //NSLog(@"%@",channel_numArr);
        NSInteger num = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(i*41+10, 1)]];
        char buf[1000] = {0};
        buf[0] = 0;
        if (num == 0) {
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{MONITOR_PRESS=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 1){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{IPAP=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 2){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{EPAP=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 3){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{VT=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 4){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{LEAK=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 5){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{MV=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 6){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{RR=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 7){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{TI=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 8){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{IE=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }else if (num == 9){
            for (int i = 0; i<channel_numArr.count; i++) {
                if (i == 0) {
                    sprintf(buf, "{SPO2=%ld",(long)[channel_numArr[0] integerValue]);
                }
                sprintf(buf, "%s,%ld",buf,(long)[channel_numArr[i] integerValue]);
            }
            sprintf(buf, "%s}",buf);
            NSString *bufStr = [[NSString alloc] initWithCString:(const char *)buf encoding:NSASCIIStringEncoding];
            [monitor_listsArr addObject:bufStr];
        }
        
    }
    
    [monitorDict setObject:mode forKey:@"mode"];
    [monitorDict setObject:[NSString stringWithFormat:@"%ld",(long)ventid] forKey:@"ventid"];
    [monitorDict setObject:[NSString stringWithFormat:@"%ld",(long)timestamp] forKey:@"timestamp"];
    [monitorDict setObject:[NSString stringWithFormat:@"%.1f",rate/100.0] forKey:@"rate"];
    [monitorDict setObject:[NSString stringWithFormat:@"%ld",(long)collect_num] forKey:@"collect_num"];
    [monitorDict setObject:monitor_listsArr forKey:@"monitor_lists"];
    return monitorDict;
}


@end
