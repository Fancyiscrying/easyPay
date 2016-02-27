//
//  FPDataBaseManager.m
//  FullPayApp
//
//  Created by mark zheng on 14-5-29.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPDataBaseManager.h"

#define kDBName @"fzfdb.sqlite"
#define kDBPrefix @"fzf_"

@implementation FPDataBaseManager

+ (FPDataBaseManager *)shareCenter
{
    static FPDataBaseManager *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[[self class] alloc] init];
    });
    
    return shareInstance;
}

- (NSString *)getDataBaseDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];

    return documentDirectory;
}

- (BOOL)setDataBase:(NSString *)dbFileName
{
    if (dbFileName && dbFileName.length > 0) {
        _db_name = dbFileName;
    } else {
        _db_name = kDBName;
    }
    
    NSString *dbPath = [[self getDataBaseDocumentsDirectory] stringByAppendingPathComponent:_db_name];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:dbPath] == NO) {
        _db_hander = [FMDatabase databaseWithPath:dbPath];
        //为数据库设置缓存，提高查询效率
        [_db_hander setShouldCacheStatements:YES];
    
//    }
    
    return YES;
}

- (BOOL)executeUpdate:(NSString *)sqlStr {
    BOOL result = NO;
    
    if (!_db_hander) {
        [self setDataBase:nil];
    }
    
    if ([_db_hander open]) {
        result = [_db_hander executeUpdate:sqlStr];
        if (result) {
            FPDEBUG(@"execute success");
        } else{
            FPDEBUG(@"execute failed");
        }
        
        [_db_hander close];
    } else {
        FPDEBUG(@"error when open db");
        result = NO;
    }
    
    return result;
}

- (FMResultSet *)executeQuery:(NSString *)sqlStr
{
    FMResultSet *result = nil;
    
    
    if (!_db_hander) {
        [self setDataBase:nil];
    }
    
    if ([_db_hander open]) {
        result = [_db_hander executeQuery:sqlStr];
    
    } else {
        FPDEBUG(@"error when open db");
        result = nil;
    }
    
    return result;
}

//创建联系人表
- (BOOL)createTable_Cantact
{
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"CREATE  TABLE IF NOT EXISTS '%@' ('recordNo' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'fromMemberNo' VARCHAR, 'toMemberNo' VARCHAR, 'toMemberAvator' VARCHAR,'toMemberName' VARCHAR, 'toMemberPhone' VARCHAR,'toRemark' VARCHAR,'toAmount' VARCHAR, 'createDate' timestamp)",tableName];
    
    return [self executeUpdate:sql];
}

- (BOOL)insertTable_Cantact:(ContactsInfo *)item
{
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"insert into '%@' ('fromMemberNo' ,'toMemberNo' , 'toMemberAvator','toMemberName' , 'toMemberPhone' ,'toRemark' ,'toAmount' , 'createDate') values('%@','%@','%@','%@','%@','%@','%@',datetime())",tableName,item.fromMemberNo,item.toMemberNo,item.toMemberAvator,item.toMemberName,item.toMemberPhone,item.toRemark,item.toAmount];
    
    return [self executeUpdate:sql];

}

//查询总条数
- (NSInteger)selectCount_Cantact:(NSString *)memberNo
{
    NSInteger itemCount = 0;
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"select count(*) from '%@' where fromMemberNo = '%@'",tableName,memberNo];
    
    FMResultSet *s = [self executeQuery:sql];
    if ([s next]) {
        itemCount = [s intForColumnIndex:0];
    }
    
    return itemCount;
}

