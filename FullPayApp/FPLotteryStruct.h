//
//  FPLotteryStruct.h
//  FullPayApp
//
//  Created by mark zheng on 13-11-18.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPLotteryObject : NSObject

@property (nonatomic) NSString *modeCode;
@property (nonatomic) NSString *modeName;
@property (nonatomic) NSString *resourceCode;
@property (nonatomic) NSString *resourceName;
@property (nonatomic) NSString *redirectUri;
@property (nonatomic) NSString *desc1;
@property (nonatomic) NSString *desc2;
@property (nonatomic) NSString *seqNo;

-(id)initWithDictionary:(NSDictionary *)dictObj;

@end

@interface FPLotteryStruct : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,strong) NSArray *lotteryList;
@property (nonatomic,strong) NSArray *othermode;
@property (nonatomic,strong) FPLotteryObject *marketingInfo;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getLotteryWithBlock:(void(^)(FPLotteryStruct *lotteryInfo,NSError *error))block;


@end
