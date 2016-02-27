//
//  UtilMacro.h
//  FullPayApp
//
//  Created by mark zheng on 14-5-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#ifndef FullPayApp_UtilMacro_h
#define FullPayApp_UtilMacro_h

#define IS_IPHONE568 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d",intValue]

#define MIMAGE(img) [UIImage imageNamed:img]

#define HeadImageByMember(member) [NSString stringWithFormat:@"%@%@?headMemberNo=%@",[FPClient ServerAddress],kGETIMAGE,member]

#define MIMAGE_COLOR_SIZE(color,imagesize) [ImageUtils createImageWithColor:color size:imagesize]

#define EMPTY_STRING        @""

#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define ScreenHigh [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenBounds [UIScreen mainScreen].bounds
#define NavBarHeight 64

//Font size
#define SystemFontSize(size) [UIFont systemFontOfSize:size]
#define SystemBoldFontSize(size) [UIFont boldSystemFontOfSize:size]

#define ClearColor [UIColor clearColor]
#define COLOR_STRING(str) [ColorUtils hexStringToColor:str]

#ifdef DEBUG
#define FPDEBUG(...) NSLog(__VA_ARGS__)
#define FPDEBUGMETHOD() NSLog(@"%s",__func__)
#else
#define FPDEBUG(...)
#define FPDEBUGMETHOD()
#endif

#endif
