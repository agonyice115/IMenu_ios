//
//  CartBar.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "CartBar.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "CartData.h"
#import "IMPopViewController.h"
#import "CartViewController.h"

@interface CartBar ()

@property (nonatomic, strong) UILabel *cartCount;
@property (nonatomic, strong) UILabel *cartTotal;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation CartBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CartDataChanged:) name:CART_DATA_CHANGED object:nil];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 0, 50, BOTTOM_BAR_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = @"15单品";
        [self addSubview:label];
        self.cartCount = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 130, BOTTOM_BAR_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = @"合计:￥4335.00";
        [self addSubview:label];
        self.cartTotal = label;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320-100, 1, 99, BOTTOM_BAR_HEIGHT-2);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"next_highlight"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"next_normal"] forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor colorWithHtmlColor:@"#0088ff"];
        [button setTitle:@"发布动态" forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -23, 0, 24);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 2, -59);
        [button addTarget:self action:@selector(onClickCartButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1.0f);
        self.layer.shadowOpacity = 0.5f;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[CartData sharedCartData] saveData];
}

- (void)CartDataChanged:(NSNotification *)notification
{
    [self refreshCartBar];
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

- (void)refreshCartBar
{
    if (![self.storeId isEqualToString:[CartData sharedCartData].storeId] || [CartData sharedCartData].menuCount == 0)
    {
        [self hideCartBar];
    }
    else
    {
        self.cartCount.text = [NSString stringWithFormat:@"%d单品", [CartData sharedCartData].menuCount];
        self.cartTotal.text = [NSString stringWithFormat:@"合计:￥%.2f", [CartData sharedCartData].totalPrice];
        
        [self showCartBar];
    }
}

- (void)showCartBar
{
    if (self.isShow)
    {
        return;
    }
    
    self.isShow = YES;
    
    CGRect rect = self.frame;
    rect.origin.y -= BOTTOM_BAR_HEIGHT;
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.frame = rect;
    }];
}

- (void)hideCartBar
{
    if (!self.isShow)
    {
        return;
    }
    
    self.isShow = NO;
    
    CGRect rect = self.frame;
    rect.origin.y += BOTTOM_BAR_HEIGHT;
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.frame = rect;
    }];
}

- (void)onClickCartButton
{
    if (self.presentedViewController && self.presentedViewController.parentViewController)
    {
        IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
        viewController.bottomAnimation = NO;
        
        CartViewController *vc = [[CartViewController alloc] initWithNibName:nil bundle:nil];
        [viewController setRootViewController:vc withTitle:NSLocalizedString(@"cart_view_title", nil) animated:NO];
        
        [self.presentedViewController.parentViewController presentViewController:viewController animated:YES completion:nil];
    }
}

@end