//查询记录
- (NSArray *)getAllItemTable_Cantact:(NSString *)memberNo
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"select * from '%@' where fromMemberNo = '%@'",tableName,memberNo];
    
    FMResultSet *reset = [self executeQuery:sql];
    FPDEBUG(@"rest:%@",reset);
    while (reset.next) {
        ContactsInfo *item = [[ContactsInfo alloc] init];
        item.fromMemberNo = [reset stringForColumn:@"fromMemberNo"];
        item.toMemberNo = [reset stringForColumn:@"toMemberNo"];
        item.toMemberAvator = [reset stringForColumn:@"toMemberAvator"];
        item.toMemberName = [reset stringForColumn:@"toMemberName"];
        item.toMemberPhone = [reset stringForColumn:@"toMemberPhone"];
        item.toAmount = [reset stringForColumn:@"toAmount"];
        item.toRemark = [reset stringForColumn:@"toRemark"];
        item.createDate = [reset stringForColumn:@"createDate"];
        
        [mutableArray addObject:item];
    }
    
    [_db_hander close];
    
    return mutableArray;
}

- (NSArray *)getTop5ItemTable_Cantact:(NSString *)memberNo
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"select * from '%@' where fromMemberNo = '%@' order by createDate desc limit 0,5",tableName,memberNo];
    
    FMResultSet *reset = [self executeQuery:sql];
    FPDEBUG(@"rest:%@",reset);
    while (reset.next) {
        ContactsInfo *item = [[ContactsInfo alloc] init];
        item.fromMemberNo = [reset stringForColumn:@"fromMemberNo"];
        item.toMemberNo = [reset stringForColumn:@"toMemberNo"];
        item.toMemberAvator = [reset stringForColumn:@"toMemberAvator"];
        item.toMemberName = [reset stringForColumn:@"toMemberName"];
        item.toMemberPhone = [reset stringForColumn:@"toMemberPhone"];
        item.toAmount = [reset stringForColumn:@"toAmount"];
        item.toRemark = [reset stringForColumn:@"toRemark"];
        item.createDate = [reset stringForColumn:@"createDate"];
        
        [mutableArray addObject:item];
    }
    
    [_db_hander close];
    
    return mutableArray;
}

- (BOOL)selectTable_Cantact:(ContactsInfo *)item
{
    BOOL result = NO;
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"select recordNo from '%@' where fromMemberNo = '%@' and toMemberNo = '%@'",tableName,item.fromMemberNo,item.toMemberNo];
    
    FMResultSet *reset = [self executeQuery:sql];
    while (reset.next) {
        [_db_hander close];
        result =  YES;
        break;
    }
    
    return result;
}

- (BOOL)updateTable_Cantact:(ContactsInfo *)item
{
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"update '%@' set toMemberAvator = '%@', toMemberName = '%@',toMemberPhone = '%@', toAmount = '%@' , toRemark = '%@',createDate = datetime() where fromMemberNo = '%@' and toMemberNo = '%@'",tableName,item.toMemberAvator,item.toMemberName,item.toMemberPhone,item.toAmount,item.toRemark,item.fromMemberNo,item.toMemberNo];
    
    return [self executeUpdate:sql];
}

- (BOOL)updateIfExistTable_Cantact:(ContactsInfo *)item
{
    BOOL result = NO;
    
    result = [self selectTable_Cantact:item];
    if (result) {
        result = [self updateTable_Cantact:item];
    } else {
        result = [self insertTable_Cantact:item];
    }
    
    return result;
}

//删除联系人表某条数据
- (BOOL)deleteTable_CantactWhereToMember:(ContactsInfo *)item{
    
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where fromMemberNo = '%@' and toMemberNo = '%@'",tableName,item.fromMemberNo,item.toMemberNo];
    
    return [self executeUpdate:sql];
}
//删除联系人表数据
- (BOOL)deleteTable_Cantact
{
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"delete from '%@'",tableName];
    
    return [self executeUpdate:sql];
}

//删除表
- (BOOL)dropTable_Cantact
{
    NSString *tableName = [NSString stringWithFormat:@"%@%@",kDBPrefix,@"cantact"];
    NSString *sql = [NSString stringWithFormat:@"drop table '%@'",tableName];
    
    return [self executeUpdate:sql];
}

@end
