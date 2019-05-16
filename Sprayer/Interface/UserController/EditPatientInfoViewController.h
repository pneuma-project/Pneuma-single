//
//  EditPatientInfoViewController.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/8.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPatientInfoModel.h"
@interface EditPatientInfoViewController : UITableViewController

@property(nonatomic,strong) AddPatientInfoModel * patientModel;
@property(nonatomic,assign) NSInteger index;//标记为在数据表中的第几组
@end
