//
//  HistoryValueTableViewCell.h
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryValueTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *spraysLabel;
@property (weak, nonatomic) IBOutlet UILabel *inspiratoryLabel;

@end
