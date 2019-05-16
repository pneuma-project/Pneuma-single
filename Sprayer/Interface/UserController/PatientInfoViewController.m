//
//  PatientInfoViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "PatientInfoViewController.h"
#import "PatientInfoModel.h"
#import "PatientInfoTableViewCell.h"
#import "EditPatientInfoViewController.h"
#import "AddPatientInfoTableViewController.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
#import "DisplayUtils.h"
static NSString *const cellId = @"cell";

@interface PatientInfoViewController ()<CustemBBI>
{
    BOOL isEdit;
    UIButton *rightBtn;
    UIButton *addBtn;
}
@property (nonatomic,strong)NSMutableArray *dataArr;//数据
@end

@implementation PatientInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Patient Information"];
    [self registerCell];
    [self createView];
   
}


#pragma mark ----查询本地数据库
-(void)selectFromDataBase
{
    self.dataArr = [[SqliteUtils sharedManager] selectUserInfo];
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self selectFromDataBase];
     isEdit = NO;
    addBtn.hidden = NO;
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setNavRightItem]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
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

-(UIButton *)setNavRightItem
{
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"Edit" forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    [rightBtn addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}

-(void)createView
{
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(50, 350+(screen_height-350-64)/2, screen_width-100, 40);
    [addBtn setTitle:@"Add Members" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:RGBColor(0, 83, 181, 1.0)];
    addBtn.layer.mask = [DisplayUtils cornerRadiusGraph:addBtn withSize:CGSizeMake(addBtn.current_h/2, addBtn.current_h/2)];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}

-(void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"PatientInfoTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
}
#pragma mark ----添加成员点击事件
-(void)addClick
{
    NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
    if (arr.count==5) {
        [DisplayUtils alert:@"You can only add up to five members" viewController:self];
        return;
    }
    
    AddPatientInfoTableViewController * addVC = [[AddPatientInfoTableViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightBarAction
{
    BOOL status = rightBtn.selected;
    status = !status;
    if (status) {
        [rightBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        isEdit = YES;
        addBtn.hidden = YES;
    }else{
        [rightBtn setTitle:@"Edit" forState:UIControlStateNormal];
        isEdit = NO;
        addBtn.hidden = NO;
    }
    rightBtn.selected = status;
}

#pragma mark - UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (self.dataArr) {
        AddPatientInfoModel * model = self.dataArr[indexPath.row];
        if (model.isSelect == YES) {
            cell.selectImageView.hidden = NO;
        }else{
            cell.selectImageView.hidden = YES;
        }
        cell.headImageView.image = [UIImage imageNamed:@"device-user-2"];
        cell.nameLabel.text = model.name;
    }
    [cell addSubview:[DisplayUtils customCellLine:70]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isEdit == NO) {
        //遍历viewModel的数组，如果点击的行数对应的viewModel相同，将isSelected变为Yes，反之为No
        for (NSInteger i = 0; i < self.dataArr.count; i++) {
            AddPatientInfoModel *model = self.dataArr[i];
            //如果model。isSelect与原本一致则不用修改
            if (i!= indexPath.row && model.isSelect) {
                model.isSelect = NO;
                //设置后更新数据库
                NSString * sql = [NSString stringWithFormat:@"update userInfo set isselect = 0 where id = %d;",model.userId];
                [[SqliteUtils sharedManager] updateUserInfo:sql];
            }else if (i == indexPath.row && !model.isSelect){
                //如果model。isSelect与原本一致则不用修改
                model.isSelect = YES;
                //设置后更新数据库
                NSString * sql = [NSString stringWithFormat:@"update userInfo set isselect = 1 where id = %d;",model.userId];
                [[SqliteUtils sharedManager] updateUserInfo:sql];
            }
        }
        //----------------//
//        for (NSInteger i = 1; i<=self.dataArr.count; i++) {
//            if (i==indexPath.row+1) {
//                NSString * sql = [NSString stringWithFormat:@"update userInfo set isselect = 1 where id = %ld;",i];
//                [[SqliteUtils sharedManager] updateUserInfo:sql];
//            }else
//            {
//                NSString * sql = [NSString stringWithFormat:@"update userInfo set isselect = 0 where id = %ld;",i];
//                [[SqliteUtils sharedManager] updateUserInfo:sql];
//            }
//            
//        }
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        AddPatientInfoModel * model = self.dataArr[indexPath.row];
        EditPatientInfoViewController * editVC = [[EditPatientInfoViewController alloc]init];
        editVC.patientModel = model;
        editVC.index = indexPath.row+1;
        [self.navigationController pushViewController:editVC animated:YES];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
        [self alertToDeleteWhenClickYes:^{
            [self deleteDataWith:indexPath andTableView:tableView];
        } OrNo:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"delete";
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
    //从数据表中删除掉选中用户相关的所有数据表
    AddPatientInfoModel *model = self.dataArr[indexPath.row];
    [[SqliteUtils sharedManager] deleteUserInfo:model.userId];
    
    /*如果要删除的数据的isSelect值为YES，则删除后默认上一条的数据的isSelect为YES.
     同时如果数据不止一条再去获取上一条数据 */
    if (indexPath.row && model.isSelect) {
        AddPatientInfoModel *lastModel = self.dataArr[indexPath.row - 1];
        lastModel.isSelect = YES;
        //同时更新数据库
        NSString * sql = [NSString stringWithFormat:@"update userInfo set isselect = 1 where id = %d;",lastModel.userId];
        [[SqliteUtils sharedManager] updateUserInfo:sql];
        //更新对应的indexPath的数据
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    // Delete the row from the data source.
    //删除数组里的数据
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
