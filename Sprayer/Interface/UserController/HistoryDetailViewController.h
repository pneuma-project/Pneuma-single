//
//  HistoryDetailViewController.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/5/24.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDetailViewController : UIViewController
@property(nonatomic,strong)NSMutableArray * sprayDataArr;//训练最佳曲线数据

@property(nonatomic,strong)NSMutableArray * AllNumberArr;//柱状图实时数据总和

@property(nonatomic,strong)NSMutableArray * numberArr;//单条实时曲线图的数据（30一组）

@property(nonatomic,assign) int allTotalNum;
@property(nonatomic,assign) int allTrainTotalNum;
@property(nonatomic,assign) int lastTrainNum;
@property(nonatomic,copy) NSString * titles;
@property(nonatomic,copy) NSString * medicineNaStr;
@property(nonatomic,strong) NSArray * selectDateArr;//当前日期的数据
@end
