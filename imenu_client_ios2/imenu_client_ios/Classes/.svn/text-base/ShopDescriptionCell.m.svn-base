//
//  ShopDescriptionCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-9.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopDescriptionCell.h"

@interface ShopDescriptionCell ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ShopDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
        self.webView.scrollView.bounces = NO;
        self.webView.opaque = NO;
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.webView];
    }
    return self;
}

- (void)setContentString:(NSString *)content
{
    [self.webView loadHTMLString:content baseURL:nil];
}

@end
