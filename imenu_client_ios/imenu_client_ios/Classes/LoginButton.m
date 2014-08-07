//
//  LoginButton.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-4.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "LoginButton.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"

@implementation LoginButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
        [self setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithHtmlColor:@"#cccccc"] forState:UIControlStateDisabled];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CFMutableArrayRef colors = CFArrayCreateMutable(NULL, 2, NULL);
	CFArrayAppendValue(colors, [[UIColor colorWithHtmlColor:@"#fefefe"] CGColor]);
	CFArrayAppendValue(colors, [[UIColor colorWithHtmlColor:@"#e6e7eb"] CGColor]);
	
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat botY = CGRectGetMaxY(self.bounds);
    CGPoint startPoint = CGPointMake(midX, 0);
    CGPoint endPoint = CGPointMake(midX, botY);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    
	CFRelease(colors);
	CGColorSpaceRelease(colorSpace);
    
    CGGradientRelease(gradient);
}

@end
