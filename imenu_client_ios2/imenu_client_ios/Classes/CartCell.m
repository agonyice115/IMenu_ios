//
//  CartCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "CartCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClientConfig.h"
#import "CartData.h"

@interface CartCell () <UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *menuTitle;
@property (nonatomic, strong) UILabel *menuPrice;
@property (nonatomic, strong) UILabel *oldPrice;
@property (nonatomic, strong) UIImageView *menuTaste;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation CartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        [self addSubview:self.iconView];
        
        self.menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 140, 15)];
        self.menuTitle.backgroundColor = [UIColor clearColor];
        self.menuTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.menuTitle.textAlignment = NSTextAlignmentLeft;
        self.menuTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.menuTitle];
        
        self.menuPrice = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 60, 15)];
        self.menuPrice.backgroundColor = [UIColor clearColor];
        self.menuPrice.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.menuPrice.textAlignment = NSTextAlignmentLeft;
        self.menuPrice.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        [self addSubview:self.menuPrice];
        
        self.oldPrice = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 40, 10)];
        self.oldPrice.backgroundColor = [UIColor clearColor];
        self.oldPrice.font = [UIFont systemFontOfSize:8.0];
        self.oldPrice.textAlignment = NSTextAlignmentLeft;
        self.oldPrice.textColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
        self.oldPrice.clipsToBounds = YES;
        [self addSubview:self.oldPrice];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 50, 1)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
        [self.oldPrice addSubview:line];
        
        self.menuTaste = [[UIImageView alloc] initWithFrame:CGRectMake(80, 40, 20, 20)];
        [self addSubview:self.menuTaste];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN+190, 9, 43, 43);
        [button setImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"minus_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickMinus) forControlEvents:UIControlEventTouchUpInside];
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320-PAGE_MARGIN-33, 9, 43, 43);
        [button setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"plus_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickPlus) forControlEvents:UIControlEventTouchUpInside];
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+25+200, 19, 40, 23)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = @"0";
        [self addSubview:label];
        self.countLabel = label;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onClickPlus
{
    int count = self.countLabel.text.intValue;
    if (count == 99)
    {
        return;
    }
    count += 1;
    self.countLabel.text = [NSString stringWithFormat:@"%d", count];
    
    [[CartData sharedCartData] addMenuCount:self.data[@"menu_id"]];
}

- (void)onClickMinus
{
    int count = self.countLabel.text.intValue;
    if (count == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"要删除这道菜吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"不删除"
                                                  otherButtonTitles:@"删除", nil];
        [alertView show];
        return;
    }
    if (count == 0)
    {
        return;
    }
    count -= 1;
    self.countLabel.text = [NSString stringWithFormat:@"%d", count];
    
    [[CartData sharedCartData] redMenuCount:self.data[@"menu_id"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[CartData sharedCartData] removeMenu:self.data];
    }
}

- (void)setData:(NSMutableDictionary *)data
{
    _data = data;
    
    self.menuTitle.text = data[@"menu_name"];
    self.countLabel.text = data[@"menu_count"];
    
    NSString *price = data[@"menu_price"];
    
    NSString *couponPrice = data[@"menu_coupon_price"];
    if (couponPrice && couponPrice.length > 0)
    {
        float fPrice = [couponPrice floatValue];
        self.menuPrice.text = [NSString stringWithFormat:@"￥%.2f", fPrice];
        
        self.oldPrice.hidden = NO;
        fPrice = [price floatValue];
        self.oldPrice.frame = CGRectMake(120, 30, 40, 10);
        self.oldPrice.text = [NSString stringWithFormat:@"￥%.2f", fPrice];
        [self.oldPrice sizeToFit];
    }
    else
    {
        self.oldPrice.hidden = YES;
        
        float fPrice = [price floatValue];
        self.menuPrice.text = [NSString stringWithFormat:@"￥%.2f", fPrice];
    }
    
    NSString *url = [TFTools getThumbImageUrlOfLacation:data[@"menu_image_location"] andName:data[@"menu_image_name"]];
    [self.iconView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
    
    url = [[ClientConfig sharedConfig] getMenuTasteUrlById:data[@"menu_taste_id"]];
    [self.menuTaste setImageWithURL:[NSURL URLWithString:url]];
}

@end
