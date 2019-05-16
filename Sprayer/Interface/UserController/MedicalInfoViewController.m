//
//  MedicalInfoViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/4/14.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "MedicalInfoViewController.h"

@interface MedicalInfoViewController ()<CustemBBI>
{
    UITextView * text1;
    UITextView * text2;
}
@end

@implementation MedicalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"Medical History"];
    [self createView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setNavRightItem]];
}
-(UIButton *)setNavRightItem
{
  UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"Save" forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    [rightBtn addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}
#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

-(void)createView
{
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 200, 40)];
    label1.text = @"Medical History:";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:14];
    
   text1 = [[UITextView alloc]initWithFrame:CGRectMake(10, label1.current_y_h, screen_width-20, 100)];
    text1.layer.borderWidth = 1.0;
    text1.layer.borderColor = RGBColor(209, 218, 202, 1.0).CGColor;
    text1.layer.cornerRadius = 5.0;
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, text1.current_y_h, label1.current_w, label1.current_h)];
    label2.text = @"Aliergy History:";
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:14];
 
    
    text2 = [[UITextView alloc]initWithFrame:CGRectMake(10, label2.current_y_h, screen_width-20, text1.current_h)];
    text2.layer.borderWidth = 1.0;
    text2.layer.borderColor = RGBColor(209, 218, 202, 1.0).CGColor;
    text2.layer.cornerRadius =5.0;
    [self.view addSubview:label1];
    [self.view addSubview:text1];
    [self.view addSubview:label2];
    [self.view addSubview:text2];
    //全屏添加点击事件
    UITapGestureRecognizer * tapThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
    tapThree.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapThree];
}
#pragma mark  --- 全屏添加点击事件
-(void)endEditing
{
    [self.view endEditing:YES];
}

-(void)rightBarAction
{
    
    if (text1.text.length == 0 || text2.text.length == 0) {
      
        [DisplayUtils alert:@"Please complete the information" viewController:self];
        return;
    }else
    {
        if(_medicalDelegate&&[_medicalDelegate respondsToSelector:@selector(sendTheMedical:Aliergy:)])
        {
            [_medicalDelegate sendTheMedical:text1.text Aliergy:text2.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
