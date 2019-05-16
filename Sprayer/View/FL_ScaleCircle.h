//
//  FL_ScaleCircle.h
//  Sprayer
//
//  Created by FangLin on 17/3/1.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FL_ScaleCircle : UIView

//线宽.
@property(nonatomic)CGFloat lineWith;
//基准圆环颜色
@property(nonatomic, strong)UIColor *unfillColor;
//填充色
@property(nonatomic, strong)UIColor *centerfillColor;
//中心数据显示标签
@property (nonatomic, strong)UILabel *centerLable;
@property (nonatomic, strong)UILabel *scoreLabel;
//中心Label数值
@property (nonatomic,copy)NSString *number;

@end
