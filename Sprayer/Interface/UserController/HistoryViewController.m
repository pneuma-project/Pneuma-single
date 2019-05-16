//
//  HistoryViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryValueTableViewCell.h"
#import "HistoryModel.h"
#import "BlueToothDataModel.h"
#import "SqliteUtils.h"
#import "HistoryDetailViewController.h"
static NSString *Cell_ONE = @"cellOne";
static NSString *Cell_TWO = @"cellTwo";

@interface HistoryViewController ()<CustemBBI>

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong) NSArray * dateArr;//获取每一条历史数据的日期的数组

@end

@implementation HistoryViewController

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
    [self setNavTitle:@"History"];
    [self registerCell];
    [self requestData];
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

-(void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:Cell_ONE];
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryValueTableViewCell" bundle:nil] forCellReuseIdentifier:Cell_TWO];
}
#pragma mark --- 拿到每一天的所有数据
-(NSArray *)selectFromData
{
    //查询数据库(获取所有用户数据)
    NSArray * arr = [[SqliteUtils sharedManager] selectHistoryBTInfo];
    NSMutableArray * userTimeArr = [NSMutableArray array];
    NSMutableArray * sprayArr = [NSMutableArray array];
    NSMutableArray * inspiratoryArr = [NSMutableArray array];
    NSMutableArray * dataArr = [NSMutableArray array];
    //筛选出该用户的所有历史数据
    for (BlueToothDataModel * model in arr) {
        if (model.userId == _model.userId) {
            NSLog(@"<<< %@ >>>", model.timestamp);
            [dataArr addObject:model];
        }
    }
    //对用户数据按日期降序排列    请问自己写排序的是什么心态。。。。
    if (dataArr.count == 0) {
        return @[];
    }
    for (int  i =0; i<[dataArr count]-1; i++) {
        for (int j = i+1; j<[dataArr count]; j++) {
            BlueToothDataModel * model1 = dataArr[i];
            BlueToothDataModel * model2 = dataArr[j];
            if ([model1.timestamp intValue] < [model2.timestamp intValue]) {
                //交换
                [dataArr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    //将排序好的日期分列添加入数组
    for (BlueToothDataModel * model in dataArr) {
        [userTimeArr addObject:model.timestamp];
    }
    //拿到每一天有多少次数据和每次数据的总和
    NSMutableArray * allNumSprayArr = [NSMutableArray array];
    for (BlueToothDataModel * model in dataArr) {
        [allNumSprayArr addObject:model.blueToothData];
        //判断有几次达标
        if (_model.btData.length == 0) {
            [sprayArr addObject:@"1/1"];
        }else{
            //算出最佳训练模式数据的总量
            float sum = 0;
            NSArray * numArr = [_model.btData componentsSeparatedByString:@","];
            for (NSString * num in numArr) {
                sum+=[num floatValue];
            }
            sum/=600;
            //-----------得到有几次喷雾达标------//
            NSArray * numArr1 = [model.blueToothData componentsSeparatedByString:@","];
            float sum1 = 0.0;
            for (NSString * num in numArr1) {
                sum1+=[num floatValue];
            }
            sum1/=600;
            if (sum1>=sum*0.8) {
                [sprayArr addObject:@"1/1"];
            }else{
                [sprayArr addObject:@"1/0"];
            }
            
        }
        //----------算出喷雾的平均量---------//
        float allSum = 0;
        for (NSString * str in allNumSprayArr) {
            NSArray * arr = [str componentsSeparatedByString:@","];
            float allNum = 0;
            for (NSString * num in arr) {
                allNum+=[num floatValue];
            }
            allSum+=allNum;
        }
        [inspiratoryArr addObject:[NSString stringWithFormat:@"%.2f",(allSum/600.0)/allNumSprayArr.count]];
    }
    return @[userTimeArr,sprayArr,inspiratoryArr];
}

-(void)requestData
{
    NSArray * dataArr = [self selectFromData];
    NSLog(@"%@",dataArr);
    if (dataArr.count == 0) {
        return;
    }
    NSMutableArray *timeArr1 = [NSMutableArray array];
    //将时间戳转为应为缩写
    for (NSString * timeStr in dataArr[0]) {
        
        NSTimeInterval time=[timeStr doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MMM dd"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        [timeArr1 addObject:currentDateStr];
    }
    self.dateArr = dataArr[0];
    if (timeArr1.count == 0) {
        return;
    }
    //将数据按天数分类
    NSMutableArray * timeArr2 = [NSMutableArray array];
    NSMutableArray * spraysArr2 = [NSMutableArray array];
    NSMutableArray * inspiratoryArr2 = [NSMutableArray array];
    int index = 0;
    int index1 = 0;
    int index2 = 0;
    float index3 = 0;
    float index4 = 0;
    
    NSString * dateStr = timeArr1[0];
    [timeArr2 addObject:dateStr];
    for (int i = 0; i<timeArr1.count; i++) {
        if (i==timeArr1.count -1) {
            NSArray * arr = [dataArr[1][i] componentsSeparatedByString:@"/"];
            index1 += [arr[0] floatValue];
            index2 += [arr[1] floatValue];
            index4 ++;
//            for (NSString * num in dataArr[2]) {
//
//            }
            index3 += [dataArr[2][i] floatValue];
//            index3 /= [dataArr[2] count];
            [spraysArr2 addObject:[NSString stringWithFormat:@"%d/%d",index1,index2]];
            [inspiratoryArr2 addObject:[NSString stringWithFormat:@"%f",index3/index4]];
            continue;
        }
        if ([dateStr isEqualToString:timeArr1[i]]) {
            
            NSArray * arr = [dataArr[1][i] componentsSeparatedByString:@"/"];
            index1 += [arr[0] intValue];
            index2 += [arr[1] intValue];
                
            index4 ++;
            index3 += [dataArr[2][i] floatValue];
        }else{
            dateStr = timeArr1[i];
            [timeArr2 addObject:timeArr1[i]];
            [spraysArr2 addObject:[NSString stringWithFormat:@"%d/%d",index1,index2]];
            [inspiratoryArr2 addObject:[NSString stringWithFormat:@"%f",index3/index4]];
            index  = i;
            index1 = 1;
            index2 = 1;
            index4 = 1;
            index3 = [dataArr[2][i] floatValue];
        }
    }
    for (NSInteger j = 0; j < timeArr2.count; j++) {
        HistoryModel *model = [[HistoryModel alloc] init];
        model.time = timeArr2[j];
        model.spray = spraysArr2[j];
        model.inspiratory = inspiratoryArr2[j];
        [self.dataArr addObject:model];
    }
 }

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableView delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_width-20, 40)];
    headLabel.backgroundColor = RGBColor(242, 250, 254, 1.0);
    headLabel.textColor = RGBColor(8, 86, 184, 1.0);
    headLabel.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        headLabel.text = @"2019";
    }else if (section == 1){
        headLabel.text = @"December 2016";
    }
    [view addSubview:headLabel];
     
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.dataArr.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_ONE forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HistoryValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_TWO forIndexPath:indexPath];
        if (self.dataArr) {
         
            //祭FL挖的坑，踩坑人2：你祭了他的坑不能填平一点吗。。。
            NSInteger index = indexPath.row - 1;

            HistoryModel *model = self.dataArr[index];
            cell.timeLabel.text = model.time;
            cell.spraysLabel.text = model.spray;
            cell.inspiratoryLabel.text = model.inspiratory;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row !=0) {
        HistoryModel *model = self.dataArr[indexPath.row-1];
        [self filterTheDataInSelectDate:model.time];
    }
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return NO;
    }else
    {
      return YES;
    }
    
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row != 0) {
//            // Delete the row from the data source.
//            //从数据表中删除掉选中用户相关的所有数据表
//            [self deleteFromDb:indexPath.row-1];
//            [self.dataArr removeObjectAtIndex:indexPath.row-1];
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self alertToDeleteWhenClickYes:^{
                [self deleteDataWith:indexPath andTableView:tableView];
            } OrNo:nil];
        }
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"delete";
}

