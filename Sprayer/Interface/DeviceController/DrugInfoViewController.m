//
//  DrugInfoViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/9.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "DrugInfoViewController.h"
#import "HistoricalDrugViewController.h"
@interface DrugInfoViewController ()<CustemBBI>

@end

@implementation DrugInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Drug/Cartridge Information"];
    [self createView];
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
    }else if ([infoStr isEqualToString:@"right"]){
        
        
    }
}
-(void)createView
{
    NSArray * titileArr =@[@"Product name:",@"Common name:",@"Cartridge serial number:"];
    NSArray * infoArr =@[@"Aspirin(Aspirin)",@"Aspirin",@"2152336642"];
    for (int i = 0; i<3; i++) {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 74+50*i, screen_width, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.borderWidth = 0.5;
        bgView.layer.borderColor = RGBColor(208, 210, 212, 1.0).CGColor;
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width/2, 50)];
        nameLabel.text = titileArr[i];
        UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/2, 0, screen_width/2-10, 50)];
        infoLabel.text = infoArr[i];
        infoLabel.textColor = RGBColor(137, 138, 139, 1.0);
        infoLabel.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:nameLabel];
        [bgView addSubview:infoLabel];
        [self.view addSubview:bgView];
    }
    
    UILabel * dosageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 264, screen_width/2, 40)];
    dosageLabel.text = @"Dosage:";
    dosageLabel.textColor = RGBColor(17, 90, 186, 1.0);
    [self.view addSubview:dosageLabel];
    
    UITextView * dosageTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, dosageLabel.current_y_h, screen_width-20, 100)];
    dosageTextView.layer.borderWidth = 1.0;
    dosageTextView.layer.borderColor = RGBColor(208, 210, 212, 1.0).CGColor;
    [self.view addSubview:dosageTextView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(30,dosageTextView.current_y_h+(screen_height-dosageTextView.current_y_h)/2, screen_width-60, 40);
    [saveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:RGBColor(0, 83, 180, 1.0)];
    saveBtn.layer.mask = [DisplayUtils cornerRadiusGraph:saveBtn withSize:CGSizeMake(saveBtn.current_h/2, saveBtn.current_h/2)];
    [saveBtn addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    //添加屏幕点击事件
    UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne)];
    tapOne.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapOne];
}
-(void)tapOne
{
    [self.view endEditing:YES];
}
-(void)okClick
{
    HistoricalDrugViewController * historyVC = [[HistoricalDrugViewController alloc]init];
    [self.navigationController pushViewController:historyVC animated:YES];
    
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
