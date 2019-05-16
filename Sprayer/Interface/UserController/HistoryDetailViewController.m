//
//  HistoryDetailViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/5/24.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "JHChartHeader.h"
#import "SqliteUtils.h"
#import "BlueToothDataModel.h"
#import "AddPatientInfoModel.h"
#import "DisplayUtils.h"
#import "UserDefaultsUtils.h"
#import "FLWrapJson.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height

@interface HistoryDetailViewController ()<CustemBBI,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *medicineName; //药品名称
    
    UILabel * yLineLabel;
    UILabel * xLineLabel;
    UIView * downBgView;
}
@property(nonatomic,strong)JHLineChart *lineChart;

@property(nonatomic,strong)UIView * upBgView;

@property(nonatomic,strong)UILabel * slmLabel;

@property(nonatomic,strong)UILabel *medicineNameL;
@property(nonatomic,strong)UILabel *currentInfoLabel;

@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(240, 248, 252, 1.0);
    [self setNavTitle:_titles];
    [self showFirstQuardrant];
    [self setInterface];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
}

-(void)setNavTitle:(NSString *)title
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    label.text=title;
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:19];
    self.navigationItem.titleView=label;
}
#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setInterface {
    /**
     创建layout(布局)
     UICollectionViewFlowLayout 继承与UICollectionLayout
     对比其父类 好处是 可以设置每个item的边距 大小 头部和尾部的大小
     */
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = 40;
    // 设置每个item的大小
    layout.itemSize = CGSizeMake(itemWidth, yLineLabel.current_h);
    // 设置列间距
    layout.minimumInteritemSpacing = 0;
    // 设置行间距
    layout.minimumLineSpacing = 20;
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //每个分区的四边间距UIEdgeInsetsMake
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(yLineLabel.current_x_w, yLineLabel.current_y, xLineLabel.current_w, yLineLabel.current_h) collectionViewLayout:layout];
    /** mainCollectionView 的布局(必须实现的) */
    _collectionView.collectionViewLayout = layout;
    //mainCollectionView 的背景色
    _collectionView.backgroundColor = [UIColor whiteColor];
    //设置代理协议
    _collectionView.delegate = self;
    //设置数据源协议
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [downBgView addSubview:self.collectionView];
}

#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _AllNumberArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = RGBColor(10, 77, 170, 1);
    UILabel *numL = [[UILabel alloc] initWithFrame:CGRectZero];
    numL.font = [UIFont systemFontOfSize:14];
    numL.textColor = [UIColor grayColor];
    numL.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:view];
    [cell.contentView addSubview:numL];
    int viewH = [_AllNumberArr[indexPath.item] floatValue]/2 * yLineLabel.current_h/6;
    view.frame = CGRectMake(0, yLineLabel.current_h-viewH, 40, viewH);
    numL.frame = CGRectMake(0, view.current_y-20, 40, 14);
    numL.text = [NSString stringWithFormat:@"%d",indexPath.item+1];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self createLineChart:indexPath.item];
}

#pragma mark ----导航栏点击事件
-(void)leftTap
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"点击了左侧");
}

