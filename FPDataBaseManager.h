//
//  FPDataBaseManager.h
//  FullPayApp
//
//  Created by mark zheng on 14-5-29.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ContactsInfo.h"

@interface FPDataBaseManager : NSObject
{
    FMDatabase *_db_hander;
    NSString   *_db_name;
}

+ (FPDataBaseManager *)shareCenter;

@property (nonatomic,strong) ContactsInfo *contactItem;

//创建联系人表
- (BOOL)createTable_Cantact;
//查询总条数
- (NSInteger)selectCount_Cantact:(NSString *)memberNo;
//查询记录
- (NSArray *)getAllItemTable_Cantact:(NSString *)memberNo;
- (NSArray *)getTop5ItemTable_Cantact:(NSString *)memberNo;

//插入记录
- (BOOL)insertTable_Cantact:(ContactsInfo *)item;
//更新记录
- (BOOL)updateIfExistTable_Cantact:(ContactsInfo *)item;

//删除联系人表某条数据
- (BOOL)deleteTable_CantactWhereToMember:(ContactsInfo *)item;
//删除联系人表数据
- (BOOL)deleteTable_Cantact;
//删除表
- (BOOL)dropTable_Cantact;
@end
