//
//  ColorUtils.h
//  FullPayApp
//
//  Created by mark zheng on 13-9-9.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLORFILE @"AppColorMgr"

@interface ColorUtils : NSObject

+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

+(UIColor *)convertColor:(NSString *)colorStr;

@end

//UIColor *MCOLOR(NSString *colorStr);
UIColor *MCOLOR(NSString *colorStr);