- (void)showFirstQuardrant{
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    _upBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 74, screen_width-20, (screen_height-64-tabbarHeight)/2-20)];
    _upBgView.layer.cornerRadius = 3.0;
    _upBgView.backgroundColor = [UIColor whiteColor];
    
    NSString * str = @"Reference Total Volume:";
    CGSize strSize = [DisplayUtils stringWithWidth:str withFont:12];
    UILabel * referenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,strSize.width, strSize.height)];
    referenceLabel.font = [UIFont systemFontOfSize:12];
    referenceLabel.textColor = RGBColor(0, 64, 181, 1.0);
    referenceLabel.text = str;
    
    UILabel * referenceInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(referenceLabel.current_x_w+5, 10, 50,strSize.height)];
    referenceInfoLabel.textColor = RGBColor(0, 64, 181, 1.0);
    referenceInfoLabel.font = [UIFont systemFontOfSize:15];
    referenceInfoLabel.text = [NSString stringWithFormat:@"%.1fL",_allTrainTotalNum/600.0];
    
    NSString * str1 = @"Current Total Volume:";
    strSize = [DisplayUtils stringWithWidth:str1 withFont:12];
    UILabel * currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, referenceLabel.current_y_h, strSize.width, strSize.height)];
    currentLabel.font = [UIFont systemFontOfSize:12];
    currentLabel.textColor = RGBColor(0, 64, 181, 1.0);
    currentLabel.text = str1;
    _currentInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(currentLabel.current_x_w+5, referenceInfoLabel.current_y_h, 50, strSize.height)];
    _currentInfoLabel.text = [NSString stringWithFormat:@"%.1fL",_lastTrainNum/600.0];
    _currentInfoLabel.textColor = RGBColor(0, 64, 181, 1.0);
    _currentInfoLabel.font = [UIFont systemFontOfSize:15];
    
    _medicineNameL = [[UILabel alloc] initWithFrame:CGRectMake(currentLabel.current_x, currentLabel.current_y_h, 100, 12)];
    _medicineNameL.font = [UIFont systemFontOfSize:12];
    _medicineNameL.textColor = RGBColor(0, 64, 181, 1.0);
    _medicineNameL.text = self.medicineNaStr;
    
    UILabel * trainLabel = [[UILabel alloc]initWithFrame:CGRectMake(_upBgView.current_w-55, 10, 55, strSize.height)];
    trainLabel.text = @"Training";
    trainLabel.textColor = RGBColor(238, 146, 1, 1.0);
    trainLabel.font = [UIFont systemFontOfSize:12];
    UIView * trainView = [[UIView alloc]initWithFrame:CGRectMake(trainLabel.current_x-15, 15, 10, 3)];
    CGPoint trainPoint = trainView.center;
    trainPoint.y = trainLabel.center.y;
    trainView.center = trainPoint;
    trainView.backgroundColor = RGBColor(238, 146, 1, 1.0);
    UILabel * sprayLabel = [[UILabel alloc]initWithFrame:CGRectMake(trainLabel.current_x, trainLabel.current_y_h, 55, strSize.height)];
    sprayLabel.text = @"Spray";
    sprayLabel.textColor = RGBColor(0, 83, 181, 1.0);
    sprayLabel.font = [UIFont systemFontOfSize:12];
    UIView * sprayView = [[UIView alloc]initWithFrame:CGRectMake(sprayLabel.current_x-15, 15, 10, 3)];
    CGPoint sprayPoint = sprayView.center;
    sprayPoint.y = sprayLabel.center.y;
    sprayView.center = sprayPoint;
    sprayView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    
    _slmLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, currentLabel.current_y_h+15, 50, 15)];
    _slmLabel.text = @"SLM";
    _slmLabel.font = [UIFont systemFontOfSize:12];
    _slmLabel.textColor = RGBColor(221, 222, 223, 1.0);
    /*     创建第一个折线图       */
    if (_numberArr.count == 0) {
        [self createLineChart:0];
    }else
    {
        [self createLineChart:_numberArr.count-1];
    }
    
    UILabel * SecLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lineChart.current_x_w, _lineChart.current_y_h-30, _upBgView.current_w-_lineChart.current_x_w, 20)];
    SecLabel.text = @"Sec";
    SecLabel.textColor = RGBColor(204, 205, 206, 1.0);
    SecLabel.font = [UIFont systemFontOfSize:10];
    
    [_upBgView addSubview:SecLabel];
    [_upBgView addSubview:referenceLabel];
    [_upBgView addSubview:referenceInfoLabel];
    [_upBgView addSubview:currentLabel];
    [_upBgView addSubview:_currentInfoLabel];
    [_upBgView addSubview:_medicineNameL];
    [_upBgView addSubview:_slmLabel];
    [_upBgView addSubview:trainView];
    [_upBgView addSubview:trainLabel];
    [_upBgView addSubview:sprayView];
    [_upBgView addSubview:sprayLabel];
    [self.view addSubview:_upBgView];
    /*创建第二个柱状图 */
    downBgView = [[UIView alloc]initWithFrame:CGRectMake(10, _upBgView.current_y_h+10, screen_width-20,(screen_height-64-tabbarHeight)/2-20)];
    downBgView.backgroundColor = [UIColor whiteColor];
    UIView * pointView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 8, 8)];
    pointView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointView.layer.cornerRadius = 4.0;
    pointView.layer.masksToBounds = 4.0;
    UILabel *inspirationLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointView.current_x_w+5, 10, screen_width-pointView.current_x_w, 15)];
    inspirationLabel.text = @"Inspiration Volume Distribution";
    inspirationLabel.textColor = RGBColor(0, 83, 181, 1.0);
    CGPoint insPoint = pointView.center;
    insPoint.y = inspirationLabel.center.y;
    pointView.center = insPoint;
    
    UILabel * totalInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(downBgView.current_w-60, inspirationLabel.current_y+15, 60, 30)];
    
    totalInfoLabel.text = [NSString stringWithFormat:@"%.1fL",_allTotalNum/600.0];
    totalInfoLabel.textAlignment = NSTextAlignmentLeft;
    totalInfoLabel.textColor = RGBColor(0, 83, 181, 1.0);
    totalInfoLabel.font = [UIFont systemFontOfSize:16];
    UILabel * totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(totalInfoLabel.current_x-40, inspirationLabel.current_y_h+8,40,15)];
    totalLabel.text = @"Total:";
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.font = [UIFont systemFontOfSize:12];
    totalLabel.textColor = RGBColor(0, 83, 181, 1.0);
    UILabel * unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointView.current_x, totalLabel.current_y_h+5, 35, 15)];
    unitLabel.text = @"Unit:L";
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.textColor = RGBColor(203, 204, 205, 1.0);
    
    yLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(unitLabel.current_x_w, unitLabel.current_y_h+10, 1, downBgView.current_h-unitLabel.current_y_h-40)];
    yLineLabel.backgroundColor = RGBColor(204, 205, 206, 1.0);
    
    //获取总和
    float sum = 10;
    
