//
//  MedicalInfoViewController.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/4/14.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol medicalDelegate <NSObject>

-(void)sendTheMedical:(NSString *)str1 Aliergy:(NSString *)str2;

@end

@interface MedicalInfoViewController : UIViewController

@property(nonatomic,weak) id<medicalDelegate> medicalDelegate;

@end
