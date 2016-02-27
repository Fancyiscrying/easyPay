//
//  NormalCircle.m
//  SuQian
//
//  Created by Suraj on 24/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import "NormalCircle.h"
#import <QuartzCore/QuartzCore.h>

#define kOuterColor			[UIColor colorWithRed:128.0/255.0 green:127.0/255.0 blue:123.0/255.0 alpha:0.9]
#define kInnerColor			[UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:0.75]
#define kHighlightColor	[UIColor colorWithRed:255.0/255.0 green:252.0/255.0 blue:78.0/255.0 alpha:0.9]

@implementation NormalCircle
@synthesize selected,cacheContext;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}

- (id)initwithRadius:(CGFloat)radius
{
	CGRect frame = CGRectMake(0, 0, 1.6*radius, 1.6*radius);
	NormalCircle *circle = [self initWithFrame:frame];
	if (circle) {
		[circle setBackgroundColor:[UIColor clearColor]];
	}
	return circle;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	self.cacheContext = context;
	CGFloat lineWidth = 1.0;
	CGRect rectToDraw = CGRectMake(rect.origin.x+lineWidth+0.4*rect.size.width, rect.origin.y+lineWidth+0.4*rect.size.height, 0.2*rect.size.width-2*lineWidth, 0.2*rect.size.height-2*lineWidth);
    
    if (_isTop==YES) {
        
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, kOuterColor.CGColor);
        CGContextStrokeEllipseInRect(context, rectToDraw);
        
        // Fill inner part
        if (_isSelected == YES) {
            CGRect innerRect = CGRectInset(rectToDraw,1, 1);
            CGContextSetFillColorWithColor(context, [ColorUtils hexStringToColor:@"35a4fe"].CGColor);
            //FFAA22
            CGContextFillEllipseInRect(context, innerRect);
        }else{
            CGRect innerRect = CGRectInset(rectToDraw,1, 1);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillEllipseInRect(context, innerRect);
        }
        
    }else{
        
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextStrokeEllipseInRect(context, rectToDraw);
        
        // Fill inner part
        CGRect innerRect = CGRectInset(rectToDraw,1, 1);
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextFillEllipseInRect(context, innerRect);
        
	}
	if(self.selected == NO)
		return;
	
	// For selected View
    CGRect outRect = CGRectInset(rectToDraw,-16, -16);
	CGContextSetFillColorWithColor(context, [ColorUtils hexStringToColor:@"#35a4fe"].CGColor);
	CGContextFillEllipseInRect(context, outRect);
    //FFAA22
    
    CGRect BGRect = CGRectInset(rectToDraw,-14, -14);
	CGContextSetFillColorWithColor(context, [ColorUtils hexStringToColor:@"#28252c"].CGColor);
	CGContextFillEllipseInRect(context, BGRect);
    //1199BB
    
	CGRect smallerRect = CGRectInset(rectToDraw,-14, -14);
	CGContextSetFillColorWithColor(context, [ColorUtils hexStringToColor:@"#35a4fe"].CGColor);
    //2C2C2C
    
    CGContextRef alphaRect = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(alphaRect, 0.2);
	CGContextFillEllipseInRect(context, smallerRect);
    

}

- (void)highlightCell
{
	self.selected = YES;
	[self setNeedsDisplay];
}

- (void)resetCell
{
	self.selected = NO;
	[self setNeedsDisplay];
}


@end
