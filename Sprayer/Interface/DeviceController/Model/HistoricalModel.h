//
//  HistoricalModel.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/10.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "JSONModel.h"

@interface HistoricalModel : JSONModel

@property(nonatomic,strong)NSString * productName;
@property(nonatomic,strong)NSString * CartridgeNumber;
@property(nonatomic,strong)NSString * Dosage;
@property(nonatomic,strong)NSString * dateStr;

@end
