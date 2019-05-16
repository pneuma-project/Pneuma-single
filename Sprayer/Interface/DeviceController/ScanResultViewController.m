//
//  ScanResultViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "ScanResultViewController.h"
#import "DrugInfoViewController.h"
@interface ScanResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"Scan it"];
    self.codeLabel.text = _codeStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationItem setHidesBackButton:YES];
}

- (IBAction)finishAction:(id)sender {
    DrugInfoViewController * vc = [[DrugInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
