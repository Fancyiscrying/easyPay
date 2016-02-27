//
//  FPShortcutPayView.h
//  FullPayApp
//
//  Created by 刘通超 on 14/11/26.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FPShortcutPayViewDelegate <NSObject>

-(void)shortcutPayViewClickButtonAtIdexth:(int)buttonIndex;

@end

@interface FPShortcutPayView : UIView

@property (nonatomic, strong) id<FPShortcutPayViewDelegate> delegate;

@end
