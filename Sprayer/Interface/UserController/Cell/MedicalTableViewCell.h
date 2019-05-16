//
//  MedicalTableViewCell.h
//  Sprayer
//
//  Created by FangLin on 17/3/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *medicalLabel;
@property (weak, nonatomic) IBOutlet UILabel *allergyLabel;

@end
