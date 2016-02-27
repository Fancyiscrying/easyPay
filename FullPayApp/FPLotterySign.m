//
//  FPLotterySign.m
//  FullPayApp
//
//  Created by mark zheng on 13-12-13.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPLotterySign.h"

@implementation FPLotterySignData

-(id)initWithDictionary:(NSDictionary *)dictObj
{
    self.data = [dictObj objectForKey:@"data"];
    self.encryptKey = [dictObj objectForKey:@"encryptKey"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.data forKey:@"data"];
    
    [encoder encodeObject:self.encryptKey forKey:@"encryptKey"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.data = [decoder decodeObjectForKey:@"data"];
        self.encryptKey = [decoder decodeObjectForKey:@"encryptKey"];
    }
    return  self;
}

@end

@implementation FPLotterySign

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.allInfo forKey:@"allInfo"];
    [encoder encodeObject:self.gpcInfo forKey:@"gpcInfo"];
    [encoder encodeObject:self.otherInfo forKey:@"otherInfo"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.allInfo = [decoder decodeObjectForKey:@"allInfo"];
        self.gpcInfo = [decoder decodeObjectForKey:@"gpcInfo"];
        self.otherInfo = [decoder decodeObjectForKey:@"otherInfo"];
    }
    return  self;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        if ([attributes objectForKey:@"returnObj"] != [NSNull null]) {
            NSDictionary *object = [attributes objectForKey:@"returnObj"];
            
            NSDictionary *Info = [object objectForKey:@"allinfo"];
            if ([Info count] > 0) {
                
                FPLotterySignData *lot = [[FPLotterySignData alloc] initWithDictionary:Info];
                
                self.allInfo = lot;
            }
            
            NSDictionary *gpcInfo = [object objectForKey:@"gpcAllinfo"];
            if ([gpcInfo count] > 0) {
                
                FPLotterySignData *lot = [[FPLotterySignData alloc] initWithDictionary:gpcInfo];
                
                self.gpcInfo = lot;
            }

            Info = [object objectForKey:@"memberno"];
            if ([Info count] > 0) {
                
                FPLotterySignData *lot = [[FPLotterySignData alloc] initWithDictionary:Info];
                
                self.otherInfo = lot;
            }
            
        } else {
            _result = NO;
            _errorInfo = @"未查询到你所需要的信息";
        }
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}

+ (void)getLotterySignWithBlock:(void(^)(FPLotterySign *lotteryInfo,NSError *error))block
{
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userLotteryGenerateSign:memberNo];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-(void)getGenerateSign:%@",responseObject);
        FPLotterySign *lotteryData = [[FPLotterySign alloc] initWithAttributes:responseObject];
        if (block) {
            block(lotteryData,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
