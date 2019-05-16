//
//  Utils.m
//  WineStore
//
//  Created by hexiao on 13-9-5.
//  Copyright (c) 2013年 hexiao. All rights reserved.
//

#import "DisplayUtils.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>


@implementation DisplayUtils

/**
 *  自定义cell线条
 *
 */
+(UIView *)customCellLine:(CGFloat)height
{
    UILabel *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, height-1, screen_width, 1)];
    lineView.backgroundColor = RGBColor(229, 230, 231, 1.0);
    return lineView;
}

/**
 *  计算字符串的宽度
 *
 */
+(CGSize)stringWithWidth:(NSString *)str withFont:(CGFloat)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}

/**
 * 渐变
 *
 */
+(CAGradientLayer *)gradientLayerColorOne:(UIColor *)Onecolor WithColorTwo:(UIColor *)TwoColor withHeight:(CGFloat)height
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)Onecolor.CGColor,(__bridge id)TwoColor.CGColor];
    gradientLayer.locations = @[@0.1,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, screen_width, height);
    return gradientLayer;
}

/**
 * 圆角
 * \param view 控件
 * \param size 圆角的大小
 * \return 圆角样式
 */
+(CAShapeLayer *)cornerRadiusGraph:(UIView *)view withSize:(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = view.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

/**
 * 显示文本
 * \param image 原始图
 * \param reSize 图片尺寸
 * \return 改变尺寸后的图
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

/**
 * 显示文本
 * \param title 文本
 * \param viewController 视图
 */
+ (void)alert:(NSString*)title viewController:(UIViewController*)viewController
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = title;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1.7f];
}

//通过md5进行简单的加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - 获取时间戳
//获取时间戳
//当前时间
+(NSString *)getTimestampData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd,YYYY"];
    NSDate *date = [NSDate date];
//    NSString *timestamp = [[NSString alloc] initWithFormat:@"%ld",(long)date.timeIntervalSince1970];
    NSString *timestamp = [formatter stringFromDate:date];
    return timestamp;
}

//当前时间戳
+(long long)getNowTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    long long timestamp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] longLongValue];
    return timestamp;
}

//获取当天12点的时间戳
+(NSString *)getTimeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    [gregorian setTimeZone:gmt];
    
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    
    [components setHour:12];
    
    [components setMinute:0];
    
    [components setSecond: 0];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    
    //NSString *timestamp = [formatter stringFromDate:date];
    NSString *timestamp = [[NSString alloc] initWithFormat:@"%ld",(long)newDate.timeIntervalSince1970];
    return timestamp;
}

//获取某一天的时间戳
+(NSString *)getDate:(NSString *)time
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    [gregorian setTimeZone:gmt];
    
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    
    [components setHour:12];
    
    [components setMinute:0];
    
    [components setSecond: 0];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    //NSString *timestamp = [formatter stringFromDate:date];
    NSString *timestamp = [[NSString alloc] initWithFormat:@"%ld",(long)newDate.timeIntervalSince1970];
    return timestamp;
}


//2016-08-24 12:00:00-----8月-24
+(NSString *)getTimeStampTime:(NSString *)timeDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//NSTimeZone* timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
  //  [formatter setTimeZone:timeZone];
    NSDate *dateTime = [formatter dateFromString:timeDate];
    
    NSDateFormatter *newForma = [[NSDateFormatter alloc] init];
    [newForma setDateFormat:@"MM/dd"];
    
    NSString *timestamp = [newForma stringFromDate:dateTime];
    return timestamp;
}

//2016-08-24 12:00:00-----1407260123
+(NSString *)getTimeStamp:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    NSString *timeStamp = [[NSString alloc] initWithFormat:@"%ld",(long)date.timeIntervalSince1970];
    return timeStamp;
}

+(NSString *)getTimeStampWeek
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ssmmHHddMMyy"]; ///小写yy,大写YY相差一年（有毒）
    NSDate *date = [NSDate date];
    NSString *timestamp = [formatter stringFromDate:date];
    return timestamp;
}

//获取星期几
+(NSString *)getTimestampDataWeek
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *conDate = [NSDate date];
    NSString *timestamp = [formatter stringFromDate:conDate];
    NSDate* inputDate = [formatter dateFromString:timestamp];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:inputDate];
    NSInteger week = [comps weekday];
    NSString *strWeek = [self getweek:week];
    
    NSLog(@"week is:%@",strWeek);
    
    return strWeek;
}

+(NSString*)getweek:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=@"07";
    }else if(week==2){
        weekStr=@"01";
        
    }else if(week==3){
        weekStr=@"02";
        
    }else if(week==4){
        weekStr=@"03";
        
    }else if(week==5){
        weekStr=@"04";
        
    }else if(week==6){
        weekStr=@"05";
        
    }else if(week==7){
        weekStr=@"06";
        
    }
    return weekStr;
}

#pragma mark - animation
+(void)setAnimation:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //transition.delegate = viewController;
    transition.type = kCATransitionFade;
    transition.removedOnCompletion = YES;
    transition.subtype = kCATransitionFromRight;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
    [viewController.view.layer addAnimation:transition forKey:@"transition"];
}


#pragma mark - navgationbar
+(UILabel *)setTitleLabel:(NSString *)titleStr
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = NSLocalizedString(titleStr, nil);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Nina" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

+ (UIButton *)creatNavigationleftButtonWithtarget:(id)target action:(SEL)action
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return leftBtn;
}

+ (UIButton *)creatNavigationrightButtonWithtarget:(id)target action:(SEL)action
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"Update"] forState:UIControlStateNormal];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}

+(void)settingNavigationbarColor:(UIViewController *)viewController
{
    viewController.navigationController.navigationBar.barTintColor = RGBColor(32, 179, 175, 1.0);
    viewController.navigationController.navigationBarHidden = NO;
}

//判断邮箱格式
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
