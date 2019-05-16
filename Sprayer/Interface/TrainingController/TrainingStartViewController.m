//
//  TrainingStartViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/2.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "TrainingStartViewController.h"
#import "FLChartView.h"
#import "TrainingFirstViewController.h"
#import "UserDefaultsUtils.h"
#import "FLWrapJson.h"
#import "FLDrawDataTool.h"

@interface TrainingStartViewController ()<CustemBBI>
{
    UIView *headView;
    NSData *timeData;
}

@property (nonatomic,strong)FLChartView *chartView;

@property (nonatomic,strong)NSTimer *timer;
@end

@implementation TrainingStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Inspiratory Training"];
    [self createView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"first"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNSTimerAction) name:@"stopTrain" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectAction) name:PeripheralDidConnect object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNSTimerAction) name:@"sparyModel" object:nil];
}

-(void)stopNSTimerAction
{
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)disconnectAction
{
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建UI
-(void)createView
{
    headView = [[UIView alloc] initWithFrame:CGRectMake(15, 80, screen_width-30, (screen_height-64-tabbarHeight-100)/2)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.layer.mask = [DisplayUtils cornerRadiusGraph:headView withSize:CGSizeMake(5, 5)];
    [self.view addSubview:headView];
    
    //图标题
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
    pointImageView.center = CGPointMake(10, 15);
    pointImageView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointImageView.layer.mask = [DisplayUtils cornerRadiusGraph:pointImageView withSize:CGSizeMake(pointImageView.current_w/2, pointImageView.current_h/2)];
    [headView addSubview:pointImageView];
    
    NSString *titleStr = @"Inspiratory Flow Throughout";
    CGSize size = [DisplayUtils stringWithWidth:titleStr withFont:15];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointImageView.current_x_w+10, 0, size.width, 30)];
    titleLabel.text = titleStr;
    titleLabel.textColor = RGBColor(8, 86, 184, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:titleLabel];
    
    //曲线图
    self.chartView = [[FLChartView alloc]initWithFrame:CGRectMake(0, 20, headView.current_w, headView.current_h-20)];
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.titleOfYStr = @"SLM";
    self.chartView.titleOfXStr = @"Sec";
   
    NSMutableArray * mutArr = [NSMutableArray array];
    self.chartView.leftDataArr = mutArr;
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
    //得出y轴的坐标轴
    NSMutableArray * yNumArr = [NSMutableArray array];
    for (int i =10; i>=0;i--) {
        [yNumArr addObject:[NSString stringWithFormat:@"%d",i*(max/10)]];
    }

    self.chartView.dataArrOfY = yNumArr;//拿到Y轴坐标
    self.chartView.dataArrOfX = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5",@"1.6",@"1.7",@"1.8",@"1.9",@"2.0",@"2.1",@"2.2",@"2.3",@"2.4",@"2.5",@"2.6",@"2.7",@"2.8",@"2.9",@"3.0",@"3.1",@"3.2",@"3.3",@"3.4",@"3.5",@"3.6",@"3.7",@"3.8",@"3.9",@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0"];//拿到X轴坐标
    [headView addSubview:self.chartView];
    
    //详细说明
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.current_x, headView.current_y_h+10, headView.current_w, 30)];
    desLabel.text = @"Training Description:";
    desLabel.textColor = RGBColor(8, 86, 184, 1.0);
    desLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:desLabel];
    
    NSString *detailStr = @"1.The training process Provides instruction and training on proper use of the Device.\n\n2.To activate device for use Press the ON button until The RED LED light turns on.\n\n3.Inhale slowly and continue to inhale completely.\n\n4.The inspiratory flow is recorded and stored.\n\n5.After the patient records three inspiratory curves  the best inspiratory results are chosen and displayed during dosing for comparison.";
    CGSize detailSize = [DisplayUtils stringWithWidth:detailStr withFont:10];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.current_x, desLabel.current_y_h, headView.current_w, detailSize.height+60)];
    detailLabel.text = detailStr;
    detailLabel.textColor = RGBColor(155, 160, 160, 1.0);
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:detailLabel];
    
    //第一次训练按钮
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame = CGRectMake(50, 0, screen_width-100, 40);
    firstBtn.center = CGPointMake(screen_width/2, detailLabel.current_y_h+(self.view.current_h-detailLabel.current_y_h-tabbarHeight)/2);
    [firstBtn setTitle:@"The First Training" forState:UIControlStateNormal];
    [firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [firstBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    firstBtn.layer.mask = [DisplayUtils cornerRadiusGraph:firstBtn withSize:CGSizeMake(firstBtn.current_h/2, firstBtn.current_h/2)];
    [firstBtn addTarget:self action:@selector(firstBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstBtn];
}

#pragma mark - 点击事件
-(void)firstBtnAction
{
    if ([UserDefaultsUtils boolValueWithKey:@"isConnect"] == YES) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you ready?" message:@"Now you're ready to get your first inspiration." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startTrain" object:nil userInfo:nil];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(writeDataAction) userInfo:nil repeats:YES];
            TrainingFirstViewController *firstVC = [[TrainingFirstViewController alloc] init];
            [self.navigationController pushViewController:firstVC animated:YES];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder" message:@"The device is not connected！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)writeDataAction
{
//    NSString *time = [DisplayUtils getTimeStampWeek];
//    NSString *weakDate = [DisplayUtils getTimestampDataWeek];
//    NSMutableString *allStr = [[NSMutableString alloc] initWithString:time];
//    [allStr insertString:weakDate atIndex:10];
//    timeData = [FLWrapJson bcdCodeString:allStr];
    long long time = [DisplayUtils getNowTimestamp];
    timeData = [FLDrawDataTool longToNSData:time];
    [BlueWriteData startTrainData:timeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
