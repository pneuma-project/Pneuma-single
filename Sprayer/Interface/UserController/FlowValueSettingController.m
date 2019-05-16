//
//  FlowValueSettingController.m
//  Sprayer
//
//  Created by 箫海岸 on 2017/11/16.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "FlowValueSettingController.h"
#import "CustemNavItem.h"
#import "UserDefaultsUtils.h"

@interface FlowValueSettingController ()<CustemBBI,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *k1ValueTF;
@property (weak, nonatomic) IBOutlet UITextField *k2ValueTF;

@end

@implementation FlowValueSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Flow value setting";
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
    self.k1ValueTF.delegate = self;
    self.k2ValueTF.delegate = self;
    if ([UserDefaultsUtils valueWithKey:@"k1flowValue"] == nil) {
        self.k1ValueTF.text = @"0";
    }else {
        self.k1ValueTF.text = [UserDefaultsUtils valueWithKey:@"k1flowValue"];
    }
    if ([UserDefaultsUtils valueWithKey:@"k2flowValue"] == nil) {
        self.k2ValueTF.text = @"8.67";
    }else {
        self.k2ValueTF.text = [UserDefaultsUtils valueWithKey:@"k2flowValue"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_k1ValueTF.isFirstResponder) {
        [self.k1ValueTF resignFirstResponder];
    }else if (_k2ValueTF.isFirstResponder) {
        [self.k2ValueTF resignFirstResponder];
    }
}

- (IBAction)SaveButtonAction:(UIButton *)sender {
    
    //保存修改的值到本地
//    float flowk1Value = [_k1ValueTF.text floatValue];
//    float flowk2Value = [_k2ValueTF.text floatValue];
//    if (flowk1Value < 0 || flowk1Value > 50) {
//        return;
//    }
//    if (flowk2Value < 3 || flowk2Value > 10) {
//        return;
//    }
    [UserDefaultsUtils saveValue:self.k1ValueTF.text forKey:@"k1flowValue"];
    [UserDefaultsUtils saveValue:self.k2ValueTF.text forKey:@"k2flowValue"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)restoreDefaultSettingAction:(UIButton *)sender {
    [UserDefaultsUtils saveValue:@"0" forKey:@"k1flowValue"];
    [UserDefaultsUtils saveValue:@"8.67" forKey:@"k2flowValue"];
    self.k1ValueTF.text = [UserDefaultsUtils valueWithKey:@"k1flowValue"];
    self.k2ValueTF.text = [UserDefaultsUtils valueWithKey:@"k2flowValue"];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField == _k1ValueTF) {
//        float flowValue = [textField.text floatValue];
//        if (flowValue >= 0 && flowValue <= 50) {
//
//        }else {
//            _k1ValueTF.text = @"";
//        }
//    }else if (textField == _k2ValueTF) {
//        float flowValue = [textField.text floatValue];
//        if (flowValue >= 3 && flowValue <= 10) {
//
//        }else {
//            _k2ValueTF.text = @"";
//        }
//    }
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
