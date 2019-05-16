//
//  HistoryModel.h
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "JSONModel.h"

@interface HistoryModel : JSONModel

@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *spray;
@property (nonatomic,copy)NSString *inspiratory;

@end
