//
//  CommentCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "CommentCell.h"
#import "RoundHeadView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/SDWebImageManager.h>

@interface CommentCell ()

@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *dynamicTime;
@property (nonatomic, strong) UITextView *dynamicTitle;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(10, 10, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
        self.headView.roundSideWidth = 1.0f;
        self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
        self.headView.vipPic = [UIImage imageNamed:@"user_vip_1"];
        [self addSubview:self.headView];
        
        CGFloat height = 8.0f;
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(20+IMAGE_SIZE_TINY, height, 100, 16)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.text = @"用户昵称";
        self.userName.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.userName];
        
        self.dynamicTime = [[UILabel alloc] initWithFrame:CGRectMake(220-PAGE_MARGIN, height, 100, 16)];
        self.dynamicTime.backgroundColor = [UIColor clearColor];
        self.dynamicTime.text = @"03/01 20:50";
        self.dynamicTime.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dynamicTime.textAlignment = NSTextAlignmentRight;
        self.dynamicTime.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.dynamicTime];
        
        height += 16;
        
        self.dynamicTitle = [[UITextView alloc] initWithFrame:CGRectMake(16+IMAGE_SIZE_TINY, height, 260, 16)];
        self.dynamicTitle.userInteractionEnabled = NO;
        self.dynamicTitle.backgroundColor = [UIColor clearColor];
        self.dynamicTitle.text = @"感情全是爆米花？？";
        self.dynamicTitle.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dynamicTitle.textAlignment = NSTextAlignmentLeft;
        self.dynamicTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.dynamicTitle];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, 320, 1)];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [self addSubview:lineView];
        self.lineView = lineView;
        
        UIView *tap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE_TINY+10, self.frame.size.height)];
        tap.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [tap addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHead)]];
        [self addSubview:tap];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowLight:(BOOL)showLight
{
    _showLight = showLight;
    
    if (showLight)
    {
        self.userName.textColor = [UIColor colorWithHtmlColor:@"#dddddd"];
        self.dynamicTime.textColor = [UIColor colorWithHtmlColor:@"#dddddd"];
        self.dynamicTitle.textColor = [UIColor colorWithHtmlColor:@"#dddddd"];
        self.lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#444444"];
    }
}

- (void)clickUserHead
{
    if (self.delegate)
    {
        [self.delegate onClickUser:self.data];
    }
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    NSDictionary *rInfo = data[@"r_member_info"];
    
    self.userName.text = data[@"member_name"];
    
    if ([rInfo isKindOfClass:[NSDictionary class]])
    {
        NSString *rMemberName = rInfo[@"r_member_name"];
        self.dynamicTitle.text = [NSString stringWithFormat:@"回复%@:%@", rMemberName, data[@"comment_content"]];
    }
    else
    {
        self.dynamicTitle.text = data[@"comment_content"];
    }
    
    CGRect frame = self.dynamicTitle.frame;
    NSNumber *height = data[@"cell_height"];
    if (height)
    {
        frame.size.height = height.floatValue-34;
    }
    else
    {
        frame.size.height = 16;
    }
    self.dynamicTitle.frame = frame;
    
    self.dynamicTime.text = data[@"comment_date"];
    
    self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:data[@"iconLocation"] andName:data[@"iconName"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    NSString *vipLevel = data[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.headView.vipPic = [UIImage imageNamed:[NSString stringWithFormat:@"user_vip_%@@2x.png", vipLevel]];
    }
    else
    {
        self.headView.vipPic = nil;
    }
}

@end