//    for (NSString * str in _AllNumberArr) {
//        sum+=[str floatValue];
//    }
//    //    sum/=600.0;
//    //最大值取整数
//    if (sum/10000>1) {
//        sum = sum/10000+1;
//        sum *= 10000;
//    }else if (sum/1000>1)
//    {
//        sum = sum/1000+1;
//        sum *= 1000;
//    }else if (sum/100>1)
//    {
//        sum = sum/100+1;
//        sum *= 100;
//    }else if (sum/10>1)
//    {
//        sum = sum/10+1;
//        sum *= 10;
//    }else
//    {
//        sum = 10;
//    }
    
    //--------------//
    for (int i =0; i<6; i++) {
        UILabel * yNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x-35,unitLabel.current_y_h+i*(yLineLabel.current_h/6)+15, 30, yLineLabel.current_h/6)];
        yNumLabel.textColor = RGBColor(204, 205, 206, 1.0);
        yNumLabel.textAlignment = NSTextAlignmentRight;
        yNumLabel.text = [NSString stringWithFormat:@"%.f",sum-i*(sum/5)];
        yNumLabel.font = [UIFont systemFontOfSize:10];
        [downBgView addSubview:yNumLabel];
        
    }
    xLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x_w, yLineLabel.current_y_h, downBgView.current_w-yLineLabel.current_x_w-30, 1)];
    xLineLabel.backgroundColor = RGBColor(204, 205, 206, 1.0);
    UILabel * downDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x_w+xLineLabel.current_w/2-35, xLineLabel.current_y_h, 80, 30)];
    downDateLabel.text = [DisplayUtils getTimestampData];
    downDateLabel.textColor = RGBColor(0, 83, 181, 1.0);
    downDateLabel.font = [UIFont systemFontOfSize:10];
    
