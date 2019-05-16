//
//  BasicInformationViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "BasicInformationViewController.h"
#import "lhScanQCodeViewController.h"
#import "MedicalTableViewCell.h"
#import "SqliteUtils.h"
#import "EditPatientInfoViewController.h"
#import "EditDetailPatSexInfoViewController.h"
#import "EditDetailPatientInfoViewController.h"
#import "ValuePickerView.h"
#import "MedicalInfoViewController.h"
static NSString *ONE_Cell = @"ONECELL";
static NSString *TWO_Cell = @"TWOCELL";
static NSString *THREE_Cell = @"THREECELL";

@interface BasicInformationViewController ()<CustemBBI,sexDelegate,textInfoDelegate,medicalDelegate>
{
    UIView *headView;
    UIImageView *headImageView;
    
    CGSize medicalSize;
    CGSize allergySize;
    BOOL isFirst;//保证不刷新掉修改的内容
}
@property (nonatomic, strong) ValuePickerView * pickerView;
@end

@implementation BasicInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Basic Information"];
    [self registerCell];
    [self createHeadView];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
    self.navigationItem.rightBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"device-icon-saoyisao"] andTarget:self andinfoStr:@"right"];
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ONE_Cell];
    [self.tableView registerNib:[UINib nibWithNibName:@"MedicalTableViewCell" bundle:nil] forCellReuseIdentifier:TWO_Cell];
}

