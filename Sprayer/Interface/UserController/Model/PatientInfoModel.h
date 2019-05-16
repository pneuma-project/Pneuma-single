//
//  PatientInfoModel.h
//  Sprayer
//
//  Created by FangLin on 17/3/7.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "JSONModel.h"

@interface PatientInfoModel : JSONModel

@property (nonatomic,copy)NSString *headImage;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)BOOL isSelect;

@end
