//
//  BaseNavViewController.m
//  e-Healthy
//
//  Created by FangLin on 16/11/2.
//  Copyright © 2016年 FangLin. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
//    viewController.tabBarController.tabBar.hidden=NO;
    if (self.viewControllers.count>1) {
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"更多"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backViewController)];
        viewController.tabBarController.tabBar.hidden=YES;
    }else{
        
    }
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *viewControll=[super popViewControllerAnimated:animated];
    if (self.viewControllers.count == 1 ) {
        viewControll.tabBarController.tabBar.hidden=NO;
    }
    
    return viewControll;
}

-(void)backViewController
{
    [self popViewControllerAnimated:YES];
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
