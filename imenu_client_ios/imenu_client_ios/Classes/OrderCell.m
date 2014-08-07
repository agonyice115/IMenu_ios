//
//  OrderCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "OrderCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OrderCell ()

@property (nonatomic, strong) UIImageView *menuImage;
@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UILabel *peopleCount;
@property (nonatomic, strong) UILabel *totalPrice;
@property (nonatomic, strong) UILabel *orderDate;

@end

@implementation OrderCell

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
        
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 300-IMAGE_SIZE_SMALL-30, 30)];
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
        
        x += 70+5;
        
        self.orderDate = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 110, 20)];
        self.orderDate.backgroundColor = [UIColor clearColor];
        self.orderDate.text = @"2013/04/04 22:22";
        self.orderDate.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.orderDate.textAlignment = NSTextAlignmentRight;
        self.orderDate.textColor = [UIColor colorWithHtmlColor:@"#888888"];
        [self addSubview:self.orderDate];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 25, 20, 20)];
        imageView.image = [UIImage imageNamed:@"right_more_normal"];
        [self addSubview:imageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [self addSubview:lineView];
    }
    return self;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.shopName.text = data[@"store_name"];
    self.peopleCount.text = [NSString stringWithFormat:@"%@人", data[@"people"]];
    
    NSString *price = data[@"total"];
    float fPrice = [price floatValue];
    self.totalPrice.text = [NSString stringWithFormat:@"￥%.2f", fPrice];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *targetFormatter = [[NSDateFormatter alloc] init];
    [targetFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString:data[@"order_date"]];
    self.orderDate.text = [targetFormatter stringFromDate:date];
    
    NSDictionary *menu = data[@"menu_info"];
    NSString *thumbUrl = [TFTools getThumbImageUrlOfLacation:menu[@"image_location"]
                                                     andName:menu[@"image_name"]];
    if (thumbUrl && [thumbUrl length] > 0)
    {
        [self.menuImage setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
    }
    else
    {
        self.menuImage.image = [UIImage imageNamed:@"default_small.png"];
    }
}

@end
