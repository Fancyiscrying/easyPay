//
//  FPAccountInfo.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-26.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPAccountInfo.h"

@implementation FPAccountInfoItem

- (id)initWithDictionary:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _accountAmount = [attributes objectForKey:@"accountAmount"];
    _fumiCount = [attributes objectForKey:@"fumi"];
    _cardsAccount = [[attributes objectForKey:@"cardsAccount"] integerValue];
    _bankCardCount = [[attributes objectForKey:@"bankCardCount"] integerValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.accountAmount forKey:@"accountAmount"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.cardsAccount] forKey:@"cardsAccount"];
    [encoder encodeObject:self.fumiCount forKey:@"fumiCount"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.accountAmount = [decoder decodeObjectForKey:@"accountAmount"];
        self.cardsAccount = [[decoder decodeObjectForKey:@"cardsAccount"] integerValue];
        self.fumiCount = [decoder decodeObjectForKey:@"fumiCount"];
    }
    
    return self;
}

@end

@implementation FPAccountInfo

-(FPAccountInfo *)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        if ([attributes objectForKey:@"returnObj"] != [NSNull null]) {
            
            NSDictionary *object = [attributes objectForKey:@"returnObj"];
            
            self.accountItem = [[FPAccountInfoItem alloc] initWithDictionary:object];
            [[Config Instance] setAccountItem:self.accountItem];
            
        } else {
            _result = NO;
        }
        
        if (_result == NO) {
            _errorInfo = @"未查询到你所需要的信息";
        }
        
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}

+ (void)getFPAccountInfoWithBlock:(void(^)(FPAccountInfo *cardInfo,NSError *error))block
{
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userAccount:memberNo];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"getFPAccountInfoWithBlock:%@",responseObject);
        FPAccountInfo *accountInfo = [[FPAccountInfo alloc] initWithAttributes:responseObject];
        if (block) {
            block(accountInfo,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
