//
//  EditDetailPatSexInfoViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/8.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "EditDetailPatSexInfoViewController.h"

@interface EditDetailPatSexInfoViewController ()<CustemBBI>
{
    BOOL isFemale;
    UIImageView * maleImgView;
    UIImageView * femaleImgView;
}
@end

@implementation EditDetailPatSexInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Sex"];
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

-(void)createView
{
    UIView * maleView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, screen_width, 50)];
    maleView.layer.borderWidth = 1.0;
    maleView.layer.borderColor = RGBColor(241, 242, 243, 1.0).CGColor;
    maleView.backgroundColor = RGBColor(254, 255, 255, 1.0);
    UILabel * maleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 50, 50)];
    maleLabel.text = @"Male";
    maleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width-35, 18, 20, 15)];
    maleImgView.contentMode = UIViewContentModeScaleAspectFit;
    [maleView addSubview:maleLabel];
    [maleView addSubview:maleImgView];
    [self.view addSubview:maleView];
    
    UIView * femaleView = [[UIView alloc]initWithFrame:CGRectMake(0, maleView.current_y_h, screen_width, 50)];
    femaleView.layer.borderWidth = 1;
    femaleView.layer.borderColor = RGBColor(241, 242, 243, 1.0).CGColor;
    femaleView.backgroundColor = RGBColor(254, 255, 255, 1.0);
    UILabel * femaleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 50)];
    femaleLabel.text = @"Female";
    femaleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width-35, 18, 20, 15)];
    femaleImgView.contentMode = UIViewContentModeScaleAspectFit;
    [femaleView addSubview:femaleLabel];
    [femaleView addSubview:femaleImgView];
    [self.view addSubview:femaleView];
    
    //判断传过来的原值是男还是女
    if ([_sexStr isEqualToString:@"Female"]) {
        femaleImgView.image = [UIImage imageNamed:@"sex-icon-duigou"];
        isFemale = YES;
    }else{
        isFemale = NO;
        maleImgView.image = [UIImage imageNamed:@"sex-icon-duigou"];
    }
    //添加点击事件
    UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
    tapOne.numberOfTapsRequired = 1;
    maleView.tag = 1;
    [maleView addGestureRecognizer:tapOne];
    
    UITapGestureRecognizer * tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
    tapTwo.numberOfTapsRequired = 1;
    femaleView.tag = 2;
    [femaleView addGestureRecognizer:tapTwo];
    
}

#pragma mark ----触发的点击事件
-(void)tapOne:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 2) {
        isFemale = YES;
       femaleImgView.image = [UIImage imageNamed:@"sex-icon-duigou"];
        maleImgView.image = nil;
    }else
    {
        isFemale = NO;
        maleImgView.image = [UIImage imageNamed:@"sex-icon-duigou"];
        femaleImgView.image = nil;
    }
    
    
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        if (_sexDelegate&&[_sexDelegate respondsToSelector:@selector(showTheSex:)]) {
            if (isFemale == NO) {
                [_sexDelegate showTheSex:@"Male"];
            }else
            {
                [_sexDelegate showTheSex:@"Female"];
            }
        }

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
