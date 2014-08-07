//
//  ShopNoMenuCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-6.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopNoMenuCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "ClientConfig.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TFTools.h"
#import "RoundHeadView.h"

@interface ShopNoMenuCell ()

@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UILabel *shopAddress;
@property (nonatomic, strong) UIImageView *vipView;
@property (nonatomic, strong) UIView *serviceView;
@property (nonatomic, strong) NSMutableArray *serviceViews;
@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UIImageView *kindImageView;
@property (nonatomic, strong) UILabel *kindString;

@property (nonatomic, strong) UIView *popularView;
@property (nonatomic, strong) NSMutableArray *popularViews;

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation ShopNoMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        float y = 10.0f;
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, y, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.headView.roundSideWidth = 2.0f;
        self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
        [self.headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShop)]];
        [self addSubview:self.headView];
        
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN*2+IMAGE_SIZE_SMALL, y, 190, 20)];
        self.shopName.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        self.shopName.lineBreakMode = NSLineBreakByTruncatingTail;
        self.shopName.textAlignment = NSTextAlignmentLeft;
        self.shopName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.shopName.userInteractionEnabled = YES;
        [self.shopName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShop)]];
        [self addSubview:self.shopName];
        
        self.shopAddress = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN*2+IMAGE_SIZE_SMALL, y+25, 220, 20)];
        self.shopAddress.font = [UIFont boldSystemFontOfSize:THIRD_FONT_SIZE];
        self.shopAddress.lineBreakMode = NSLineBreakByTruncatingTail;
        self.shopAddress.textAlignment = NSTextAlignmentLeft;
        self.shopAddress.textColor = [UIColor colorWithHtmlColor:@"#888888"];
        self.shopAddress.text = @"地址：雁塔路78号大院里287栋903室";
        [self addSubview:self.shopAddress];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 20)];
        [self addSubview:imageView];
        self.vipView = imageView;
        
        y += 10 + IMAGE_SIZE_SMALL;
        self.kindImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, y+3, 10, 13)];
        self.kindImageView.image = [UIImage imageNamed:@"map_highlight@2x.png"];
        [self addSubview:self.kindImageView];
        
        self.kindString = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+13, y, 100, 20)];
        self.kindString.backgroundColor = [UIColor clearColor];
        self.kindString.text = @"距离：50米";
        self.kindString.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.kindString.textColor = [UIColor colorWithHtmlColor:@"#787878"];
        [self addSubview:self.kindString];
        
        self.popularView = [[UIView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+50, y, 120, 20)];
        self.popularView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.popularView];
        
        self.popularViews = [NSMutableArray array];
        for (int i = 0; i < 5; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
            imageView.center = CGPointMake(7+i*15, 10);
            imageView.image = [UIImage imageNamed:@"popular_dark.png"];
            [self.popularView addSubview:imageView];
            [self.popularViews addObject:imageView];
        }
        
        self.serviceView = [[UIView alloc] initWithFrame:CGRectMake(214-PAGE_MARGIN, y, 86, 20)];
        self.serviceView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.serviceView];
        
        self.serviceViews = [NSMutableArray array];
        for (int i = 0; i < 4; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((3-i)*22, 0, 20, 20)];
            [self.serviceView addSubview:imageView];
            [self.serviceViews addObject:imageView];
        }
        
        UIImageView *rightMore = [[UIImageView alloc] initWithFrame:CGRectMake(290, 40, 20, 20)];
        rightMore.image = [UIImage imageNamed:@"right_more_normal"];
        [self addSubview:rightMore];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
    
    self.headView.index = [NSString stringWithFormat:@"%d", index];
}

- (void)setData:(NSDictionary *)data withType:(NSUInteger)type
{
    self.data = data;
    
    self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:data[@"store_logo_location"] andName:data[@"store_logo_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    self.shopName.text = data[@"store_name"];
    self.shopAddress.text = data[@"address"];
    [self.shopName sizeToFit];
    if (self.shopName.frame.size.width > 190)
    {
        self.shopName.frame = CGRectMake(PAGE_MARGIN*2+IMAGE_SIZE_SMALL, 10, 190, 20);
    }
    else
    {
        CGRect frame = self.shopName.frame;
        self.shopName.frame = CGRectMake(PAGE_MARGIN*2+IMAGE_SIZE_SMALL, 10, frame.size.width, 20);
    }
    
    CGPoint center = self.shopName.center;
    float x = CGRectGetMaxX(self.shopName.frame);
    
    NSString *vipLevel = data[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"shop_vip_%@@2x.png", vipLevel]];
        self.vipView.hidden = NO;
        center.x = x + 18;
        self.vipView.center = center;
        x = CGRectGetMaxX(self.vipView.frame);
    }
    else
    {
        self.vipView.hidden = YES;
    }
    
    NSArray *service = [[ClientConfig sharedConfig] getServiceList:data[@"service_list"]];
    if (service && [service count] > 0)
    {
        self.serviceView.hidden = NO;
        int i = 0;
        for (i = 0; i < [service count] && i < 4; i++)
        {
            NSDictionary *serviceDic = service[i];
            UIImageView *imageView = self.serviceViews[i];
            [imageView setImageWithURL:[NSURL URLWithString:serviceDic[@"thumb_image"]]];
            imageView.hidden = NO;
        }
        
        for (i = [service count]; i < 4; i++)
        {
            UIImageView *imageView = self.serviceViews[i];
            imageView.hidden = YES;
        }
    }
    else
    {
        self.serviceView.hidden = YES;
    }
    
    switch (type)
    {
        case 0:
        {
            self.kindString.text = @"人气:";
            CGRect frame = self.kindString.frame;
            frame.origin.x = PAGE_MARGIN+19;
            self.kindString.frame = frame;
            
            self.kindImageView.image = [UIImage imageNamed:@"popular.png"];
            frame = self.kindImageView.frame;
            frame.size.width = 16;
            self.kindImageView.frame = frame;
            
            self.popularView.hidden = NO;
            NSString *popular = data[@"star"];
            int i = 0;
            for (i = 0; i < popular.intValue; i++)
            {
                UIImageView *imageView = self.popularViews[i];
                imageView.image = [UIImage imageNamed:@"popular_light.png"];
            }
            for (i = popular.intValue; i < 5; i++)
            {
                UIImageView *imageView = self.popularViews[i];
                imageView.image = [UIImage imageNamed:@"popular_dark.png"];
            }
        }
            break;
            
        case 1:
        {
            self.kindString.text = [NSString stringWithFormat:@"人均:%@元", data[@"per"]];
            CGRect frame = self.kindString.frame;
            frame.origin.x = PAGE_MARGIN+13;
            self.kindString.frame = frame;
            
            self.kindImageView.image = [UIImage imageNamed:@"price_highlight@2x.png"];
            frame = self.kindImageView.frame;
            frame.size.width = 10;
            self.kindImageView.frame = frame;
            
            self.popularView.hidden = YES;
        }
            break;
            
        case 2:
        {
            self.kindString.text = [NSString stringWithFormat:@"距离:%@", [TFTools getDistaceString:data[@"distance"]]];
            CGRect frame = self.kindString.frame;
            frame.origin.x = PAGE_MARGIN+13;
            self.kindString.frame = frame;
            
            self.kindImageView.image = [UIImage imageNamed:@"map_highlight@2x.png"];
            frame = self.kindImageView.frame;
            frame.size.width = 10;
            self.kindImageView.frame = frame;
            
            self.popularView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (void)clickShop
{
    if (self.delegate)
    {
        [self.delegate onClickTitleWithData:self.data];
    }
}

@end
