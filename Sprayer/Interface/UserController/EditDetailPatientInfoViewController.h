//
//  EditDetailPatientInfoViewController.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/8.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol textInfoDelegate <NSObject>

-(void)showTheInfo:(NSString *)info :(NSInteger)index;

@end

@interface EditDetailPatientInfoViewController : UIViewController

@property(nonatomic,strong) NSString * nameStr;//信息提示
@property(nonatomic,strong) NSString * infoStr;//输入的信息内容
@property(nonatomic,assign) NSInteger index;//判断点击的是哪一个cell
@property(nonatomic,weak) id<textInfoDelegate> infoDelegate;
@end
