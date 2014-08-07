//
//  RoundHeadView.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "RoundHeadView.h"
#import "UIColor+HtmlColor.h"

#define kCornerRadius 3.0f

@implementation RoundHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.roundSideWidth = 3.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *fillColor = [UIColor colorWithHtmlColor:@"#787878"];
    
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineWidth(context, 0.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if (self.headPic)
    {
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, CGRectInset(rect, self.roundSideWidth, self.roundSideWidth));
        CGContextClip(context);
        [self.headPic drawInRect:rect];
        CGContextRestoreGState(context);
    }
    
    if (self.vipPic)
    {
        CGSize size = self.vipPic.size;
        [self.vipPic drawInRect:CGRectMake(rect.size.width-size.width/2,
                                           rect.size.height-size.height/2,
                                           size.width/2,
                                           size.height/2)];
    }
    
    if (self.index)
    {
        rect = CGRectMake(rect.size.width-25, rect.size.height-20, 25, 20);
        CGContextSetLineWidth(context, 1.0f);
        UIColor *strokeColor = [UIColor colorWithHtmlColor:@"#ffffff"];
        fillColor = [[UIColor colorWithHtmlColor:@"#008fff"] colorWithAlphaComponent:0.7f];
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextMoveToPoint(context, CGRectGetMinX(rect)+kCornerRadius, CGRectGetMinY(rect));
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect)+kCornerRadius, kCornerRadius);
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect)-kCornerRadius, CGRectGetMaxY(rect), kCornerRadius);
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect)-kCornerRadius, kCornerRadius);
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect)+kCornerRadius, CGRectGetMinY(rect), kCornerRadius);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        [strokeColor set];
        [self.index drawInRect:rect withFont:[UIFont systemFontOfSize:15.0f] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    }
}

- (void)setHeadPic:(UIImage *)headPic
{
    _headPic = headPic;
    
    [self setNeedsDisplay];
}

- (void)setVipPic:(UIImage *)vipPic
{
    _vipPic = vipPic;
    
    [self setNeedsDisplay];
}

- (void)setIndex:(NSString *)index
{
    _index = index;
    
    [self setNeedsDisplay];
}

@end
