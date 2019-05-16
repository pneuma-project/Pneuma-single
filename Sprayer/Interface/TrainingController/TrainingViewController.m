//
//  TrainingViewController.m
//  Sprayer
//
//  Created by FangLin on 17/2/27.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "TrainingViewController.h"
#import "FL_ScaleCircle.h"
#import "FLChartView.h"
#import "TrainingStartViewController.h"
#import "RetrainingViewController.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
#import "UserDefaultsUtils.h"

@interface TrainingViewController ()
{
    UIView *view;
    UIImageView *bgImageView;
    
    UIView *footView;
    UIView *circleView;
    int allTrainNum;
    float allTrain;
    
    NSArray *dataArr;
    
    BOOL isTrain;
}

@property (nonatomic,strong)FL_ScaleCircle *circleView;
@property (nonatomic,strong)FLChartView *chartView;

@property(nonatomic,strong)NSMutableArray * yNumArr;

@end

@implementation TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"Inspiratory Training"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    [self selectFromDb];
    [self createHeadView];
    [self createFootView];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"transparent"]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = RGBColor(0, 83, 181, 1.0);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
}

-(void)selectFromDb
{
    //曲线图
    allTrainNum = 0;
    NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
    NSArray * mutArr;
    if (arr.count!=0) {
        for (AddPatientInfoModel * model in arr) {
            
            if (model.isSelect == 1) {
                mutArr = [model.btData componentsSeparatedByString:@","];
                NSArray * arr = [model.btData componentsSeparatedByString:@","];
                for (NSString * str in arr) {
                    allTrainNum += [str intValue];
                }
                if ([model.btData isEqualToString:@"(null)"]) {
                    isTrain = NO;
                }else{
                    isTrain = YES;
                }
                continue;
            }
            
        }
    }
//    allTrainNum/=600;
    allTrain = allTrainNum/600.0;
    dataArr = mutArr;
    //求出数组的最大值
    int max = 0;
    for (NSString * str in mutArr) {
        if (max<[str intValue]) {
            max = [str intValue];
        }
    }
    if (max>100) {
        max = max/100+1;
        max*=100;
    }else if (max>10)
    {
        max = max/10+1;
        max*=10;
    }else
    {
        max = 10;
    }
    max = 180;
    //得出y轴的坐标轴
     _yNumArr = [NSMutableArray array];
    for (int i =10; i>=0;i--) {
        [_yNumArr addObject:[NSString stringWithFormat:@"%d",i*(max/10)]];
    }

}

-(void)createHeadView
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height/2)];
    [self.view addSubview:view];
    
    //背景图片
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height/2)];
    bgImageView.image = [UIImage imageNamed:@"my-profile-bg"];
    [view addSubview:bgImageView];
    
    self.circleView = [[FL_ScaleCircle alloc] initWithFrame:CGRectMake(0, 0, screen_width/2-10, screen_width/2-10)];
    self.circleView.center = CGPointMake(screen_width/2, bgImageView.current_h/2);
    self.circleView.number = [NSString stringWithFormat:@"%.1fL",allTrain];
    self.circleView.lineWith = 7.0;
    [bgImageView addSubview:self.circleView];
}

-(void)createFootView
{
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, view.current_y_h, screen_width, screen_height/2)];
    footView.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self.view addSubview:footView];
    
    circleView = [[UIView alloc] initWithFrame:CGRectMake(10, -50, screen_width-20, screen_height/2-50-tabbarHeight)];
    circleView.backgroundColor = RGBColor(254, 255, 255, 1.0);
    circleView.layer.mask = [DisplayUtils cornerRadiusGraph:circleView withSize:CGSizeMake(5, 5)];
    [footView addSubview:circleView];
    
    //图标题
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
    pointImageView.center = CGPointMake(10, 25);
    pointImageView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointImageView.layer.mask = [DisplayUtils cornerRadiusGraph:pointImageView withSize:CGSizeMake(pointImageView.current_w/2, pointImageView.current_h/2)];
    [circleView addSubview:pointImageView];
    
    NSString *titleStr = @"The last best inspiration";
    CGSize size = [DisplayUtils stringWithWidth:titleStr withFont:17];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointImageView.current_x_w+10, 5, size.width, 40)];
    titleLabel.text = titleStr;
    titleLabel.textColor = RGBColor(8, 86, 184, 1.0);
    [circleView addSubview:titleLabel];
    
    
    self.chartView = [[FLChartView alloc]initWithFrame:CGRectMake(0, 30, circleView.current_w, circleView.current_h-30)];
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.titleOfYStr = @"SLM";
    self.chartView.titleOfXStr = @"Sec";
    self.chartView.leftDataArr = dataArr;
    self.chartView.dataArrOfY = _yNumArr;//拿到Y轴坐标
    self.chartView.dataArrOfX = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5",@"1.6",@"1.7",@"1.8",@"1.9",@"2.0",@"2.1",@"2.2",@"2.3",@"2.4",@"2.5",@"2.6",@"2.7",@"2.8",@"2.9",@"3.0",@"3.1",@"3.2",@"3.3",@"3.4",@"3.5",@"3.6",@"3.7",@"3.8",@"3.9",@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0"];//拿到X轴坐标
    [circleView addSubview:self.chartView];
    
    //单位
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.current_x_w, 15, circleView.current_w-titleLabel.current_x_w-10, 35)];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.textColor = RGBColor(8, 86, 184, 1.0);
    NSInteger strlength = [NSString stringWithFormat:@"%.1fL",allTrain].length;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Total:%.1fL",allTrain]];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:13]
                          range:NSMakeRange(0, 6)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:20]
                          range:NSMakeRange(6, strlength)];
    totalLabel.attributedText = AttributedStr;
    [circleView addSubview:totalLabel];
    
    //按钮
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(50, 0, screen_width-100, 40);
    startBtn.center = CGPointMake(screen_width/2, circleView.current_y_h+(footView.current_h-circleView.current_y_h-tabbarHeight)/2);
    if (isTrain == NO) {
        [startBtn setTitle:@"Start Training" forState:UIControlStateNormal];
    }else{
        [startBtn setTitle:@"Restart Training" forState:UIControlStateNormal];
    }
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    startBtn.layer.mask = [DisplayUtils cornerRadiusGraph:startBtn withSize:CGSizeMake(startBtn.current_h/2, startBtn.current_h/2)];
    [startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:startBtn];
}

#pragma mark - 点击事件
-(void)startBtnAction
{
    NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
    if (arr.count == 0) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoLogin" object:nil userInfo:nil];
        return;
    }
    [UserDefaultsUtils saveValue:@[] forKey:@"trainDataArr"];
    TrainingStartViewController *trainingStartVC = [[TrainingStartViewController alloc] init];
    [self.navigationController pushViewController:trainingStartVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
