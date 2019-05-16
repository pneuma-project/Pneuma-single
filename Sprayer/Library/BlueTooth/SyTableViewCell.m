//
//  SyTableViewCell.m
//  SY_CheShi
//
//  Created by FangLin on 16/1/26.
//  Copyright © 2016年 FangLin. All rights reserved.
//

#import "SyTableViewCell.h"

@implementation SyTableViewCell


-(void)addUI{
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 40)];
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.textAlignment = NSTextAlignmentLeft;
    _titleLable.font = [UIFont systemFontOfSize:18 weight:3];
    
    _rssiLable = [[UILabel alloc]initWithFrame:CGRectMake(screen_width-100, CGRectGetMinY(_titleLable.frame), 60, CGRectGetHeight(_titleLable.frame))];
    _rssiLable.textColor = [UIColor grayColor];
    _rssiLable.textAlignment = NSTextAlignmentRight;
    _rssiLable.font = [UIFont systemFontOfSize:12 weight:2];
    
//    _cellBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_rssiLable.frame)+10, CGRectGetMinY(_titleLable.frame), CGRectGetWidth(_rssiLable.frame), CGRectGetHeight(_titleLable.frame))];
//    [_cellBtn setTitle:@"发送" forState:UIControlStateNormal];
//    [_cellBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [_cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [self addSubview:_titleLable];
    [self addSubview:_rssiLable];
    //[self addSubview:_cellBtn];
}

-(void)drawRect:(CGRect)rect
{
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 40)];
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.textAlignment = NSTextAlignmentLeft;
    _titleLable.font = [UIFont systemFontOfSize:18 weight:3];
    
    _rssiLable = [[UILabel alloc]initWithFrame:CGRectMake(screen_width-100, CGRectGetMinY(_titleLable.frame), 60, CGRectGetHeight(_titleLable.frame))];
    _rssiLable.textColor = [UIColor grayColor];
    _rssiLable.textAlignment = NSTextAlignmentRight;
    _rssiLable.font = [UIFont systemFontOfSize:12 weight:2];
    
    //    _cellBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_rssiLable.frame)+10, CGRectGetMinY(_titleLable.frame), CGRectGetWidth(_rssiLable.frame), CGRectGetHeight(_titleLable.frame))];
    //    [_cellBtn setTitle:@"发送" forState:UIControlStateNormal];
    //    [_cellBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    [_cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [self addSubview:_titleLable];
    [self addSubview:_rssiLable];
    //[self addSubview:_cellBtn];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
