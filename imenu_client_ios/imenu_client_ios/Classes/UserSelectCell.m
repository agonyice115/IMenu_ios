//
//  UserSelectCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "UserSelectCell.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"

@implementation UserSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 5, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
        self.headView.roundSideWidth = 1.0f;
        self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
        [self addSubview:self.headView];
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_TINY+10, 10, 200, 30)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.text = @"用户昵称";
        self.userName.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.userName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
