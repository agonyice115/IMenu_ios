//
//  NewDishesView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-7.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "NewDishesView.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TFTools.h"

@implementation NewDishesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self addSubview:self.imageView];
        
        self.dishesName = [[UILabel alloc] initWithFrame:CGRectMake(2, frame.size.width+1, frame.size.width-4, 15)];
        self.dishesName.backgroundColor = [UIColor clearColor];
        self.dishesName.text = @"特价爆米花";
        self.dishesName.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dishesName.textAlignment = NSTextAlignmentLeft;
        self.dishesName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.dishesName];
        
        self.dishesPrice = [[UILabel alloc] initWithFrame:CGRectMake(3, frame.size.width+16, frame.size.width-6, 15)];
        self.dishesPrice.backgroundColor = [UIColor clearColor];
        self.dishesPrice.text = @"￥23.00";
        self.dishesPrice.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dishesPrice.textAlignment = NSTextAlignmentLeft;
        self.dishesPrice.textColor = [UIColor colorWithHtmlColor:@"#ff8000"];
        [self addSubview:self.dishesPrice];
    }
    return self;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    NSString *price = data[@"menu_price"];
    float fPrice = [price floatValue];
    
    self.dishesName.text = data[@"menu_name"];
    self.dishesPrice.text = [NSString stringWithFormat:@"￥%.2f", fPrice];
    NSString *thumbUrl = [TFTools getThumbImageUrlOfLacation:data[@"menu_image_location"]
                                                     andName:data[@"menu_image_name"] ];
    if (thumbUrl)
    {
        [self.imageView setImageWithURL:[NSURL URLWithString:thumbUrl]
                       placeholderImage:[UIImage imageNamed:@"default_small.png"]];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"default_small.png"];
    }
}

@end
