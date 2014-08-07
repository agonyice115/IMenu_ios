//
//  MessageCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-13.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "MessageCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+70, 10, 38, 20)];
        imageView.image = [UIImage imageNamed:@"new_icon.png"];
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 190, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"消息名称";
        [self addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 30, 270, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        label.text = @"一直喜欢的！一直喜欢的！一直喜欢的！一直喜欢的！";
        [self addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 65, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"2014/07/22";
        [self addSubview:label];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(185, 9, 23, 23)];
        imageView.image = [UIImage imageNamed:@"time_dark@2x.png"];
        [self addSubview:imageView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 24, 22, 22)];
        imageView.image = [UIImage imageNamed:@"right_more_normal"];
        [self addSubview:imageView];
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
