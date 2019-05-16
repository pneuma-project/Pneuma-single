//
//  SyTableViewCell.h
//  SY_CheShi
//
//  Created by FangLin on 16/1/26.
//  Copyright © 2016年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * titleLable;
@property (nonatomic,strong)UILabel * rssiLable;
//@property (nonatomic,strong)UIButton * cellBtn;

-(void)addUI;

@end
