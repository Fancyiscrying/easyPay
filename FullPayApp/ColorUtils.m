//
//  ColorUtils.m
//  FullPayApp
//
//  Created by mark zheng on 13-9-9.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "ColorUtils.h"

@implementation ColorUtils

+(UIColor *)convertColor:(NSString *)colorStr
{
    NSMutableDictionary *data;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:COLORFILE ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *color =  [data objectForKey:colorStr];
        if (color) {
            return [self hexStringToColor:color];
        } else {
            return [UIColor blackColor];
        }
    } else {
        FPDEBUG(@"ColorUtils:Not exit %@",plistPath);
        return [UIColor blackColor];
    }
}

+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end

//UIColor *MCOLOR(NSString *colorStr)
//{
//    ColorUtils *convert = [[ColorUtils alloc] init];
//    
//    return [convert convertColor:colorStr];
//}

/* 颜色控制：通过字符串来管理 可以方便管理*/
UIColor *MCOLOR(NSString *colorStr)
{
    return [ColorUtils convertColor:colorStr];
}

