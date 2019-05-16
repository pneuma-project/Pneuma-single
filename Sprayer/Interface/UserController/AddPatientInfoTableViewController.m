//
//  AddPatientInfoTableViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/9.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "AddPatientInfoTableViewController.h"
#import "EditPatientInfoViewController.h"
#import "EditDetailPatSexInfoViewController.h"
#import "EditDetailPatientInfoViewController.h"
#import "ValuePickerView.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
#import "DisplayUtils.h"
static NSString *ONE_Cell = @"ONECELL";
@interface AddPatientInfoTableViewController ()<CustemBBI,sexDelegate,textInfoDelegate>
{
    UIView * headView;
    UIImageView * headImageView;
    
    CGSize medicalSize;
    CGSize allergySize;
}
@property (nonatomic, strong) ValuePickerView *pickerView;
@end

@implementation AddPatientInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Add Patient Information"];
    [self createHeadView];
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
-(void)createHeadView
{
    self.pickerView = [[ValuePickerView alloc]init];
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 100)];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    headImageView.center = CGPointMake(screen_width/2, 50);
    headImageView.image = [UIImage imageNamed:@"add-patient-information-icon-touxiang"];
    [headView addSubview:headImageView];
    
    self.tableView.tableHeaderView = headView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([infoStr isEqualToString:@"right"]){
        
    }
}
#pragma mark --- sexDelegate
-(void)showTheSex:(NSString *)sexStr
{
    UILabel * label = (UILabel *)[self.view viewWithTag:102];
    label.text = sexStr;
    
}
#pragma mark --- textInfoDelegate
-(void)showTheInfo:(NSString *)info :(NSInteger)index
{
    UILabel * label = (UILabel *)[self.view viewWithTag:100+index];
    label.text = info;
}

