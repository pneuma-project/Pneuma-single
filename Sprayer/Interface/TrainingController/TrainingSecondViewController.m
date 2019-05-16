//
//  TrainingFirstViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/2.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "TrainingSecondViewController.h"
#import "FLChartView.h"
#import "TrainingThirdViewController.h"
#import "UserDefaultsUtils.h"
@interface TrainingSecondViewController ()<CustemBBI>
{
    UIView *circleView;
    int allNum;
    BOOL isFirst;//是否第一次进入页面
    BOOL isLeave;//是否离开界面(因为即使离开页面通知仍会收到)
}
@property (nonatomic,strong)FLChartView *chartView;
@end

@implementation TrainingSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:[DisplayUtils getTimestampData]];
    [self createView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    isLeave = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
     isLeave = NO;//防止返回用
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"first"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewAction) name:@"refreshView" object:nil];
}

-(void)refreshViewAction
{
    [self createView];
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建UI
-(void)createView
{
    UILabel *secondResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, screen_width, 60)];
    secondResultLabel.text = @"Second Inspiratory Cycle Results";
    secondResultLabel.textColor = RGBColor(8, 86, 184, 1.0);
    secondResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:secondResultLabel];
    
    circleView = [[UIView alloc] initWithFrame:CGRectMake(15, secondResultLabel.current_y_h+10, screen_width-30, (screen_height-secondResultLabel.current_y_h-tabbarHeight)/2)];
    circleView.backgroundColor = [UIColor whiteColor];
    circleView.layer.mask = [DisplayUtils cornerRadiusGraph:circleView withSize:CGSizeMake(5, 5)];
    [self.view addSubview:circleView];
    
    //图标题
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
    pointImageView.center = CGPointMake(10, 25);
    pointImageView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointImageView.layer.mask = [DisplayUtils cornerRadiusGraph:pointImageView withSize:CGSizeMake(pointImageView.current_w/2, pointImageView.current_h/2)];
    [circleView addSubview:pointImageView];
    
    NSString *titleStr = @"Inspiratory Flow Throughout";
    CGSize size = [DisplayUtils stringWithWidth:titleStr withFont:17];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointImageView.current_x_w+10, 5, size.width, 40)];
    titleLabel.text = titleStr;
    titleLabel.textColor = RGBColor(8, 86, 184, 1.0);
    [circleView addSubview:titleLabel];
    
    //曲线图
    NSArray * mutArr;
     //判断是否第一次进入设备
        if (isFirst == NO) {
            isFirst = YES;
            mutArr = @[];
        }else if(isLeave == NO)
        {
            mutArr = [[[UserDefaultsUtils valueWithKey:@"trainDataArr"]lastObject] componentsSeparatedByString:@","];
            [UserDefaultsUtils saveValue:mutArr forKey:@"TwoTrainDataArr"];
        }
       
    
    allNum = 0;
    for (NSString * str in mutArr) {
        allNum += [str intValue];
    }
    self.chartView = [[FLChartView alloc]initWithFrame:CGRectMake(0, 30, circleView.current_w, circleView.current_h-30)];
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.titleOfYStr = @"SLM";
    self.chartView.titleOfXStr = @"Sec";
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
    max = 180;
    //得出y轴的坐标轴
    NSMutableArray * yNumArr = [NSMutableArray array];
    for (int i =10; i>=0;i--) {
        [yNumArr addObject:[NSString stringWithFormat:@"%d",i*(max/10)]];
    }
    
    self.chartView.dataArrOfY = yNumArr;//拿到Y轴坐标
    self.chartView.dataArrOfX = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5",@"1.6",@"1.7",@"1.8",@"1.9",@"2.0",@"2.1",@"2.2",@"2.3",@"2.4",@"2.5",@"2.6",@"2.7",@"2.8",@"2.9",@"3.0",@"3.1",@"3.2",@"3.3",@"3.4",@"3.5",@"3.6",@"3.7",@"3.8",@"3.9",@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0"];//拿到X轴坐标
    [circleView addSubview:self.chartView];
    
    //单位
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.current_x_w, 15, circleView.current_w-titleLabel.current_x_w-10, 35)];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.textColor = RGBColor(8, 86, 184, 1.0);
    NSInteger strlength = [NSString stringWithFormat:@"%.1fL",allNum/600.0].length;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Total:%.1fL",allNum/600.0]];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:13]
                          range:NSMakeRange(0, 6)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:20]
                          range:NSMakeRange(6, strlength)];
    totalLabel.attributedText = AttributedStr;
    [circleView addSubview:totalLabel];
    
    //第三次训练按钮
    UIButton *thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdBtn.frame = CGRectMake(50, 0, screen_width-100, 40);
    thirdBtn.center = CGPointMake(screen_width/2, circleView.current_y_h+(self.view.current_h-circleView.current_y_h-tabbarHeight)/2);
    [thirdBtn setTitle:@"The Third Training" forState:UIControlStateNormal];
    [thirdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    thirdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [thirdBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    thirdBtn.layer.mask = [DisplayUtils cornerRadiusGraph:thirdBtn withSize:CGSizeMake(thirdBtn.current_h/2, thirdBtn.current_h/2)];
    [thirdBtn addTarget:self action:@selector(thirdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdBtn];
}

#pragma mark - 点击事件
-(void)thirdBtnAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you ready?" message:@"Now you're ready to start your third inspiration." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TrainingThirdViewController *thirdVC = [[TrainingThirdViewController alloc] init];
        [self.navigationController pushViewController:thirdVC animated:YES];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
