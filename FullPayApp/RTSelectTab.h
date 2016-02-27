//
//  RTSelectTab.h
//  ReadilyTao
//
//  Created by lc on 14-8-12.
//  Copyright (c) 2014年 FZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTSelectTabDelegate <NSObject>
@optional
- (void)clickButtonWithButtonIndex:(int)buttonIndex;

@end
@interface RTSelectTab : UIView
@property(nonatomic, strong) NSArray *buttonTitles;
@property(nonatomic, strong) id<RTSelectTabDelegate> delegate;

- (void)setLineLeft:(CGFloat)left andWidth:(CGFloat)width;
- (RTSelectTab*)initWithFrame:(CGRect)frame andButtonTitles:(NSArray*)buttonTitles;
@end
