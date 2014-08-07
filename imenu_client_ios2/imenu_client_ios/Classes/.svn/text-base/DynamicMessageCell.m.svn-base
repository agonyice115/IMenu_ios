//
//  DynamicMessageCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-8.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DynamicMessageCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@implementation DynamicMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        imageView.image = [UIImage imageNamed:@"man_header_small.png"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0f;
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 190, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5aaa"];
        label.text = @"Angell";
        [self addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 190, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"一直喜欢的！";
        [self addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 190, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
        label.text = @"1分钟前";
        [self addSubview:label];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 10, 50, 50)];
        imageView.image = [UIImage imageNamed:@"default_small.png"];
        [self addSubview:imageView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
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
