//
//  Config.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "Config.h"

@implementation Config

//自动登录设置
-(BOOL)isAutoLogin
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:kAutoLoginPattern];
    if (value) {
        return [value boolValue];
    }
    
    return NO;
}

- (void)setAutoLogin:(BOOL)autoLogin
{
    @synchronized(self){
        NSUserDefaults *stdDefault = [NSUserDefaults standardUserDefaults];
        [stdDefault removeObjectForKey:kAutoLoginPattern];
        [stdDefault setValue:[NSNumber numberWithBool:autoLogin] forKey:kAutoLoginPattern];
        [stdDefault synchronize];
    }
}

-(NSString *)memberNo
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting stringForKey:@"memberNo"];
    
    return value;
}

-(void)setMemberNo:(NSString *)memberNo
{
    @synchronized(self){
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:@"memberNo"];
        if (memberNo != nil) {
            [setting setObject:[NSString stringWithFormat:@"%@",memberNo] forKey:@"memberNo"];
            [setting synchronize];
        }
    }
}

-(NSString *)token
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting stringForKey:@"token"];
    
    return value;
}

-(void)setToken:(NSString *)token
{
    @synchronized(self){
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:@"token"];
        if (token != nil) {
            [setting setObject:[NSString stringWithFormat:@"%@",token] forKey:@"token"];
            [setting synchronize];
        }
    }
}

/*
 app全局参数
 */
-(FPAppParams *)appParams
{
    FPAppParams *variable = [[FPAppParams alloc] init];
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSData *data = [setting objectForKey:@"FPAppParams"];

    if (data) {
        variable = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    } else {
        variable = nil;
    }
    
    return variable;
}

-(void)setAppParams:(FPAppParams *)appParams
{
    @synchronized(self)
    {
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:@"FPAppParams"];
        if (appParams) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appParams];
            [setting setObject:data forKey:@"FPAppParams"];
        }
        [setting synchronize];
    }
}

-(FPPersonMember *)personMember
{
    FPPersonMember *memberInfo = [[FPPersonMember alloc] init];
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSData *memberData = [setting objectForKey:@"personMember"];
    if (memberData) {
        memberInfo = [NSKeyedUnarchiver unarchiveObjectWithData:memberData] ;
    } else {
        memberInfo = nil;
    }
    
    return memberInfo;
}

-(void)setPersonMember:(FPPersonMember *)personMember
{
    @synchronized(self){
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:@"personMember"];
        if (personMember) {
            NSData *memberData = [NSKeyedArchiver archivedDataWithRootObject:personMember];
            [setting setObject:memberData forKey:@"personMember"];
        }
        [setting synchronize];
    }
}

//方法开关
-(FPMethodMap *)methodMap
{
    FPMethodMap *variable = [[FPMethodMap alloc] init];
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSData *data = [setting objectForKey:@"FPMethodMap"];
    if (data) {
        variable = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    } else {
        variable = nil;
    }
    
    return variable;
}

-(void)setMethodMap:(FPMethodMap *)methodMap
{
    @synchronized(self)
    {
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:@"FPMethodMap"];
        if (methodMap) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:methodMap];
            [setting setObject:data forKey:@"FPMethodMap"];
        }
        [setting synchronize];
    }
}

/*
 彩票信息
 */
-(FPLotterySign *)lotterySign
{
    FPLotterySign *variable = [[FPLotterySign alloc] init];
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSData *data = [setting objectForKey:@"lotterysign"];
    if (data) {
        variable = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    } else {
        variable = nil;
    }
    
    return variable;
}

-(void)setLotterySign:(FPLotterySign *)lotterySign
{
    @synchronized(self)
    {
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:@"lotterysign"];
        if (lotterySign) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lotterySign];
            [setting setObject:data forKey:@"lotterysign"];
        }
        [setting synchronize];
    }
}

/*
 //资产信息
 */
-(FPAccountInfoItem *)accountItem
{
    FPAccountInfoItem *variable = [[FPAccountInfoItem alloc] init];
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSData *data = [setting objectForKey:@"accountItem"];
    if (data) {
        variable = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    } else {
        variable = nil;
    }
    
    return variable;
}

