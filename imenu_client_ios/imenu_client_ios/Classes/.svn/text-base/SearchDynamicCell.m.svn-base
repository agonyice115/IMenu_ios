//
//  SearchDynamicCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SearchDynamicCell.h"
#import "RoundHeadView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/SDWebImageManager.h>

@interface SearchDynamicCell ()

@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *dynamicTitle;
@property (nonatomic, strong) UIButton *good;
@property (nonatomic, strong) UIButton *comment;

@end

@implementation SearchDynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.headView.roundSideWidth = 2.0f;
        self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
        [self addSubview:self.headView];
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 10, 200, 20)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.text = @"商户名称";
        self.userName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.userName];
        
        self.dynamicTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 30, 200, 15)];
        self.dynamicTitle.backgroundColor = [UIColor clearColor];
        self.dynamicTitle.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dynamicTitle.textAlignment = NSTextAlignmentLeft;
        self.dynamicTitle.textColor = [UIColor colorWithHtmlColor:@"#787878"];
        self.dynamicTitle.text = @"我家住在黄土高坡啊坡坡啊坡坡";
        [self addSubview:self.dynamicTitle];
        
        self.good = [UIButton buttonWithType:UIButtonTypeCustom];
        self.good.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 41, 60, 23);
        self.good.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.good setTitle:@"40" forState:UIControlStateNormal];
        [self.good setTitleColor:[UIColor colorWithHtmlColor:@"#787878"] forState:UIControlStateNormal];
        [self.good setImage:[UIImage imageNamed:@"good_gray"] forState:UIControlStateNormal];
        self.good.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.good.userInteractionEnabled = NO;
        [self addSubview:self.good];
        
        self.comment = [UIButton buttonWithType:UIButtonTypeCustom];
        self.comment.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+70, 41, 60, 23);
        self.comment.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.comment setTitle:@"50" forState:UIControlStateNormal];
        [self.comment setTitleColor:[UIColor colorWithHtmlColor:@"#787878"] forState:UIControlStateNormal];
        [self.comment setImage:[UIImage imageNamed:@"comment_gray"] forState:UIControlStateNormal];
        self.comment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.comment.userInteractionEnabled = NO;
        [self addSubview:self.comment];
        
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
    
    NSDictionary *user = data[@"member_info"];
    
    self.userName.text = user[@"member_name"];
    self.dynamicTitle.text = data[@"title"];
    [self.good setTitle:data[@"goods_count"] forState:UIControlStateNormal];
    [self.comment setTitle:data[@"comment_count"] forState:UIControlStateNormal];
    
    self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:user[@"icon_location"] andName:user[@"icon_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    NSString *vipLevel = user[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.headView.vipPic = [UIImage imageNamed:[NSString stringWithFormat:@"user_vip_%@@2x.png", vipLevel]];
    }
    else
    {
        self.headView.vipPic = nil;
    }
}

@end
