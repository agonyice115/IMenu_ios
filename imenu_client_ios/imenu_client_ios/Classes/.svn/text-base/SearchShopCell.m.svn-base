//
//  SearchShopCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SearchShopCell.h"
#import "RoundHeadView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/SDWebImageManager.h>

@interface SearchShopCell ()

@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UILabel *shopAddress;
@property (nonatomic, strong) UIButton *shopDistance;

@end

@implementation SearchShopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.headView.roundSideWidth = 2.0f;
        self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
        [self addSubview:self.headView];
        
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 10, 200, 20)];
        self.shopName.backgroundColor = [UIColor clearColor];
        self.shopName.text = @"商户名称";
        self.shopName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.shopName.textAlignment = NSTextAlignmentLeft;
        self.shopName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.shopName];
        
        self.shopAddress = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 30, 200, 15)];
        self.shopAddress.backgroundColor = [UIColor clearColor];
        self.shopAddress.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.shopAddress.textAlignment = NSTextAlignmentLeft;
        self.shopAddress.textColor = [UIColor colorWithHtmlColor:@"#787878"];
        self.shopAddress.text = @"我家住在黄土高坡啊坡坡啊坡坡";
        [self addSubview:self.shopAddress];
        
        self.shopDistance = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shopDistance.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 45, 150, 15);
        self.shopDistance.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.shopDistance setTitle:@"距离:小于50米" forState:UIControlStateNormal];
        [self.shopDistance setTitleColor:[UIColor colorWithHtmlColor:@"#787878"] forState:UIControlStateNormal];
        [self.shopDistance setImage:[UIImage imageNamed:@"map_normal"] forState:UIControlStateNormal];
        self.shopDistance.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
        self.shopDistance.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.shopDistance.userInteractionEnabled = NO;
        [self addSubview:self.shopDistance];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(300-PAGE_MARGIN, 25, 20, 20)];
        imageView.image = [UIImage imageNamed:@"right_more_normal"];
        [self addSubview:imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.shopName.text = data[@"store_name"];
    self.shopAddress.text = data[@"address"];
    [self.shopDistance setTitle:[NSString stringWithFormat:@"距离:%@", [TFTools getDistaceString:data[@"distance"]]]
                       forState:UIControlStateNormal];
    
    self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
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
}

@end
