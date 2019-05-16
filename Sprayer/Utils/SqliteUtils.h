//
//  SqliteUtils.h
//  Sprayer
//
//  Created by FangLin on 17/3/9.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDB.h"
@interface SqliteUtils : NSObject


 
+(SqliteUtils *)sharedManager;
//用户
-(void)open;//创建或打开数据库

-(void)close;//关闭数据库

-(void)createUserTable;//创建用户表

-(BOOL)insertUserInfo:(NSString *)sqlStr;//插入数据

-(void)deleteUserInfo:(int)idStr;//删除数据

-(NSArray *)selectUserInfo;//查询数据

-(BOOL)updateUserInfo:(NSString *)sqlStr;//修改数据

//实时蓝牙数据
- (void)openRealTimeBTData;//创建或打开数据库

-(void)createRealTimeBTTable;//创建表

-(BOOL)insertRealBTInfo:(NSString *)sqlStr;//插入数据

-(NSArray *)selectRealBTInfo;//查询所有数据

-(void)deleteRealTimeBTData:(NSString *)sqlStr;//删除实时蓝牙数据

//历史蓝牙数据
-(void)deleteHistoryBTData:(NSString *)sqlStr;//删除历史表的数据

- (void)openHistoryBTData;//创建或打开数据库

-(void)createHistoryBTTable;//创建表

-(BOOL)insertHistoryBTInfo:(NSString *)sqlStr;//插入表

-(NSArray *)selectHistoryBTInfo;//查询表


@end
