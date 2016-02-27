//
//  FPAdvertiseInfo.m
//  FullPayApp
//
//  Created by mark zheng on 13-12-24.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPAdvertiseInfo.h"

@implementation FPAdvertiseInfo

- (id)initWithSeqNo:(NSInteger )seqNo andHasSee:(BOOL)hasSee
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _seqNo = seqNo;
    _hasSee = hasSee;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSNumber *data = [NSNumber numberWithBool:self.hasSee];
    [encoder encodeObject:data forKey:@"AdHasSee"];
    
    data = [NSNumber numberWithInteger:self.seqNo];
    [encoder encodeObject:data forKey:@"AdSeqNo"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.hasSee = [[decoder decodeObjectForKey:@"AdHasSee"] boolValue];
        self.seqNo = [[decoder decodeObjectForKey:@"AdSeqNo"] integerValue];
    }
    return  self;
}

@end
