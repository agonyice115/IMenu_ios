//
//  NoteView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "NoteView.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"

@implementation NoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *stokeColor = [UIColor colorWithHtmlColor:@"#888888"];
    UIColor *fillColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    
    CGContextSetStrokeColorWithColor(context, stokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineWidth(context, 0.0f);
    
    CGContextSaveGState(context);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 0.8f, [UIColor colorWithWhite:0.6f alpha:0.4f].CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-20);
    CGContextAddLineToPoint(context, rect.size.width-20, rect.size.height-1);
    CGContextAddLineToPoint(context, 0, rect.size.height-1);
    CGContextAddLineToPoint(context, 0, 0);
    
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
    
    CGContextSetLineWidth(context, 0.5f);
    float lengths[] = {3, 3};
    
    for (float height = 40.0f; height < rect.size.height-40; height += NOTE_LINE_HEIGHT)
    {
        CGContextSetLineDash(context, 0, lengths, 2);
        CGContextMoveToPoint(context, 10, height);
        CGContextAddLineToPoint(context, rect.size.width-20, height);
        CGContextStrokePath(context);
    }
}

@end