- (void)setAccountItem:(FPAccountInfoItem *)accountItem
{
    @synchronized(self)
    {
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:@"accountItem"];
        if (accountItem) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accountItem];
            [setting setObject:data forKey:@"accountItem"];
        }
        [setting synchronize];
    }
}

-(NSString *)getIOSGuid
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"guid"];
    if (value && [value isEqualToString:@""] == NO) {
        return value;
    }
    else
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString * uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        if (uuidString != nil) {
            [settings setObject:uuidString forKey:@"guid"];
            [settings synchronize];
        }
        return uuidString;
    }
}

/*图片名称*/
-(NSString *)getHeadAddressByMemberNo:(NSString *)memberNo
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting stringForKey:memberNo];
    
    return value;
}

-(void)setHeadAddress:(NSString *)memberNo andName:(NSString *)imgName
{
    @synchronized(self){
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:memberNo];
        if (imgName != nil) {
            [setting setObject:imgName forKey:memberNo];
            [setting synchronize];
        }
    }
}

-(NSString *)getDataFilePathWithName:(NSString *)pathName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:pathName];
}

/*----------------------------------------------------------------------------*/
//营销广告
#define kAdFileName @"advertiseInformation.plist"
#define kAdEncodeKey @"advertiseInformation"

-(NSString *)getAdFilePath
{
    return [self getDataFilePathWithName:kAdFileName];
}

-(FPAdvertiseInfo *)getAdInfoWithMemberNo:(NSString *)memberNo
{
    BOOL isFound = NO;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getAllAdFileData]];
    NSEnumerator * enumeratorKey = [dict keyEnumerator];
    for (NSString *key in enumeratorKey) {
        if ([key isEqualToString:memberNo] ) {
            isFound = YES;
            break;
        }
    }
    
    if (isFound == YES) {
        return dict[memberNo];
    }
    
    return nil;
}

-(BOOL)saveAdInfo:(NSString *)memberNo andObject:(FPAdvertiseInfo *)adInfoItem
{
    //by archive
    BOOL isFound = NO;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getAllAdFileData]];
    NSEnumerator * enumeratorKey = [dict keyEnumerator];
    for (NSString *key in enumeratorKey) {
        if ([key isEqualToString:memberNo] ) {
            isFound = YES;
            break;
        }
    }
    
    if (isFound == YES) {
        dict[memberNo] = adInfoItem;
    } else {
        if (adInfoItem != nil) {
            [dict setObject:adInfoItem forKey:memberNo];
        }
    }
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:kAdEncodeKey];
    [archiver finishEncoding];
    
    [data writeToFile:[self getAdFilePath] atomically:YES];
    
    return YES;
}

-(NSDictionary *)getAllAdFileData
{
    NSString *paths = [self getAdFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:paths]) {
        NSData *data = [[NSMutableData alloc]initWithContentsOfFile:paths];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        NSDictionary *arrayData = [unarchiver decodeObjectForKey:kAdEncodeKey];
        [unarchiver finishDecoding];
        
        return arrayData;
    }
    return nil;
}

-(BOOL)deleteAdFileData
{
    NSString *paths = [self getAdFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:paths]) {
        [[NSFileManager defaultManager] removeItemAtPath:paths error:nil];
    }
    
    return YES;
}

/*----------------------------------------------------------------------------*/

-(BOOL)isShowDisclaimer:(NSString *)memberNo
{
    NSString *keyName = [NSString stringWithFormat:@"%@-disclaimer",memberNo];
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:keyName];
    if (value && [value isEqualToString:@"1"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)setShowDisclaimer:(NSString *)memberNo andFlag:(BOOL)showDisclaimer
{
    @synchronized(self)
    {
        NSString *keyName = [NSString stringWithFormat:@"%@-disclaimer",memberNo];
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        [setting removeObjectForKey:keyName];
        [setting setObject:showDisclaimer ? @"1" : @"0" forKey:keyName];
        [setting synchronize];
    }
}

//单例模式
static Config * instance = nil;
+(Config *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

@end
