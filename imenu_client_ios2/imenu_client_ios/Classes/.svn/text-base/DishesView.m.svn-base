//
//  DishesView.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-19.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DishesView.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TFTools.h"

@implementation DishesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self addSubview:self.imageView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 30)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        [self addSubview:view];
        
        self.dishesName = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, frame.size.width-4, 15)];
        self.dishesName.backgroundColor = [UIColor clearColor];
        self.dishesName.text = @"特价爆米花";
        self.dishesName.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dishesName.textAlignment = NSTextAlignmentRight;
        self.dishesName.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
        [view addSubview:self.dishesName];
        
        self.dishesPrice = [[UILabel alloc] initWithFrame:CGRectMake(3, 16, frame.size.width-6, 14)];
        self.dishesPrice.backgroundColor = [UIColor clearColor];
        self.dishesPrice.text = @"￥23.00";
        self.dishesPrice.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dishesPrice.textAlignment = NSTextAlignmentRight;
        self.dishesPrice.textColor = [UIColor colorWithHtmlColor:@"#ff8000"];
        [view addSubview:self.dishesPrice];
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