-(void)createHeadView
{
    self.pickerView = [[ValuePickerView alloc]init];
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 100)];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    headImageView.center = CGPointMake(screen_width/2, 50);
    headImageView.image = [UIImage imageNamed:@"device-user-2"];
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
        lhScanQCodeViewController *lhscanVC = [[lhScanQCodeViewController alloc] init];
        [self.navigationController pushViewController:lhscanVC animated:YES];
    }
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
        headLabel.text = @"Medical History";
    }else if (section == 2){
        headLabel.text = @"Device Information";
    }else {
        headLabel.text = nil;
    }
    [view addSubview:headLabel];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else if (section == 1){
        return 1;
    }else if (section ==2){
        return 1;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = @[@"Name:",@"Phone:",@"Sex:",@"Age:",@"Race:",@"Height:",@"Weight:"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ONE_Cell];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell) {
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
            switch (indexPath.row) {
                case 0:
                    valueLabel.text = _patientModel.name;
                    break;
                case 1:
                    valueLabel.text = _patientModel.phone;
                    break;
                case 2:
                    valueLabel.text = _patientModel.sex;
                    break;
                case 3:
                    valueLabel.text = _patientModel.age;
                    break;
                case 4:
                    valueLabel.text = _patientModel.race;
                    break;
                case 5:
                    valueLabel.text = _patientModel.height;
                    break;
                case 6:
                    valueLabel.text = _patientModel.weight;
                    break;
                default:
                    break;
            }
        [cell addSubview:valueLabel];
        [cell addSubview:keyLabel];
        [cell addSubview:[DisplayUtils customCellLine:44]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 1){
        MedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TWO_Cell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        medicalSize = [DisplayUtils stringWithWidth:cell.medicalLabel.text withFont:15];
        allergySize = [DisplayUtils stringWithWidth:cell.allergyLabel.text withFont:15];
        if (![_patientModel.medical isEqualToString:@"(null)"]) {
           cell.medicalLabel.text = _patientModel.medical;
        }
        if (![_patientModel.allergy isEqualToString:@"(null)"]) {
            cell.allergyLabel.text = _patientModel.allergy;
        }
        //添加点击事件
        cell.medicalLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(medicalTap)];
        tapOne.numberOfTapsRequired = 1;
        [cell.medicalLabel addGestureRecognizer:tapOne];
        cell.allergyLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(medicalTap)];
        tapTwo.numberOfTapsRequired = 1;
        [cell.allergyLabel addGestureRecognizer:tapTwo];
        return cell;
    }else if (indexPath.section == 2){
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, screen_width/2, 40)];
        keyLabel.text = @"Device serial number:";
        keyLabel.textColor = RGBColor(50, 51, 52, 1.0);
        keyLabel.font = [UIFont systemFontOfSize:14];
        UILabel * valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width-80, 0, 70, cell.current_h)];
        valueLabel.text =_patientModel.deviceSerialNum;
        valueLabel.textColor = RGBColor(50, 51, 52, 1.0);
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textAlignment = NSTextAlignmentRight;
//        valueLabel.tag = 108;
        [cell addSubview:valueLabel];
        [cell addSubview:keyLabel];
        return cell;
    }else{
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(50, 5, screen_width-100, 40);
        [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
        saveBtn.layer.mask = [DisplayUtils cornerRadiusGraph:saveBtn withSize:CGSizeMake(saveBtn.current_h/2, saveBtn.current_h/2)];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSubview:saveBtn];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSArray *titleArr = @[@"Name",@"Phone",@"Sex",@"Age",@"Race",@"Height",@"Weight",@"Phone"];
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

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return medicalSize.height+allergySize.height+102;
    }else{
        return 44;
    }
}
#pragma mark   ----MedicalHistoryTap
-(void)medicalTap
{
    MedicalInfoViewController * vc = [[MedicalInfoViewController alloc]init];
    vc.medicalDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)sendTheMedical:(NSString *)str1 Aliergy:(NSString *)str2
{
    _patientModel.medical = str1;
    _patientModel.allergy =str2;
    [self.tableView reloadData];
}
#pragma mark --- sexDelegate
-(void)showTheSex:(NSString *)sexStr
{
    UILabel * label = (UILabel *)[self.view viewWithTag:102];
    label.text = sexStr;
    _patientModel.sex = label.text;
}
#pragma mark --- textInfoDelegate
-(void)showTheInfo:(NSString *)info :(NSInteger)index
{
    UILabel * label = (UILabel *)[self.view viewWithTag:100+index];
    label.text = info;
    
    switch (index) {
        case 0:
            _patientModel.name = label.text;
            break;
        case 1:
            _patientModel.phone = label.text;
            default:
            break;
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
        switch (index) {
            case 3:
               weakSelf.patientModel.age = value;
                break;
            case 4:
                weakSelf.patientModel.race = value;
                break;
            case 5:
                weakSelf.patientModel.height = value;
                break;
            case 6:
                weakSelf.patientModel.weight = value;
                break;
                
            default:
                break;
        }
    };
    [self.pickerView show];
    
    
}
-(void)saveClick
{
    AddPatientInfoModel * model = [[AddPatientInfoModel alloc]init];
    model = _patientModel;
    for (int i =0; i<7; i++) {
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
            default:
                break;
        }
        
    }
    //挑选出数据库需要修改的这条数据
    NSArray * arr = [[SqliteUtils sharedManager] selectUserInfo];
    NSInteger dbIndex = 0;
    for (NSInteger i =0; i<arr.count; i++) {
        AddPatientInfoModel * model1 = [[AddPatientInfoModel alloc]init];
        model1 = arr[i];
        if (model1.isSelect == 1) {
            dbIndex = 1+i;
        }
    }
    
    NSString * sql = [NSString stringWithFormat:@"update userInfo set name='%@',relationship='%@',sex='%@',age='%@',race='%@',height='%@',weight='%@',phone='%@',device_serialnum='%@',isselect=%ld,medical='%@',allergy='%@' where id=%ld;",model.name,model.relationship,model.sex,model.age,model.race,model.height,model.weight,model.phone,model.deviceSerialNum,model.isSelect,_patientModel.medical,_patientModel.allergy,dbIndex];
    BOOL ret = [[SqliteUtils sharedManager]updateUserInfo:sql];
    if (ret == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [DisplayUtils alert:@"save failure" viewController:self];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
