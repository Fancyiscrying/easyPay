//
//  FPAdvertiseInfo.h
//  FullPayApp
//
//  Created by mark zheng on 13-12-24.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPAdvertiseInfo : NSObject

@property (nonatomic,assign) BOOL hasSee;
@property (nonatomic,assign) NSInteger seqNo;

- (id)initWithSeqNo:(NSInteger )seqNo andHasSee:(BOOL)hasSee;

@end
