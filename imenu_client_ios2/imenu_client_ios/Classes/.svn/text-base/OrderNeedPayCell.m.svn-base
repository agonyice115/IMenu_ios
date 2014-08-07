//
//  OrderNeedPayCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-30.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "OrderNeedPayCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OrderNeedPayCell ()

@property (nonatomic, strong) UIImageView *menuImage;
@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UILabel *peopleCount;
@property (nonatomic, strong) UILabel *totalPrice;

@end


@implementation OrderNeedPayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        CGFloat x = 10;
        CGFloat y = 10;
        
        self.menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.menuImage.image = [UIImage imageNamed:@"default_small.png"];
        [self addSubview:self.menuImage];
        
        x += IMAGE_SIZE_SMALL+5;
        
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 300-IMAGE_SIZE_SMALL-60, 30)];
        self.shopName.backgroundColor = [UIColor clearColor];
        self.shopName.text = @"商户名称商户名称商户名称商户名称商户名称商户名称";
        self.shopName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.shopName.textAlignment = NSTextAlignmentLeft;
        self.shopName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.shopName];
        
        y += 30;
        
        self.peopleCount = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 30, 20)];
        self.peopleCount.backgroundColor = [UIColor clearColor];
        self.peopleCount.text = @"14人";
        self.peopleCount.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.peopleCount.textAlignment = NSTextAlignmentLeft;
        self.peopleCount.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        [self addSubview:self.peopleCount];
        
        x += 30+5;
        
        self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 70, 20)];
        self.totalPrice.backgroundColor = [UIColor clearColor];
        self.totalPrice.text = @"￥1234.12";
        self.totalPrice.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.totalPrice.textAlignment = NSTextAlignmentLeft;
        self.totalPrice.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        [self addSubview:self.totalPrice];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 60, 30);
        button.center = CGPointMake(280, 35);
        button.backgroundColor = [UIColor colorWithHtmlColor:@"#008fff"];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#cccccc"] forState:UIControlStateHighlighted];
        [button setTitle:@"付款" forState:UIControlStateNormal];
        [self addSubview:button];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [self addSubview:lineView];
    }
    return self;
}

@end
