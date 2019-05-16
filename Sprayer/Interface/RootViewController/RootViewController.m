//
//  RootViewController.m
//  e-Healthy
//
//  Created by FangLin on 16/11/2.
//  Copyright © 2016年 FangLin. All rights reserved.
//

#import "RootViewController.h"
#import "BaseNavViewController.h"
#import "DeviceViewController.h"
#import "SprayViewController.h"
#import "TrainingViewController.h"
#import "UserViewController.h"

@interface RootViewController ()

@property (nonatomic,strong)UITabBarController *tabbarController;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self changeChildControll];
}

-(void)changeChildControll
{
    [self addChildViewController:self.tabbarController];
    [self.view addSubview:self.tabbarController.view];
    [self.tabbarController didMoveToParentViewController:self];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldLoginAction) name:@"gotoLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldTrainAction) name:@"gotoTrain" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)shouldLoginAction
{
    
    self.tabbarController.selectedIndex = 3;
    self.tabbarController.tabBar.hidden = NO;
    
}

-(void)shouldTrainAction
{
    self.tabbarController.selectedIndex = 1;
    self.tabbarController.tabBar.hidden = NO;
}

//初始化tabbar
-(UITabBarController *)tabbarController
{
    if (_tabbarController==nil) {
        _tabbarController=[[UITabBarController alloc]init];
        NSArray *imageNameArr1=@[@"device-home-2",@"device-training-2",@"device-Shape-2",@"device-user-2"];
        NSArray *imageNameArr2=@[@"device-home-1",@"device-training-1",@"device-Shape-1",@"device-user-1"];
        NSArray *nameArr=@[@"Device",@"Training",@"Spray",@"User"];
        DeviceViewController *deviceVC=[[DeviceViewController alloc]init];
        TrainingViewController *trainVC=[[TrainingViewController alloc]init];
        SprayViewController *sprayVC=[[SprayViewController alloc]init];
        UserViewController *userVC = [[UserViewController alloc] init];
        NSArray *vcArr=@[deviceVC,trainVC,sprayVC,userVC];
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (NSInteger i=0; i<4; i++) {
            UIViewController *viewController=vcArr[i];
            viewController.view.backgroundColor=[UIColor whiteColor];
            BaseNavViewController *nav=[[BaseNavViewController alloc]initWithRootViewController:viewController];
            nav.navigationBar.barTintColor = RGBColor(0, 83, 181, 1.0);
            UIImage *image=[[UIImage imageNamed:imageNameArr1[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *image_current=[[UIImage imageNamed:imageNameArr2[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            nav.tabBarItem.image=image;
            nav.tabBarItem.title=nameArr[i];
            nav.tabBarItem.selectedImage=image_current;
            [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
            [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(-4, 0, 4, 0)];
            nav.tabBarItem.selectedImage=image_current;
            
            //扫描入口
            UIImage *scanImage=[UIImage imageNamed:@"device-icon-saoyisao"];
            UIImageView *scanImageView=[[UIImageView alloc]initWithImage:[scanImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            scanImageView.frame=CGRectMake(0, 0, scanImage.size.width, scanImage.size.height);
            UIBarButtonItem *menuBBI=[[UIBarButtonItem alloc]initWithCustomView:scanImageView];
            scanImageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *menutap=[[UITapGestureRecognizer alloc]initWithTarget:viewController action:@selector(MenuDidClick)];
            [scanImageView addGestureRecognizer:menutap];
            if (i == 0) {
//                viewController.navigationItem.rightBarButtonItem = menuBBI;
            }
            
            [array addObject:nav];
        }
        _tabbarController.tabBar.barTintColor = RGBColor(40, 41, 42, 1.0);
        _tabbarController.viewControllers=array;
    }
    return _tabbarController;
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
