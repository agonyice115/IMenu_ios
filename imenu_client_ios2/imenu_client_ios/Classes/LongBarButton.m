//
//  LongBarButton.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-6.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "LongBarButton.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@interface LongBarButton ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation LongBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 0, (self.bounds.size.width-20-PAGE_MARGIN*2)/2, self.bounds.size.height)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.numberOfLines = 2;
        self.title.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.title];
        
        self.subTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width-20)/2, self.bounds.size.height/2-10, (self.bounds.size.width-20-PAGE_MARGIN*2)/2, 20.0f)];
        self.subTitle.backgroundColor = [UIColor clearColor];
        self.subTitle.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.subTitle.textAlignment = NSTextAlignmentRight;
        self.subTitle.textColor = [UIColor colorWithHtmlColor:@"#ccd0d4"];
        [self addSubview:self.subTitle];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-PAGE_MARGIN, self.bounds.size.height/2-10, 20, 20)];
        self.imageView.image = [UIImage imageNamed:@"right_more_normal"];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)setImage:(UIImage *)image
{
    self.title.frame = CGRectMake(PAGE_MARGIN+30.0f, 0, (self.bounds.size.width-20-PAGE_MARGIN*2)/2-30.0f, self.bounds.size.height);
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, self.bounds.size.height/2-10, 20, 20)];
    icon.image = image;
    [self addSubview:icon];
}

- (void)setIconView:(UIImageView *)iconView
{
    if (_iconView)
    {
        [_iconView removeFromSuperview];
    }
    
    _iconView = iconView;
    
    self.title.frame = CGRectMake(PAGE_MARGIN+30.0f, 0, (self.bounds.size.width-20-PAGE_MARGIN*2)/2-30.0f, self.bounds.size.height);
    iconView.center = CGPointMake(PAGE_MARGIN+10, self.bounds.size.height/2);
    
    [self addSubview:iconView];
}

- (void)setNoRightMore
{
    self.imageView.hidden = YES;
    self.subTitle.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2-10, (self.bounds.size.width-PAGE_MARGIN*2)/2, 20.0f);
}

- (void)setNoSubTitle
{
    if (_iconView)
    {
        if (self.imageView.hidden)
        {
            self.title.frame = CGRectMake(PAGE_MARGIN+30.0f, 0, self.bounds.size.width-PAGE_MARGIN*2-30.0f, self.bounds.size.height);
        }
        else
        {
            self.title.frame = CGRectMake(PAGE_MARGIN+30.0f, 0, self.bounds.size.width-20-PAGE_MARGIN*2-30.0f, self.bounds.size.height);
        }
    }
    else
    {
        if (self.imageView.hidden)
        {
            self.title.frame = CGRectMake(PAGE_MARGIN, 0, self.bounds.size.width-PAGE_MARGIN*2, self.bounds.size.height);
        }
        else
        {
            self.title.frame = CGRectMake(PAGE_MARGIN, 0, self.bounds.size.width-20-PAGE_MARGIN*2, self.bounds.size.height);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [UIImage imageNamed:@"right_more_highlight"];
    if (self.iconView && self.highlightIcon)
    {
        self.iconView.image = self.highlightIcon;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [UIImage imageNamed:@"right_more_normal"];
    if (self.iconView && self.normalIcon)
    {
        self.iconView.image = self.normalIcon;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [UIImage imageNamed:@"right_more_normal"];
    if (self.iconView && self.normalIcon)
    {
        self.iconView.image = self.normalIcon;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [UIImage imageNamed:@"right_more_normal"];
    if (self.iconView && self.normalIcon)
    {
        self.iconView.image = self.normalIcon;
    }
    
    if (self.target && [self.target respondsToSelector:self.action])
    {
        [self.target performSelector:self.action withObject:self afterDelay:0];
    }
}

- (void)setBgViewType:(IMBgViewType)bgViewType
{
    self.backgroundColor = [UIColor clearColor];
    
    IMBgView *bgView = [[IMBgView alloc] initWithFrame:CGRectMake(5, 0, 310, self.bounds.size.height)];
    bgView.borderType = bgViewType;
    [self addSubview:bgView];
    
    [self sendSubviewToBack:bgView];
}

@end