#pragma mark ----- 删除所选的历史数据
-(void)deleteFromDb :(NSInteger)index
{
    HistoryModel *model = self.dataArr[index];
    //将时间戳转为应为缩写
    for (NSString * timeStr in _dateArr) {
        
        NSTimeInterval time=[timeStr doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MMM dd"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        //如果当条数据和所删的数据时间是同一天，则从数据库中删除
        if([currentDateStr isEqualToString:model.time])
        {
            [[SqliteUtils sharedManager] deleteHistoryBTData:[NSString stringWithFormat:@"delete from historyBTDb where nowtime = %@;",timeStr]];//userid = %d and   _model.userId,
        }
        
    }

    
}
#pragma mark ---- 筛选出选择的日期的所有历史数据
-(void)filterTheDataInSelectDate:(NSString *)date
{
    //查询数据库(获取所有用户数据)
    NSArray * arr = [[SqliteUtils sharedManager] selectHistoryBTInfo];
    NSMutableArray * dataArr = [NSMutableArray array];
    //筛选出该用户的所有历史数据
    for (BlueToothDataModel * model in arr) {
        if (model.userId == _model.userId) {
            [dataArr addObject:model];
        }
    }
   
    //筛选出该用户当前选的日期的数据
    NSMutableArray * selectDateArr = [NSMutableArray array];
    for (BlueToothDataModel * model in dataArr) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd"];
        NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:[model.timestamp doubleValue]];
        NSString * confromTimespStr2 = [formatter stringFromDate:confromTimesp2];
        if ([confromTimespStr2 isEqualToString:date]) {
            [selectDateArr addObject:model];
        }
        
    }
    //将详情页面所要显示的数据取出
    NSMutableArray * numberArr = [NSMutableArray array];
    for (BlueToothDataModel * model in selectDateArr) {
        NSArray * arr = [model.blueToothData componentsSeparatedByString:@","];
        [numberArr addObject:arr];
    }
    //
    int allTotalNum = 0;
    int allTrainTotalNum = 0;
    int lastTrainNum = 0;
    
    NSMutableArray * allNumberArr = [NSMutableArray array];
    for (NSArray * num in numberArr) {
        float allNum = 0;
        for (NSString * str in num) {
            allNum+=[str floatValue];
        }
        [allNumberArr addObject:[NSString stringWithFormat:@"%.2f",allNum/600.0]];
         allTotalNum += allNum;
    }
    //
    NSInteger count = numberArr.count;
    if (count!=0) {
        NSArray * lastTrainData = numberArr[count-1];
        lastTrainNum = 0;
        for (NSString * str in lastTrainData) {
            lastTrainNum += [str intValue];
        }
    }
    //从用户表拿出该用户的最佳训练数据
    NSString * btDataStr;
    NSArray * arr1 = [[SqliteUtils sharedManager]selectUserInfo];
    if (arr.count!=0) {
        for (AddPatientInfoModel * model in arr1) {
            if (model.userId == _model.userId) {
                
                btDataStr = model.btData;
            }
        }
    }
    NSMutableArray * sprayDataArr = [NSMutableArray array];
    for (NSString * str in [btDataStr componentsSeparatedByString:@","]) {
        [sprayDataArr addObject:str];
        allTrainTotalNum += [str intValue];
    }
    //药品名称
    BlueToothDataModel * totalModel = selectDateArr[selectDateArr.count - 1];
    NSString *medicineN = totalModel.medicineName;
    //
    HistoryDetailViewController * vc = [[HistoryDetailViewController alloc]init];
    vc.numberArr = numberArr;
    vc.AllNumberArr = allNumberArr;
    vc.sprayDataArr = sprayDataArr;
    vc.allTotalNum = allTotalNum;
    vc.allTrainTotalNum = allTrainTotalNum;
    vc.lastTrainNum = lastTrainNum;
    vc.titles = date;
    vc.medicineNaStr = medicineN;
    vc.selectDateArr = selectDateArr;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 删除相关
//删除用户时给出提示
- (void)alertToDeleteWhenClickYes:(void (^)())clickYes OrNo:(void (^)())clickNo
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:@"Do you want to delete it?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (clickYes) {
            clickYes();
        }
    }];
    [alertVC addAction:actionYes];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (clickNo) {
            clickNo();
        }
    }];
    [alertVC addAction:actionNo];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}
//根据传过来的indexPath和tableView来响应删除按钮
- (void)deleteDataWith:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView
{
    // Delete the row from the data source.
    //从数据表中删除掉选中用户相关的所有数据表
    [self deleteFromDb:indexPath.row-1];
    [self.dataArr removeObjectAtIndex:indexPath.row-1];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
