//
//  ShopServiceCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-9.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopServiceCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HtmlColor.h"
#import "Common.h"

@interface ServiceView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *serviceTitle;

@end

@implementation ServiceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 64, 64)];
        [self addSubview:self.imageView];
        
        self.serviceTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 64, 20)];
        self.serviceTitle.backgroundColor = [UIColor clearColor];
        self.serviceTitle.text = @"24小时";
        self.serviceTitle.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.serviceTitle.textAlignment = NSTextAlignmentCenter;
        self.serviceTitle.textColor = [UIColor colorWithHtmlColor:@"#5e5e5e"];
        [self addSubview:self.serviceTitle];
    }
    
    return self;
}

@end

@interface ShopServiceCell ()

@property (nonatomic, strong) NSMutableArray *subServiceViews;

@end

@implementation ShopServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        self.subServiceViews = [NSMutableArray array];
        
        for (int i = 0; i < 4; i++)
        {
            ServiceView *view = [[ServiceView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+i*75, 0, 64, 100)];
            [self addSubview:view];
            view.hidden = YES;
            [self.subServiceViews addObject:view];
        }
    }
    return self;
}

- (void)setServiceData:(NSArray *)data
{
    for (ServiceView *view in self.subServiceViews)
    {
        view.hidden = YES;
    }
    
    int count = [data count];
    if (data == nil || count == 0)
    {
        return;
    }
    
    for (int i = 0; i < count; i++)
    {
        NSDictionary *dic = data[i];
        if (i < [self.subServiceViews count])
        {
            ServiceView *view = self.subServiceViews[i];
            view.hidden = NO;
            [view.imageView setImageWithURL:[NSURL URLWithString:dic[@"service_image"]]];
            view.serviceTitle.text = dic[@"service_name"];
        }
        else
        {
            int col = i / 4;
            int row = i % 4;
            ServiceView *view = [[ServiceView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+row*75, col*100, 64, 100)];
            [view.imageView setImageWithURL:[NSURL URLWithString:dic[@"service_image"]]];
            view.serviceTitle.text = dic[@"service_name"];
            [self addSubview:view];
            [self.subServiceViews addObject:view];
        }
    }
}

- (void)setEnvironmentData:(NSArray *)data
{
    for (ServiceView *view in self.subServiceViews)
    {
        view.hidden = YES;
    }
    
    int count = [data count];
    if (data == nil || count == 0)
    {
        return;
    }
    
    for (int i = 0; i < count; i++)
    {
        NSDictionary *dic = data[i];
        if (i < [self.subServiceViews count])
        {
            ServiceView *view = self.subServiceViews[i];
            view.hidden = NO;
            [view.imageView setImageWithURL:[NSURL URLWithString:dic[@"environment_image"]]];
            view.serviceTitle.text = dic[@"environment_name"];
        }
        else
        {
            int col = i / 4;
            int row = i % 4;
            ServiceView *view = [[ServiceView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+row*75, col*100, 64, 100)];
            [view.imageView setImageWithURL:[NSURL URLWithString:dic[@"environment_image"]]];
            view.serviceTitle.text = dic[@"environment_name"];
            [self addSubview:view];
            [self.subServiceViews addObject:view];
        }
    }
}

@end