#pragma mark - UITableView Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_width-20, 40)];
    headLabel.backgroundColor = RGBColor(242, 250, 254, 1.0);
    headLabel.textColor = RGBColor(8, 86, 184, 1.0);
    headLabel.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        headLabel.text = @"Basic Information";
    }else if (section == 1){
        headLabel.text = @"Device Information";
    }else {
        headLabel.text = nil;
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
        return 8;
    }else if (section == 1){
        return 1;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = @[@"Name:",@"Relationship:",@"Sex:",@"Age:",@"Race:",@"Height:",@"Weight:",@"Phone:"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ONE_Cell];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ONE_Cell];
    }else
    {
        for (UIView *subView in cell.subviews) {
            [subView removeFromSuperview];
        }
    }
    if (indexPath.section == 0) {
        
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screen_width/2, 40)];
        keyLabel.text = titleArr[indexPath.row];
        keyLabel.textColor = RGBColor(50, 51, 52, 1.0);
        UILabel * valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(keyLabel.current_x_w, 2, screen_width/2-40, 40)];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.textColor = RGBColor(122, 123, 124, 1.0);
        valueLabel.tag = 100+indexPath.row;
        [cell addSubview:valueLabel];
        [cell addSubview:keyLabel];
        [cell addSubview:[DisplayUtils customCellLine:44]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 1){
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, screen_width/2, 40)];
        keyLabel.text = @"Device serial number:";
        keyLabel.textColor = RGBColor(50, 51, 52, 1.0);
        keyLabel.font = [UIFont systemFontOfSize:14];
        UILabel * valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width-80, 0, 70, cell.current_h)];
        valueLabel.text =@"3273267";
        valueLabel.textColor = RGBColor(50, 51, 52, 1.0);
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.tag = 108;
        [cell addSubview:keyLabel];
        [cell addSubview:valueLabel];
        return cell;
        
    }else{
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(50, 5, screen_width-100, 40);
        [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setBackgroundColor:RGBColor(0, 83, 180, 1.0)];
        saveBtn.layer.mask = [DisplayUtils cornerRadiusGraph:saveBtn withSize:CGSizeMake(saveBtn.current_h/2, saveBtn.current_h/2)];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSubview:saveBtn];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *titleArr = @[@"Name",@"Relationship",@"Sex",@"Age",@"Race",@"Height",@"Weight",@"Phone"];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            EditDetailPatSexInfoViewController * sexVC = [[EditDetailPatSexInfoViewController alloc]init];
            sexVC.sexDelegate = self;
            UILabel * label = (UILabel *)[self.view viewWithTag:102];
            
            if (label.text.length!=0) {
                sexVC.sexStr = label.text;
            }
            [self.navigationController pushViewController:sexVC animated:YES];
        }else if(indexPath.row == 3||indexPath.row == 4||indexPath.row == 5||indexPath.row ==6)
        {
            [self createPickerView:indexPath.row :titleArr[indexPath.row]];
            
        }else
        {
            EditDetailPatientInfoViewController * editDetailVC = [[EditDetailPatientInfoViewController alloc]init];
            editDetailVC.nameStr = titleArr[indexPath.row];
            UILabel * label = (UILabel *)[self.view viewWithTag:100+indexPath.row];
            
            if (label.text.length!=0) {
                editDetailVC.infoStr = label.text;
            }
            
            editDetailVC.index = indexPath.row;
            editDetailVC.infoDelegate = self;
            [self.navigationController pushViewController:editDetailVC animated:YES];
        }
    }else
    {
        return;
    }
}
-(void)saveClick
{
    AddPatientInfoModel * model = [[AddPatientInfoModel alloc]init];
    for (int i =0; i<9; i++) {
        
        UILabel * valueLabel = (UILabel *)[self.view viewWithTag:100+i];
        if (valueLabel.text.length==0) {
            [DisplayUtils alert:@"Please fill in the information" viewController:self];
            return;
        }
        switch (i) {
            case 0:
                model.name = valueLabel.text;
                break;
                case 1:
                model.relationship = valueLabel.text;
                break;
                case 2:
                model.sex = valueLabel.text;
                break;
                case 3:
                model.age = valueLabel.text;
                break;
                case 4:
                model.race = valueLabel.text;
                break;
                case 5:
                model.height = valueLabel.text;
                break;
                case 6:
                model.weight = valueLabel.text;
                break;
                case 7:
                model.phone = valueLabel.text;
                break;
                case 8:
                model.deviceSerialNum = valueLabel.text;
                break;
            default:
                break;
        }
        
    }
    //查询是否第一次添加数据
    NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
    if (arr.count == 0) {
        model.isSelect = 1;
    }else
    {
        model.isSelect = 0;
    }
    NSString * sql = [NSString stringWithFormat:@"insert into userInfo(name,relationship,sex,age,race,height,weight,phone,device_serialnum,isselect,trainData,medical,allergy) values('%@','%@','%@','%@','%@','%@','%@','%@','%@',%ld,'%@','%@','%@');",model.name,model.relationship,model.sex,model.age,model.race,model.height,model.weight,model.phone,model.deviceSerialNum,model.isSelect,nil,nil,nil];
   BOOL ret = [[SqliteUtils sharedManager]insertUserInfo:sql];
    if (ret == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
         [DisplayUtils alert:@"save failure" viewController:self];
        return;
    }
}

-(void)createPickerView:(NSInteger)index :(NSString *)keyStr
{
    NSArray * arr = nil;
    if (index == 3) {
        NSMutableArray * mutArr = [NSMutableArray array];
        for (int i=0; i<121; i++) {
            [mutArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        arr = mutArr;
    }else if (index == 4)
    {
        arr = @[@"White or Caucasian",@"Asian",@"American Lndian or Alaska Native",@"Hispanic or Latino",@"Black or African American",@"Hawaiian or Other Pacific Islander"];
    }else if (index == 5)
    {
        NSMutableArray * mutArr = [NSMutableArray array];
        for (int i=100; i<250; i++) {
            [mutArr addObject:[NSString stringWithFormat:@"%d ft.",i]];
        }
        arr = mutArr;
    }else
    {
        NSMutableArray * mutArr = [NSMutableArray array];
        for (int i=25; i<200; i++) {
            [mutArr addObject:[NSString stringWithFormat:@"%d ibs",i]];
        }
        arr = mutArr;
        
    }
    self.pickerView.dataSource = arr;
    self.pickerView.pickerTitle = keyStr;
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        
        UILabel * textlabel = (UILabel *)[weakSelf.view viewWithTag:100+index];
        
        textlabel.text = value;
    };
    [self.pickerView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
