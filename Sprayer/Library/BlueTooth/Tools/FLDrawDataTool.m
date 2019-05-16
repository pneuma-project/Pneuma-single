//
//  FLDrawDataTool.m
//  rongXing
//
//  Created by cts on 16/8/10.
//  Copyright © 2016年 cts. All rights reserved.
//

#import "FLDrawDataTool.h"

@implementation FLDrawDataTool

//NSData --- > NSString
+(NSString *)NSDataToNSString:(NSData *)data
{
    NSLog(@"------%@",data);
    //int outesape = 0;
    Byte *bytes = (Byte *)[data bytes];
    
    NSData *targetData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)+2];
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    return [[NSString alloc] initWithData:targetData encoding:encoding];
}

//NSData --- > NSInteger
+(NSInteger)NSDataToNSInteger:(NSData *)data
{
    //Byte *bytes = (Byte *)[data bytes];
    NSString *dataStr = [NSString stringWithFormat:@"%@",[self hexStringFromData:data]];
    NSString *temp = [NSString stringWithFormat:@"%lu",strtoul([dataStr UTF8String], 0, 16)];
    NSInteger tmp_sData = [temp integerValue];
    return tmp_sData;
}

//取出16进制的两个字节转换成二进制，取二进制的后5位转换成16进制
+(NSString *)NSDataToHex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"a"];
    
    [hexDic setObject:@"1011" forKey:@"b"];
    
    [hexDic setObject:@"1100" forKey:@"c"];
    
    [hexDic setObject:@"1101" forKey:@"d"];
    
    [hexDic setObject:@"1110" forKey:@"e"];
    
    [hexDic setObject:@"1111" forKey:@"f"];
    
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
        
        binaryString = [NSMutableString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    //NSLog(@"转化后的二进制为:%@",binaryString);
    NSString *bringStr = [binaryString substringFromIndex:binaryString.length - 5];
    
    bringStr = [NSString stringWithFormat:@"000%@",bringStr];
    
    NSMutableString *binaryStr = [[NSMutableString alloc] init];
    for (int i=0; i<bringStr.length; i+=4) {
        NSString *subStr = [bringStr substringWithRange:NSMakeRange(i, 4)];
        int index = 0;
        for (NSString *str in hexDic.allValues) {
            index ++;
            if ([subStr isEqualToString:str]) {
                [binaryStr appendString:hexDic.allKeys[index-1]];
                break;
            }
        }
    }
    return binaryStr;
}

//将NSData中的<>去掉
+(NSString *)hexStringFromData:(NSData*)data
{
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}

//将十进制转化为十六进制
+(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

#pragma mark - long long转NSData
+ (NSData *)longToNSData:(long long)data
{
    long long datatemplength = CFSwapInt64BigToHost(data);  //大小端不一样，需要转化
    NSData *temdata = [NSData dataWithBytes: &datatemplength length: sizeof(datatemplength)];
    Byte *bytes = (Byte *)[temdata bytes];
    Byte newByte[temdata.length-4];
    for (NSInteger i = 0; i < temdata.length-4; i++) {
        newByte[i] = bytes[i+4];
    }
    NSData *newData = [NSData dataWithBytes:newByte
                                     length:sizeof(newByte)];
    return newData;
}
@end
