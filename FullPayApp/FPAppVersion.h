//
//  FPAppVersion.h
//  FullPayApp
//
//  Created by mark zheng on 13-11-11.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPMethodMap.h"

@interface FPAppVersion : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;
@property (readonly) NSString *clientVersion;
@property (readonly) BOOL   forceUpdate;
@property (readonly) BOOL   needUpdate;
@property (readonly) NSString *serverVersion;
@property (readonly) NSString *updateUrl;
@property (readonly) FPMethodMap   *methodMap;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)checkAppVersion:(BOOL)funcFlag andBlock:(void(^)(FPAppVersion *appVersion,NSError *error))block;

@end
