//
//  SearchMenuCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SearchMenuCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserData.h"

@interface SearchMenuCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *menuTitle;
@property (nonatomic, strong) UILabel *menuPrice;
@property (nonatomic, strong) UIButton *menuOrder;

@end

@implementation SearchMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.iconView.image = [UIImage imageNamed:@"default_small.png"];
        [self addSubview:self.iconView];
        
        self.menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 10, 200, 20)];
        self.menuTitle.backgroundColor = [UIColor clearColor];
        self.menuTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.menuTitle.textAlignment = NSTextAlignmentLeft;
        self.menuTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.menuTitle.text = @"鱼香肉丝";
        [self addSubview:self.menuTitle];
        
        self.menuPrice = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 30, 100, 15)];
        self.menuPrice.backgroundColor = [UIColor clearColor];
        self.menuPrice.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.menuPrice.textAlignment = NSTextAlignmentLeft;
        self.menuPrice.textColor = [UIColor colorWithHtmlColor:@"#008fff"];
        self.menuPrice.text = @"￥18.00";
        [self addSubview:self.menuPrice];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 45, 190, 15);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:@"35次/本月" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#787878"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"shop_order_normal"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        button.enabled = NO;
        [self addSubview:button];
        self.menuOrder = button;
        
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
    
    NSString *price = data[@"menu_price"];
    float fPrice = [price floatValue];
    
    self.menuTitle.text = data[@"menu_name"];
    self.menuPrice.text = [NSString stringWithFormat:@"￥%.2f", fPrice];
    
    [self.menuOrder setTitle:[self getMenuCountString:data[@"menu_count"] type:data[@"menu_count_type"]] forState:UIControlStateDisabled];
    
    NSString *url = [TFTools getThumbImageUrlOfLacation:data[@"menu_image_location"] andName:data[@"menu_image_name"]];
    [self.iconView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
}

- (NSString *)getMenuCountString:(NSString *)count type:(NSString *)type
{
    if ([type isEqualToString:@"1"])
    {
        return [NSString stringWithFormat:@"%@次/本日", count];
    }
    else if ([type isEqualToString:@"2"])
    {
        return [NSString stringWithFormat:@"%@次/本周", count];
    }
    else if ([type isEqualToString:@"3"])
    {
        return [NSString stringWithFormat:@"%@次/本月", count];
    }
    else if ([type isEqualToString:@"4"])
    {
        return [NSString stringWithFormat:@"%@次/本季度", count];
    }
    else if ([type isEqualToString:@"5"])
    {
        return [NSString stringWithFormat:@"%@次/本年", count];
    }
    else
    {
        return [NSString stringWithFormat:@"%@次/全部", count];
    }
}

@end