//    int viewH = 0;
//    for (int i=0; i<_AllNumberArr.count; i++) {
//        viewH+=[_AllNumberArr[i] floatValue]/(sum/5) * yLineLabel.current_h/6;
//        //        NSLog(@"-------%d",viewH);
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(downDateLabel.current_x+15, xLineLabel.current_y-viewH, downDateLabel.current_w-30,[_AllNumberArr[i] floatValue]/(sum/5) * yLineLabel.current_h/6)];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//        tap.numberOfTouchesRequired = 1;
//        view.tag = 1000+i;
//        [view addGestureRecognizer:tap];
//        if (i%2==0) {
//            view.backgroundColor = RGBColor(0, 83, 181, 1.0);
//        }else
//        {
//            view.backgroundColor = RGBColor(238, 146, 1, 1.0);
//        }
//        [downBgView addSubview:view];
//    }
    [self setInterface];
    [self.collectionView reloadData];
    
    UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(xLineLabel.current_x_w, xLineLabel.current_y_h-10, downBgView.current_w-xLineLabel.current_x_w, 20)];
    dateLabel.text = @"Date";
    dateLabel.textColor = RGBColor(204, 205, 206, 1.0);
    dateLabel.font = [UIFont systemFontOfSize:12];
    
    [downBgView addSubview:dateLabel];
    [downBgView addSubview:downDateLabel];
    [downBgView addSubview:xLineLabel];
    [downBgView addSubview:yLineLabel];
    [downBgView addSubview:unitLabel];
    [downBgView addSubview:totalLabel];
    [downBgView addSubview:totalInfoLabel];
    [downBgView addSubview:pointView];
    [downBgView addSubview:inspirationLabel];
    [self.view addSubview:downBgView];
    
}

#pragma mark ---- 柱状图的点击事件
-(void)tap:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击了第%ld个柱状图",tap.view.tag - 1000);
    
    [self createLineChart:tap.view.tag - 1000];
}
#pragma mark ---创建第一个曲线图
-(void)createLineChart:(NSInteger)index
{
    //展示药品信息
    BlueToothDataModel * totalModel = self.selectDateArr[index];
    NSString *medicineN = totalModel.medicineName;
    _medicineNameL.text = medicineN;
    
    int trainNum = 0;
    for (NSString * str in _numberArr[index]) {
        trainNum += [str intValue];
    }
    _currentInfoLabel.text = [NSString stringWithFormat:@"%.1fL",trainNum/600.0];
    
    self.lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(5, _slmLabel.current_y_h, _upBgView.current_w-25, _upBgView.current_h-_slmLabel.current_y_h) andLineChartType:JHChartLineValueNotForEveryX];
    
    _lineChart.xLineDataArr = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5",@"1.6",@"1.7",@"1.8",@"1.9",@"2.0",@"2.1",@"2.2",@"2.3",@"2.4",@"2.5",@"2.6",@"2.7",@"2.8",@"2.9",@"3.0",@"3.1",@"3.2",@"3.3",@"3.4",@"3.5",@"3.6",@"3.7",@"3.8",@"3.9",@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0"];//拿到X轴坐标
    _lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    if (_numberArr.count!=0) {
        _lineChart.valueArr = @[self.sprayDataArr,_numberArr[index]];
    }else
    {
        _lineChart.valueArr = @[self.sprayDataArr];
    }
    
    _lineChart.showYLevelLine = YES;
    _lineChart.showYLine = NO;
    _lineChart.showValueLeadingLine = NO;
    _lineChart.valueFontSize = 0.0;
    
    _lineChart.backgroundColor = [UIColor whiteColor];
    /* Line Chart colors */
    _lineChart.valueLineColorArr =@[RGBColor(238, 146, 1, 1.0),RGBColor(0, 83, 181, 1.0)];
    /* Colors for every line chart*/
    _lineChart.pointColorArr = @[[UIColor blueColor],[UIColor orangeColor]];
    /* color for XY axis */
    _lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    _lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    _lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    /*        Set whether to fill the content, the default is False         */
    _lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    _lineChart.pathCurve = YES;
    /*        Set fill color array         */
    _lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.0],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.0]];
    
    [_upBgView addSubview:_lineChart];
    [_lineChart showAnimation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
