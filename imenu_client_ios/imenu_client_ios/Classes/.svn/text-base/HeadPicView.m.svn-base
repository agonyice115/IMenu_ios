//
//  HeadPicView.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-8.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "HeadPicView.h"
#import "UIColor+HtmlColor.h"

@interface HeadPicView ()

@property (nonatomic, assign) BOOL isPress;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation HeadPicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float centerX = self.bounds.size.width/2;
    float centerY = self.bounds.size.height/2;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *fillColor = [UIColor colorWithHtmlColor:@"#787878"];
    UIColor *strokeColor = [fillColor colorWithAlphaComponent:0.8f];
    
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineWidth(context, 8.0f);
    CGContextAddArc(context, centerX, centerY, 50, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if (self.headPic)
    {
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, CGRectMake(centerX-50, centerY-50, 100, 100));
        CGContextClip(context);
        [self.headPic drawInRect:CGRectMake(centerX-50, centerY-50, 100, 100)];
        CGContextRestoreGState(context);
    }
    else
    {
        UIImage *camera = self.isPress ? [UIImage imageNamed:@"camera_highlight"] : [UIImage imageNamed:@"camera_normal"];
        [camera drawInRect:CGRectMake(centerX-18, centerY-18, 36, 36)];
    }
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)setHeadPic:(UIImage *)headPic
{
    _headPic = headPic;
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isPress = YES;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isPress = NO;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, touchPoint))
    {
        self.isPress = NO;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isPress)
    {
        self.isPress = NO;
        [self setNeedsDisplay];
        
        if (self.target && [self.target respondsToSelector:self.action])
        {
            [self.target performSelector:self.action withObject:self afterDelay:0];
        }
    }
}

@end
