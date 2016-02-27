//
//  FPLotterySign.h
//  FullPayApp
//
//  Created by mark zheng on 13-12-13.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPLotterySignData : NSObject
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *encryptKey;

-(id)initWithDictionary:(NSDictionary *)dictObj;

@end

@interface FPLotterySign : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,strong) FPLotterySignData *allInfo;
@property (nonatomic,strong) FPLotterySignData *gpcInfo;

@property (nonatomic,strong) FPLotterySignData *otherInfo;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getLotterySignWithBlock:(void(^)(FPLotterySign *lotterySign,NSError *error))block;

@end
