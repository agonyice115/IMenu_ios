//
//  DynamicSectionView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DynamicSectionView.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"

@implementation DynamicSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHtmlColor:@"#e4e6eb"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN, 0, 120, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitle:@"2014年第23周" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"time_dark"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        button.enabled = NO;
        [self addSubview:button];
        self.sectionTitle = button;
        
        self.sectionCount = [[UILabel alloc] initWithFrame:CGRectMake(200-PAGE_MARGIN, 5,
                                                                      120, 20)];
        self.sectionCount.backgroundColor = [UIColor clearColor];
        self.sectionCount.text = @"共15单";
        self.sectionCount.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.sectionCount.textAlignment = NSTextAlignmentRight;
        self.sectionCount.textColor = [UIColor colorWithHtmlColor:@"#888888"];
        [self addSubview:self.sectionCount];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [self addSubview:lineView];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//	
//	CFMutableArrayRef colors = CFArrayCreateMutable(NULL, 2, NULL);
//	CFArrayAppendValue(colors, [[UIColor colorWithHtmlColor:@"#fefefe"] CGColor]);
//	CFArrayAppendValue(colors, [[UIColor colorWithHtmlColor:@"#e6e7eb"] CGColor]);
//	
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
//    CGFloat midX = CGRectGetMidX(self.bounds);
//    CGFloat botY = CGRectGetMaxY(self.bounds);
//    CGPoint startPoint = CGPointMake(midX, 0);
//    CGPoint endPoint = CGPointMake(midX, botY);
//    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
//    
//	CFRelease(colors);
//	CGColorSpaceRelease(colorSpace);
//    
//    CGGradientRelease(gradient);
//}

@end
