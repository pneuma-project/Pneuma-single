//
//  DeviceStatusViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "DeviceStatusViewController.h"
#import "DeviceStatusModel.h"
#import "FLWrapJson.h"

static NSString *CellID = @"cell";

@interface DeviceStatusViewController ()<CustemBBI>
{
    NSData *timeData;
}
@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation DeviceStatusViewController

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Device Status"];
    [self requestData];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"first"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSucceesAction) name:ConnectSucceed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNSTimerAction) name:@"startTrain" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNSTimerAction) name:@"sparyModel" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)stopNSTimerAction
{
    [self.timer invalidate];
}

//连接成功后向蓝牙写入上电信息
-(void)connectSucceesAction
{
    NSString *time = [DisplayUtils getTimeStampWeek];
    NSString *weakDate = [DisplayUtils getTimestampDataWeek];
    NSMutableString *allStr = [[NSMutableString alloc] initWithString:time];
    [allStr insertString:weakDate atIndex:10];
    timeData = [FLWrapJson bcdCodeString:allStr];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(writeDataAction) userInfo:nil repeats:YES];
}

-(void)writeDataAction
{
    //写数据到蓝牙
    [BlueWriteData bleConfigWithData:timeData];
}

#pragma mark - 数据处理
-(void)requestData
{
    for (NSInteger i = 0; i < 3; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (i == 0) {
            DeviceStatusModel *model = [[DeviceStatusModel alloc] init];
            model.device = @"zae25412";
            model.name = @"Anny";
            model.status = YES;
            [dic setValue:model forKey:@"ConnectedDevice"];
            [self.dataArr addObject:dic];
        }else if (i == 1){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSArray *deviceArr = @[@"zae25412",@"zae25863",@"zae22634"];
            NSArray *nameArr = @[@"Anny",@"Dave",@"Mary"];
            for (NSInteger j = 0; j < 3; j++) {
                DeviceStatusModel *model = [[DeviceStatusModel alloc] init];
                model.device = deviceArr[j];
                model.name = nameArr[j];
                if (j == 0) {
                    model.status = YES;
                }else if (j == 1){
                    model.status = NO;
                }else if (j == 2){
                    model.status = NO;
                }
                [array addObject:model];
            }
            [dic setObject:array forKey:@"RegisteredDevice"];
            [self.dataArr addObject:dic];
        }else if (i == 2){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSArray *deviceArr = @[@"zae25111",@"zae25330"];
            for (NSInteger j = 0; j < 2; j++) {
                DeviceStatusModel *model = [[DeviceStatusModel alloc] init];
                model.device = deviceArr[j];
                model.name = nil;
                model.status = NO;
                [array addObject:model];
            }
            [dic setObject:array forKey:@"Newdevice"];
            [self.dataArr addObject:dic];
        }
    }
    NSLog(@"dataArr = %@",self.dataArr);
}

#pragma mark - 点击事件
//返回
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_width-20, 40)];
    headLabel.backgroundColor = RGBColor(242, 250, 254, 1.0);
    headLabel.textColor = RGBColor(8, 86, 184, 1.0);
    headLabel.font = [UIFont systemFontOfSize:15];
    if (section == 0) {
        headLabel.text = @"Connected device";
    }else if (section == 1){
        headLabel.text = @"Registered device list";
    }else if (section == 2){
        headLabel.text = @"New device";
    }
    [view addSubview:headLabel];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }else{
        for (UIView *subView in cell.subviews) {
            [subView removeFromSuperview];
        }
    }
    if (indexPath.section == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.current_w, 9, 26, 26)];
        if (self.dataArr) {
            DeviceStatusModel *model = [self.dataArr[indexPath.section] objectForKey:@"ConnectedDevice"];
            cell.textLabel.text = model.device;
            if (model.status == YES) {
                imageView.image = [UIImage imageNamed:@"device-status-icon-on"];
            }else{
                imageView.image = [UIImage imageNamed:@"device-status-icon-off"];
            }
        }
        [cell addSubview:imageView];
        [cell addSubview:[DisplayUtils customCellLine:44]];
        return cell;
    }else if (indexPath.section == 1){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.current_w-15, 9, 26, 26)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.current_w-imageView.current_w-15, cell.current_h)];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentRight;
        if (self.dataArr) {
            NSArray *array = [self.dataArr[indexPath.section] objectForKey:@"RegisteredDevice"];
            DeviceStatusModel *model = array[indexPath.row];
            cell.textLabel.text = model.device;
            nameLabel.text = model.name;
            if (model.status == YES) {
                imageView.image = [UIImage imageNamed:@"device-status-icon-on"];
            }else{
                imageView.image = [UIImage imageNamed:@"device-status-icon-off"];
            }
        }
        cell.imageView.image = [UIImage imageNamed:@"device-status-img-shebei"];
        [cell addSubview:imageView];
        [cell addSubview:nameLabel];
        [cell addSubview:[DisplayUtils customCellLine:44]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 2){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.current_w-15, 9, 26, 26)];
        if (self.dataArr) {
            NSArray *array = [self.dataArr[indexPath.section] objectForKey:@"Newdevice"];
            DeviceStatusModel *model = array[indexPath.row];
            cell.textLabel.text = model.device;
            if (model.status == YES) {
                imageView.image = [UIImage imageNamed:@"device-status-icon-on"];
            }else{
                imageView.image = [UIImage imageNamed:@"device-status-icon-off"];
            }
        }
        [cell addSubview:imageView];
        [cell addSubview:[DisplayUtils customCellLine:44]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
