//
//  ShopTopBar.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopTopBar.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "RoundHeadView.h"
#import "TFTools.h"
#import <SDWebImage/SDWebImageManager.h>

@interface ShopTopBar ()

@property (nonatomic, strong) RoundHeadView *headView;
@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UIImageView *vipView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation ShopTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, self.bounds.size.height/2-IMAGE_SIZE_TINY/2, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
        self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
        self.headView.roundSideWidth = 1.0f;
        [self addSubview:self.headView];
        
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_TINY+10, self.bounds.size.height/2-10, 160, 20)];
        self.shopName.backgroundColor = [UIColor clearColor];
        self.shopName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.shopName.textAlignment = NSTextAlignmentLeft;
        self.shopName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.shopName];
        
        self.vipView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+115, self.bounds.size.height/2-10, 33, 20)];
        [self addSubview:self.vipView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-PAGE_MARGIN, self.bounds.size.height/2-10, 20, 20)];
        self.imageView.image = [UIImage imageNamed:@"right_more_normal"];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [UIImage imageNamed:@"right_more_highlight"];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [UIImage imageNamed:@"right_more_normal"];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [UIImage imageNamed:@"right_more_normal"];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [UIImage imageNamed:@"right_more_normal"];
    
    if (self.target && [self.target respondsToSelector:self.action])
    {
        [self.target performSelector:self.action withObject:self afterDelay:0];
    }
}

- (void)setStoreData:(NSDictionary *)storeData
{
    _storeData = storeData;
    
    self.shopName.text = storeData[@"store_name"];
    [self.shopName sizeToFit];
    if (self.shopName.frame.size.width > 160)
    {
        self.shopName.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_TINY+10, self.bounds.size.height/2-10, 160, 20);
    }
    self.vipView.frame = CGRectMake(CGRectGetMaxX(self.shopName.frame)+5, self.bounds.size.height/2-10, 33, 20);
    
    self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:storeData[@"store_logo_location"] andName:storeData[@"store_logo_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    NSString *vipLevel = storeData[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"shop_vip_%@@2x.png", vipLevel]];
    }
}

- (void)setUserData:(NSDictionary *)userData
{
    _userData = userData;
    
    self.shopName.text = userData[@"member_name"];
    [self.shopName sizeToFit];
    if (self.shopName.frame.size.width > 160)
    {
        self.shopName.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_TINY+10, self.bounds.size.height/2-10, 160, 20);
    }
    self.vipView.frame = CGRectMake(CGRectGetMaxX(self.shopName.frame)+5, self.bounds.size.height/2-10, 20, 20);
    
    self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:userData[@"icon_location"] andName:userData[@"icon_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    NSString *vipLevel = userData[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_vip_%@@2x.png", vipLevel]];
    }
}

- (void)setHideRightMore:(BOOL)hideRightMore
{
    _hideRightMore = hideRightMore;
    self.imageView.hidden = hideRightMore;
}

@end
