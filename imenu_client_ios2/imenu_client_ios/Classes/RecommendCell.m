//
//  RecommendCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-8.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "RecommendCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@interface RecommendCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *menuTitle;
@property (nonatomic, strong) UILabel *menuUnit;
@property (nonatomic, strong) UILabel *menuPrice;

@end

@implementation RecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.iconView.image = [UIImage imageNamed:@"default_small.png"];
        [self addSubview:self.iconView];
        
        self.menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 15)];
        self.menuTitle.backgroundColor = [UIColor clearColor];
        self.menuTitle.font = [UIFont boldSystemFontOfSize:THIRD_FONT_SIZE];
        self.menuTitle.textAlignment = NSTextAlignmentLeft;
        self.menuTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.menuTitle.text = @"麦趣鸡盒";
        [self addSubview:self.menuTitle];
        
        self.menuUnit = [[UILabel alloc] initWithFrame:CGRectMake(60, 28, 60, 15)];
        self.menuUnit.backgroundColor = [UIColor clearColor];
        self.menuUnit.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.menuUnit.textAlignment = NSTextAlignmentLeft;
        self.menuUnit.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.menuUnit.text = @"1/份";
        [self addSubview:self.menuUnit];
        
        self.menuPrice = [[UILabel alloc] initWithFrame:CGRectMake(60, 45, 60, 15)];
        self.menuPrice.backgroundColor = [UIColor clearColor];
        self.menuPrice.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.menuPrice.textAlignment = NSTextAlignmentLeft;
        self.menuPrice.textColor = [UIColor colorWithHtmlColor:@"#46acfe"];
        self.menuPrice.text = @"￥15.00";
        [self addSubview:self.menuPrice];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 240, 0.5f)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#888888"];
        [self addSubview:line];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
