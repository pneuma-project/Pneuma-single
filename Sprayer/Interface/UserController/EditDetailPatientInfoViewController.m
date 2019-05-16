//
//  EditDetailPatientInfoViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/8.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "EditDetailPatientInfoViewController.h"
#import "DisplayUtils.h"
@interface EditDetailPatientInfoViewController ()<CustemBBI>
{
    UIButton * rightBtn;
    UITextField * textFiled;
}
@end

@implementation EditDetailPatientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:_nameStr];
    [self createView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setNavRightItem]];
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
    [rightBtn setTitle:@"Save" forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    [rightBtn addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}

-(void)createView
{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, screen_width, 50)];
    bgView.backgroundColor = RGBColor(254, 255, 255, 1.0);
    
    textFiled = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, bgView.current_w-15, 50)];
    textFiled.placeholder = [NSString stringWithFormat:@"Please enter your %@",_nameStr];
    if (_infoStr.length!=0) {
        textFiled.text = _infoStr;
    }
    textFiled.backgroundColor = RGBColor(254, 255, 255, 1.0);
    [bgView addSubview:textFiled];
    [self.view addSubview:bgView];
}
#pragma mark---导航栏右边的点击事件
-(void)rightBarAction
{
    [self.view endEditing:YES];
    //判断当时输入电话的时候输入内容是否含全为数字
    if([_nameStr isEqualToString:@"Phone"])
    {
        for (int i=0;i<textFiled.text.length;i++) {
            unichar c = [textFiled.text characterAtIndex:i];
            if (!(c<='9'&&c>='0')) {
                [DisplayUtils alert:@"Please enter the correct phone number" viewController:self];
                return;
            }
        }
    }
   
    if (_infoDelegate&&[_infoDelegate respondsToSelector:@selector(showTheInfo::)]) {
        if (textFiled.text.length!=0) {
            [_infoDelegate showTheInfo:textFiled.text :_index];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([infoStr isEqualToString:@"right"]){
        
        
    }
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
