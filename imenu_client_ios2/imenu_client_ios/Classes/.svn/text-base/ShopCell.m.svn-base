//
//  ShopCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-19.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopCell.h"
#import "NewDishesView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "UIImage+Color.h"
#import "ClientConfig.h"
#import "TFTools.h"
#import "RoundHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopCell () <UIScrollViewDelegate>

@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UIButton *shopName;
@property (nonatomic, strong) UIView *serviceView;
@property (nonatomic, strong) NSMutableArray *serviceViews;

@property (nonatomic, strong) UIImageView *kindImageView;
@property (nonatomic, strong) UILabel *kindString;

@property (nonatomic, strong) UIImageView *payTypeImageView;
@property (nonatomic, strong) UIImageView *saleImageView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dishesViews;

@property (nonatomic, strong) UIView *popularView;
@property (nonatomic, strong) NSMutableArray *popularViews;

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation ShopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        float y = 5.0f;
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 5, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.headView.roundSideWidth = 2.0f;
        self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
        [self addSubview:self.headView];
        
        self.shopName = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shopName.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+5, y, 160, 20);
        self.shopName.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        self.shopName.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.shopName setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateNormal];
        [self.shopName setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateHighlighted];
        [self.shopName setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHtmlColor:@"#2ca5de"] andSize:CGSizeMake(50, 20)] forState:UIControlStateHighlighted];
        [self.shopName setTitle:@"麦当劳" forState:UIControlStateNormal];
        [self.shopName addTarget:self action:@selector(onClickTitle) forControlEvents:UIControlEventTouchUpInside];
        self.shopName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.shopName.enabled = NO;
        [self addSubview:self.shopName];
        
        y += 25;
        self.kindImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+5, y+3, 10, 13)];
        self.kindImageView.image = [UIImage imageNamed:@"map_highlight@2x.png"];
        [self addSubview:self.kindImageView];
        
        self.kindString = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+13, y, 100, 20)];
        self.kindString.backgroundColor = [UIColor clearColor];
        self.kindString.text = @"距离：50米";
        self.kindString.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.kindString.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        [self addSubview:self.kindString];
        
        self.popularView = [[UIView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+5, y, 120, 20)];
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
        
        self.serviceView = [[UIView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+90, y, 86, 20)];
        self.serviceView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.serviceView];
        
        self.serviceViews = [NSMutableArray array];
        for (int i = 0; i < 4; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*22, 0, 20, 20)];
            [self.serviceView addSubview:imageView];
            [self.serviceViews addObject:imageView];
        }
        
        UIImageView *payType = [[UIImageView alloc] initWithFrame:CGRectMake(320-52, 5, 52, 24)];
        payType.image = [UIImage imageNamed:@"shop_pay_online"];
        [self addSubview:payType];
        self.payTypeImageView = payType;
        
        UIImageView *sale = [[UIImageView alloc] initWithFrame:CGRectMake(320-52, 30, 52, 24)];
        sale.image = [UIImage imageNamed:@"shop_sale"];
        [self addSubview:sale];
        self.saleImageView = sale;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        bgView.backgroundColor = [UIColor clearColor];
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTitle:)]];
        [self addSubview:bgView];
        
        y += 35;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, 320, 110)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.dishesViews = [NSMutableArray array];
        for (int i = 0; i < 10; i++)
        {
            NewDishesView *dishesView = [[NewDishesView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+i*(80+10),
                                                                                  0,
                                                                                  80,
                                                                                  110)];
            [self.scrollView addSubview:dishesView];
            [self.dishesViews addObject:dishesView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [dishesView addGestureRecognizer:singleTap];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data withType:(NSUInteger)type
{
    self.data = data;
    
    [self.shopName setTitle:data[@"store_name"] forState:UIControlStateDisabled];
    
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
    
    NSString *vipLevel = data[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.headView.vipPic = [UIImage imageNamed:[NSString stringWithFormat:@"shop_vip_%@@2x.png", vipLevel]];
    }
    else
    {
        self.headView.vipPic = nil;
    }
    
    NSString *payType = data[@"signing_type"];
    if (payType.intValue == 0)
    {
        self.payTypeImageView.hidden = YES;
    }
    else
    {
        self.payTypeImageView.hidden = NO;
        if (payType.intValue == 1)
        {
            self.payTypeImageView.image = [UIImage imageNamed:@"shop_pay_online"];
        }
        else
        {
            self.payTypeImageView.image = [UIImage imageNamed:@"shop_pay_store"];
        }
    }
    
    NSString *sale = data[@"coupon_type"];
    if (sale.intValue == 0)
    {
        self.saleImageView.hidden = YES;
    }
    else
    {
        self.saleImageView.hidden = NO;
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
    
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    
    NSArray *dishes = data[@"menu_list"];
    if (dishes)
    {
        NSUInteger count = [dishes count];
        
        self.scrollView.contentSize = CGSizeMake(80*count+PAGE_MARGIN*2+count*10-10, 110);
        
        int i = 0;
        for (i = 0; i < count && i < 10; i++)
        {
            NewDishesView *dishesView = self.dishesViews[i];
            dishesView.data = dishes[i];
            dishesView.hidden = NO;
        }
        
        for (i = count; i < 10; i++)
        {
            NewDishesView *dishesView = self.dishesViews[i];
            dishesView.hidden = YES;
        }
    }
    
    switch (type)
    {
        case 0:
        {
            self.kindString.hidden = YES;
            self.kindImageView.hidden = YES;
            
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
            self.kindString.hidden = NO;
            self.kindImageView.hidden = NO;
            
            self.kindString.text = [NSString stringWithFormat:@"人均:%@元", data[@"per"]];
            CGRect frame = self.kindString.frame;
            frame.origin.x = PAGE_MARGIN+13+IMAGE_SIZE_SMALL+5;
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
            self.kindString.hidden = NO;
            self.kindImageView.hidden = NO;
            
            self.kindString.text = [NSString stringWithFormat:@"距离:%@", [TFTools getDistaceString:data[@"distance"]]];
            CGRect frame = self.kindString.frame;
            frame.origin.x = PAGE_MARGIN+13+IMAGE_SIZE_SMALL+5;
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

- (void)onClickTitle
{
    if (self.delegate)
    {
        [self.delegate onClickTitleWithData:self.data];
    }
}

- (void)handleTapTitle:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (self.delegate)
        {
            [self.delegate onClickTitleWithData:self.data];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (self.delegate)
        {
            NewDishesView *view = (NewDishesView *)sender.view;
            [self.delegate onClickDishesWithData:view.data andShopData:self.data];
        }
    }
}

- (void)onClickMore
{
    if (self.delegate)
    {
        [self.delegate onClickMoreWithData:self.data];
    }
}

#pragma mark - UIScrollView 代理方法

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self autoSetContentOffset:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self autoSetContentOffset:scrollView];
}

- (void)autoSetContentOffset:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > scrollView.contentSize.width-320-IMAGE_SIZE_MIDDLE/2)
    {
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width-320, 0) animated:YES];
    }
    else
    {
        int i = scrollView.contentOffset.x / (IMAGE_SIZE_MIDDLE + 10);
        float marginLine = i*(IMAGE_SIZE_MIDDLE+10)+PAGE_MARGIN+IMAGE_SIZE_MIDDLE/2;
        if (scrollView.contentOffset.x < marginLine)
        {
            [scrollView setContentOffset:CGPointMake(marginLine-PAGE_MARGIN-IMAGE_SIZE_MIDDLE/2, 0) animated:YES];
        }
        else
        {
            [scrollView setContentOffset:CGPointMake(marginLine+IMAGE_SIZE_MIDDLE/2+10-PAGE_MARGIN, 0) animated:YES];
        }
    }
}

@end
