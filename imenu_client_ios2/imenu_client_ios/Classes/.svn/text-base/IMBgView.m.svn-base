//
//  IMBgView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-12.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMBgView.h"

@implementation IMBgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _borderType = IMBgViewType_Round;
        _cornerRadius = 5.0f;
        
        _borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        _fillColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    rect = CGRectInset(rect, 0.5f, 0.5f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    switch (self.borderType)
    {
        case IMBgViewType_Round:
        {
            CGContextMoveToPoint(context, rect.origin.x+self.cornerRadius, rect.origin.y);
            CGContextAddArcToPoint(context,
                                   rect.size.width,
                                   rect.origin.y,
                                   rect.size.width,
                                   rect.origin.y+self.cornerRadius,
                                   self.cornerRadius);
            CGContextAddArcToPoint(context,
                                   rect.size.width,
                                   rect.size.height,
                                   rect.size.width-self.cornerRadius,
                                   rect.size.height,
                                   self.cornerRadius);
            CGContextAddArcToPoint(context,
                                   rect.origin.x,
                                   rect.size.height,
                                   rect.origin.x,
                                   rect.size.height-self.cornerRadius,
                                   self.cornerRadius);
            CGContextAddArcToPoint(context,
                                   rect.origin.x,
                                   rect.origin.y,
                                   rect.origin.x+self.cornerRadius,
                                   rect.origin.y,
                                   self.cornerRadius);
        }
            break;
            
        case IMBgViewType_RoundTop:
        {
            CGContextMoveToPoint(context, rect.origin.x+self.cornerRadius, rect.origin.y);
            CGContextAddArcToPoint(context,
                                   rect.size.width,
                                   rect.origin.y,
                                   rect.size.width,
                                   rect.origin.y+self.cornerRadius,
                                   self.cornerRadius);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x, rect.size.height);
            CGContextAddArcToPoint(context,
                                   rect.origin.x,
                                   rect.origin.y,
                                   rect.origin.x+self.cornerRadius,
                                   rect.origin.y,
                                   self.cornerRadius);
        }
            break;
            
        case IMBgViewType_RoundMiddle:
        {
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x, rect.size.height);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
            CGContextAddLineToPoint(context, rect.size.width, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        }
            break;
            
        case IMBgViewType_RoundBottom:
        {
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.size.width, rect.origin.y);
            CGContextAddArcToPoint(context,
                                   rect.size.width,
                                   rect.size.height,
                                   rect.size.width-self.cornerRadius,
                                   rect.size.height,
                                   self.cornerRadius);
            CGContextAddArcToPoint(context,
                                   rect.origin.x,
                                   rect.size.height,
                                   rect.origin.x,
                                   rect.size.height-self.cornerRadius,
                                   self.cornerRadius);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        }
            break;
            
        default:
            break;
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)setBorderType:(IMBgViewType)borderType
{
    _borderType = borderType;
    
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    
    [self setNeedsDisplay];
}

@end
