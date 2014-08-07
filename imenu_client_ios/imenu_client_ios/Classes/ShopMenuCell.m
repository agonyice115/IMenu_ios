//
//  ShopMenuCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-27.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopMenuCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClientConfig.h"
#import "CartData.h"
#import "UserData.h"

@interface ShopMenuCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *menuTitle;
@property (nonatomic, strong) UILabel *menuPrice;
@property (nonatomic, strong) UIImageView *menuTaste;

@property (nonatomic, strong) UIButton *menuOrder;
@property (nonatomic, strong) UILabel *menuState;

@end


@implementation ShopMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CartDataChanged:) name:CART_DATA_CHANGED object:nil];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        [self addSubview:self.iconView];
        
        self.menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 15)];
        self.menuTitle.backgroundColor = [UIColor clearColor];
        self.menuTitle.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.menuTitle.textAlignment = NSTextAlignmentLeft;
        self.menuTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.menuTitle];
        
        self.menuPrice = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 100, 15)];
        self.menuPrice.backgroundColor = [UIColor clearColor];
        self.menuPrice.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.menuPrice.textAlignment = NSTextAlignmentLeft;
        self.menuPrice.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        [self addSubview:self.menuPrice];
        
        self.menuTaste = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 20, 20)];
        [self addSubview:self.menuTaste];
        
        self.menuOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuOrder.frame = CGRectMake(self.frame.size.width-PAGE_MARGIN-33, 13, 43, 43);
        [self.menuOrder setImage:[UIImage imageNamed:@"plus_normal@2x.png"] forState:UIControlStateNormal];
        [self.menuOrder setImage:[UIImage imageNamed:@"plus_highlight@2x.png"] forState:UIControlStateHighlighted];
        [self.menuOrder addTarget:self action:@selector(onClickOrder) forControlEvents:UIControlEventTouchUpInside];
        self.menuOrder.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.menuOrder.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.menuOrder];
        
        self.menuState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
        self.menuState.center = CGPointMake(self.menuOrder.center.x, self.menuOrder.center.y+20);
        self.menuState.backgroundColor = [UIColor clearColor];
        self.menuState.text = @"选菜";
        self.menuState.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.menuState.textAlignment = NSTextAlignmentCenter;
        self.menuState.textColor = [UIColor colorWithHtmlColor:@"#787878"];
        self.menuState.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.menuState];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)CartDataChanged:(NSNotification *)notification
{
    [self refreshCartState];
}

- (void)refreshCartState
{
    NSString *menuId = self.data[@"menu_id"];
    if ([[CartData sharedCartData].storeId isEqualToString:self.storeData[@"store_id"]] && [[CartData sharedCartData] isOrder:menuId])
    {
        self.menuState.text = @"已选";
        self.menuState.textColor = [UIColor colorWithHtmlColor:@"#0088ff"];
        [self.menuOrder setImage:[UIImage imageNamed:@"right_highlight@2x.png"] forState:UIControlStateNormal];
        [self.menuOrder setImage:[UIImage imageNamed:@"right_normal@2x.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.menuState.text = @"选菜";
        self.menuState.textColor = [UIColor colorWithHtmlColor:@"#787878"];
        [self.menuOrder setImage:[UIImage imageNamed:@"plus_normal@2x.png"] forState:UIControlStateNormal];
        [self.menuOrder setImage:[UIImage imageNamed:@"plus_highlight@2x.png"] forState:UIControlStateHighlighted];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onClickOrder
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    
    [CartData sharedCartData].storeData = self.storeData;
    
    NSString *menuId = self.data[@"menu_id"];
    if ([[CartData sharedCartData] isOrder:menuId])
    {
        [[CartData sharedCartData] removeMenu:self.data];
    }
    else
    {
        [[CartData sharedCartData] addMenu:self.data];
    }
}

- (void)setData:(NSDictionary *)data showImage:(BOOL)isShow
{
    _data  = data;
    
    self.menuTitle.text = data[@"menu_name"];
    
    NSString *price = data[@"menu_price"];
    float fPrice = [price floatValue];
    self.menuPrice.text = [NSString stringWithFormat:@"￥%.2f", fPrice];
    
    if (isShow)
    {
        self.iconView.hidden = NO;
        self.menuTitle.frame = CGRectMake(60, 10, 100, 15);
        self.menuPrice.frame = CGRectMake(60, 25, 100, 15);
        self.menuTaste.frame = CGRectMake(60, 40, 20, 20);
        NSString *url = [TFTools getThumbImageUrlOfLacation:data[@"menu_image_location"] andName:data[@"menu_image_name"]];
        [self.iconView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
    }
    else
    {
        self.iconView.hidden = YES;
        self.menuTitle.frame = CGRectMake(5, 10, 150, 15);
        self.menuPrice.frame = CGRectMake(5, 25, 100, 15);
        self.menuTaste.frame = CGRectMake(5, 40, 20, 20);
    }
    
    NSString *url = [[ClientConfig sharedConfig] getMenuTasteUrlById:data[@"menu_taste_id"]];
    [self.menuTaste setImageWithURL:[NSURL URLWithString:url]];
    
    [self refreshCartState];
}

@end
