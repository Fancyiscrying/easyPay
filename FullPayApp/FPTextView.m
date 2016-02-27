//
//  FPTextView.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPTextView.h"

@implementation FPTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320, 50)];
        [topView setBarStyle:UIBarStyleBlackTranslucent];
        UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
        [doneButton setTintColor:[UIColor whiteColor]];
        NSArray *buttonArray = [NSArray arrayWithObjects:button1,button2,doneButton, nil];
        [topView setItems:buttonArray];
        
        [self setInputAccessoryView:topView];
    }
    return self;
}

-(void)resignKeyboard
{
    [self resignFirstResponder];
    if (self.delegateDone) {
        [self.delegateDone clickDone:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
