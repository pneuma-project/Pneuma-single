//
//  Utils.h
//  WineStore
//
//  Created by hexiao on 13-9-5.
//  Copyright (c) 2013年 hexiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayUtils : NSObject

/**
 *  自定义cell线条
 *
 */
+(UIView *)customCellLine:(CGFloat)height;

/**
 *  计算字符串的宽度
 *
 */
+(CGSize)stringWithWidth:(NSString *)str withFont:(CGFloat)fontSize;


/**
 * 渐变
 *
 */
+(CAGradientLayer *)gradientLayerColorOne:(UIColor *)Onecolor WithColorTwo:(UIColor *)TwoColor withHeight:(CGFloat)height;

/**
 * 圆角
 *
 */
+(CAShapeLayer *)cornerRadiusGraph:(UIView *)view withSize:(CGSize)size;

/**
 * 显示文本
 * \param image 原始图
 * \param reSize 图片尺寸
 * \return 改变尺寸后的图
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/**
 * 显示文本
 * \param title 文本
 * \param viewController 视图
 */
+ (void)alert:(NSString*)title viewController:(UIViewController*)viewController;

+ (NSString *)md5:(NSString *)str;

+(NSString *)dictionaryToJson:(NSDictionary *)dic;

/**
 * 时间戳
 * \param ...
 * \param ...
 */
+(NSString *)getTimestampData;

+(long long)getNowTimestamp;

+(NSString *)getTimeStamp;

+(NSString *)getDate:(NSString *)time;

+(NSString *)getTimeStampTime:(NSString *)timeDate;

+(NSString *)getTimeStamp:(NSString *)time;

+(NSString *)getTimeStampWeek;

+(NSString *)getTimestampDataWeek;

+(void)setAnimation:(UIViewController *)viewController;

/**
 * navgationbar
 * \param ...
 * \param ...
 */
+(UILabel *)setTitleLabel:(NSString *)titleStr;

+ (UIButton *)creatNavigationleftButtonWithtarget:(id)target action:(SEL)action;

+ (UIButton *)creatNavigationrightButtonWithtarget:(id)target action:(SEL)action;

+ (void)settingNavigationbarColor:(UIViewController *)viewController;

/**
 * 判断邮箱格式
 * \param ...
 * \param ...
 */
+(BOOL)isValidateEmail:(NSString *)email;

@end
