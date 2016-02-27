//
//  FPTextField.m
//  FullPayApp
//
//  Created by mark zheng on 13-8-29.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPTextField.h"

@interface FPTextField()

@property (nonatomic, assign) BOOL withRectOffset;

@end

@implementation FPTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _withRectOffset = YES;
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

- (id)initWithNoRectOffsetFrame:(CGRect)frame{
    self = [self initWithFrame:frame];
    _withRectOffset = NO;
    
    return self;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
//    return CGRectInset(bounds, 50, 5);
    if (_withRectOffset) {
        return CGRectMake(60, 0, bounds.size.width - 60.0, bounds.size.height);
    }else {
        return CGRectMake(10, 0, bounds.size.width - 10.0, bounds.size.height);
    }
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
//    return CGRectInset(bounds, 50, 5);
    if (_withRectOffset) {
        return CGRectMake(60, 0, bounds.size.width - 60.0, bounds.size.height);
    }else {
        return CGRectMake(10, 0, bounds.size.width - 10.0, bounds.size.height);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_withRectOffset) {
        CGRect leftViewFrame = self.leftView.frame;
        leftViewFrame.origin.x += 20.0f;
        self.leftView.frame = leftViewFrame;
    }
    
}

//-(void)drawRect:(CGRect)rect
//{
//    UIImage *backgroundImage = [[UIImage imageNamed:@"Box 07.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 5.0, 15.0, 5.0)];
//    
//    [backgroundImage drawInRect:[self bounds]];
//}

-(void)resignKeyboard
{
    [self resignFirstResponder];
    if (self.delegateDone) {
        [self.delegateDone clickDone:self];
    }
}

@end
