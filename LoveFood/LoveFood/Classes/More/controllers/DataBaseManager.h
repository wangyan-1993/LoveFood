//
//  DataBaseManager.h
//  LoveFood
//
//  Created by SCJY on 16/3/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject
@property(nonatomic, copy) NSString *name;
//用单例创建数据库管理对象
+ (DataBaseManager *)shareInatance;
#pragma mark------数据库基础操作
//创建数据库
- (void)createDataBase;
//创建数据库表
- (void)createDataBaseTable;
//打开数据库
- (void)openDataBase;
//关闭数据库
- (void)closeDataBase;

- (void)insertIntoCollect:(NSDictionary *)dic withNumber:(NSInteger)num;
- (void)deleteWithNum:(NSInteger)num;
- (NSMutableArray *)selectAllCollect;
- (NSMutableArray *)selectAllCollectWithNum:(NSInteger)num;
@end
