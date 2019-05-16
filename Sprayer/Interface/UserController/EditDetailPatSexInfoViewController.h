//
//  EditDetailPatSexInfoViewController.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/8.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sexDelegate <NSObject>

-(void)showTheSex:(NSString *)sexStr;

@end


@interface EditDetailPatSexInfoViewController : UIViewController

@property(nonatomic,weak)id<sexDelegate> sexDelegate;
@property(nonatomic,strong) NSString * sexStr;
@end
