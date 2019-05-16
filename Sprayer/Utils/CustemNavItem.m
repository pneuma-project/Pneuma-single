//
//  CustemNavItem.m
//  summer
//
//  Created by FangLin on 16/11/11.
//  Copyright © 2016年 FangLin. All rights reserved.
//

#import "CustemNavItem.h"

@interface CustemNavItem ()

@property (nonatomic,copy)NSString *infoStr;
@end

@implementation CustemNavItem

+(instancetype)initWithImage:(UIImage *)image andTarget:(id <CustemBBI>)target andinfoStr:(NSString *)infoStr
{
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//    imageView.userInteractionEnabled=YES;
//    imageView.image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, kStatusBarHeight, kNavigationBarHeight, kNavigationBarHeight);
    [backBtn setImage:image forState:UIControlStateNormal];
    CustemNavItem *BBI=[[self alloc]initWithCustomView:backBtn];
    [backBtn addTarget:BBI action:@selector(BBIdidClick) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:BBI action:@selector(BBIdidClick)];
//    [imageView addGestureRecognizer:tap];
    BBI.delegate=target;
    BBI.infoStr=infoStr;
    return BBI;
}
+(instancetype)initWithString:(NSString *)Str andTarget:(id <CustemBBI> )target andinfoStr:(NSString *)infoStr;
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:Str forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, 60, 40);
    CustemNavItem *BBI=[[self alloc]initWithCustomView:btn];
    [btn addTarget:BBI action:@selector(BBIdidClick) forControlEvents:UIControlEventTouchUpInside];
    BBI.delegate=target;
    BBI.infoStr=infoStr;
    return BBI;
}
-(void)BBIdidClick
{
    [self.delegate BBIdidClickWithName:self.infoStr];
}


@end
