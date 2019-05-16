//
//  FL_ScaleCircle.m
//  Sprayer
//
//  Created by FangLin on 17/3/1.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "FL_ScaleCircle.h"

@interface FL_ScaleCircle ()
{
    CGFloat radius; //  半径
    CGFloat center;
}

@property(nonatomic) CGPoint CGPoinCerter;

@end

@implementation FL_ScaleCircle

//  初始化参数
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        center =MIN(self.bounds.size.height/2, self.bounds.size.width/2);
        self.CGPoinCerter = CGPointMake(center, center);
        
        self.lineWith = 10.0;//线宽
        self.backgroundColor = [UIColor clearColor];
        self.unfillColor = RGBColor(131, 186, 250, 1.0);//画笔颜色
        self.centerfillColor = [UIColor whiteColor];//圆环中心填充色
        self.number = @"0L";
    }
    return self;
}

/*
 *中心标签设置
 */
- (void)initCenterLabel
{
    self.centerLable = [[UILabel alloc] initWithFrame:CGRectMake(20, center/3, center*2-40, center)];
    self.centerLable.textAlignment = NSTextAlignmentCenter;
    self.centerLable.numberOfLines = 2;
    self.centerLable.text = @"Best Analog Inspiratory Volume";
    self.centerLable.backgroundColor = [UIColor clearColor];
    self.centerLable.textColor = RGBColor(8, 153, 239, 1.0);
    self.centerLable.font = [UIFont systemFontOfSize:14];
    //self.centerLable.adjustsFontSizeToFitWidth = YES;
    //self.centerLable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerLable.frame.origin.x, self.centerLable.frame.origin.y+self.centerLable.frame.size.height-20, self.centerLable.frame.size.width, center/2)];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.backgroundColor = [UIColor clearColor];
    self.scoreLabel.textColor = RGBColor(83, 170, 241, 1.0);
    self.scoreLabel.text = self.number;
    self.scoreLabel.font = [UIFont systemFontOfSize:30];
    [self addSubview: self.scoreLabel];
    //self.contentMode = UIViewContentModeRedraw;
    [self addSubview: self.centerLable];
}

#pragma mark setMethod
/**
 *  画图函数
 *
 *  @param rect rect description
 */
-(void)drawRect:(CGRect)rect{
    [self initData];
    [self drawRectCircle];
    [self initCenterLabel];
}

-(void)drawRectCircle
{
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.bounds;
    //清空填充色
    trackLayer.fillColor = self.centerfillColor.CGColor;
    //设置画笔颜色
    trackLayer.strokeColor = self.unfillColor.CGColor;
    trackLayer.lineWidth = self.lineWith;
    //设置画笔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.CGPoinCerter radius:self.frame.size.width/2.0-10 startAngle:-M_PI_2 endAngle:-M_PI_2+M_PI*2 clockwise:YES];
    //path决定layer将被渲染成何种形状
    trackLayer.path = path.CGPath;
    [self.layer addSublayer:trackLayer];
}

/**
 *  参数设置
 */
-(void)initData{
    //半径计算
    radius = MIN(self.bounds.size.height/2-self.lineWith/2, self.bounds.size.width/2-self.lineWith/2);
}

@end
