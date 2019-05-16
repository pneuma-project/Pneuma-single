//
//  HistoricalDrugTableViewCell.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/10.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoricalDrugTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ProductLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProductInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *CartridgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *CartridgeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *DosageLabel;
@property (weak, nonatomic) IBOutlet UILabel *DosageInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;

@end
