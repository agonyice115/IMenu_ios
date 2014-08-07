//
//  ShopCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-19.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopCell.h"
#import "DishesView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "UIImage+Color.h"
#import "ClientConfig.h"
#import "TFTools.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *shopName;
@property (nonatomic, strong) UIImageView *vipView;
@property (nonatomic, strong) UIView *serviceView;
@property (nonatomic, strong) NSMutableArray *serviceViews;

@property (nonatomic, strong) UIImageView *kindImageView;
@property (nonatomic, strong) UILabel *kindString;

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
        
        float y = 10.0f;
        
        self.shopName = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shopName.frame = CGRectMake(PAGE_MARGIN, y, 160, 20);
        self.shopName.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        self.shopName.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.shopName setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
        [self.shopName setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateHighlighted];
        [self.shopName setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHtmlColor:@"#2ca5de"] andSize:CGSizeMake(50, 20)] forState:UIControlStateHighlighted];
        [self.shopName setTitle:@"麦当劳" forState:UIControlStateNormal];
        [self.shopName addTarget:self action:@selector(onClickTitle) forControlEvents:UIControlEventTouchUpInside];
        self.shopName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.shopName.enabled = NO;
        [self addSubview:self.shopName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 20)];
        [self addSubview:imageView];
        self.vipView = imageView;
        
        self.serviceView = [[UIView alloc] initWithFrame:CGRectMake(234-PAGE_MARGIN, y, 86, 20)];
        self.serviceView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.serviceView];
        
        self.serviceViews = [NSMutableArray array];
        for (int i = 0; i < 4; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((3-i)*22, 0, 20, 20)];
            [self.serviceView addSubview:imageView];
            [self.serviceViews addObject:imageView];
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        bgView.backgroundColor = [UIColor clearColor];
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTitle:)]];
        [self addSubview:bgView];
        
        y += 30;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, 320, IMAGE_SIZE_MIDDLE)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.dishesViews = [NSMutableArray array];
        for (int i = 0; i < 10; i++)
        {
            DishesView *dishesView = [[DishesView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+i*(IMAGE_SIZE_MIDDLE+10),
                                                                                  0,
                                                                                  IMAGE_SIZE_MIDDLE,
                                                                                  IMAGE_SIZE_MIDDLE)];
            [self.scrollView addSubview:dishesView];
            [self.dishesViews addObject:dishesView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [dishesView addGestureRecognizer:singleTap];
        }
        y += 10 + IMAGE_SIZE_MIDDLE;
        self.kindImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, y+3, 10, 13)];
        self.kindImageView.image = [UIImage imageNamed:@"map_highlight@2x.png"];
        [self addSubview:self.kindImageView];
        
        self.kindString = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+13, y, 100, 20)];
        self.kindString.backgroundColor = [UIColor clearColor];
        self.kindString.text = @"距离：50米";
        self.kindString.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.kindString.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
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
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320-PAGE_MARGIN-80, y-10, 80, 40);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#787878"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#2ca5de"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"more_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"more_highlight"] forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"显示全部" forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 7);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 47, 0, -48);
        [button addTarget:self action:@selector(onClickMore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
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
    [self.shopName sizeToFit];
    if (self.shopName.frame.size.width > 160)
    {
        self.shopName.frame = CGRectMake(PAGE_MARGIN, 10, 160, 20);
    }
    else
    {
        CGRect frame = self.shopName.frame;
        frame.size.height = 20;
        self.shopName.frame = frame;
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
    
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    
    NSArray *dishes = data[@"menu_list"];
    if (dishes)
    {
        NSUInteger count = [dishes count];
        
        self.scrollView.contentSize = CGSizeMake(IMAGE_SIZE_MIDDLE*count+PAGE_MARGIN*2+count*10-10, IMAGE_SIZE_MIDDLE);
        
        int i = 0;
        for (i = 0; i < count && i < 10; i++)
        {
            DishesView *dishesView = self.dishesViews[i];
            dishesView.data = dishes[i];
            dishesView.hidden = NO;
        }
        
        for (i = count; i < 10; i++)
        {
            DishesView *dishesView = self.dishesViews[i];
            dishesView.hidden = YES;
        }
    }
    
    switch (type)
    {
        case 0:
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
            DishesView *view = (DishesView *)sender.view;
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
