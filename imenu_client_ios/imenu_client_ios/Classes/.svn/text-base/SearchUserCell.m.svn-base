//
//  SearchUserCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SearchUserCell.h"
#import "RoundHeadView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import <SDWebImage/SDWebImageManager.h>
#import "TFTools.h"
#import "UserData.h"
#import "Networking.h"

@interface SearchUserCell ()

@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userMark;
@property (nonatomic, strong) UIButton *userFans;

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *followLabel;

@end


@implementation SearchUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.headView.roundSideWidth = 2.0f;
        self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
        [self addSubview:self.headView];
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 10, 160, 20)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.text = @"用户昵称";
        self.userName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.userName];
        
        self.userMark = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 30, 200, 15)];
        self.userMark.backgroundColor = [UIColor clearColor];
        self.userMark.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.userMark.textAlignment = NSTextAlignmentLeft;
        self.userMark.textColor = [UIColor colorWithHtmlColor:@"#787878"];
        self.userMark.text = @"我家住在黄土高坡啊坡坡啊坡坡";
        [self addSubview:self.userMark];
        
        self.userFans = [UIButton buttonWithType:UIButtonTypeCustom];
        self.userFans.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_SMALL+10, 45, 60, 23);
        self.userFans.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.userFans setTitle:@"35" forState:UIControlStateNormal];
        [self.userFans setTitleColor:[UIColor colorWithHtmlColor:@"#787878"] forState:UIControlStateNormal];
        [self.userFans setImage:[UIImage imageNamed:@"fans_normal"] forState:UIControlStateNormal];
        self.userFans.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 2);
        self.userFans.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.userFans.userInteractionEnabled = NO;
        [self addSubview:self.userFans];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.followButton.frame = CGRectMake(self.frame.size.width-PAGE_MARGIN-33, 5, 43, 43);
        [self.followButton setImage:[UIImage imageNamed:@"close_highlight@2x.png"] forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"close_normal@2x.png"] forState:UIControlStateHighlighted];
        [self.followButton addTarget:self action:@selector(onClickFollow) forControlEvents:UIControlEventTouchUpInside];
        self.followButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.followButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.followButton];
        
        self.followLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        self.followLabel.center = CGPointMake(self.followButton.center.x, self.followButton.center.y+20);
        self.followLabel.backgroundColor = [UIColor clearColor];
        self.followLabel.text = @"已关注";
        self.followLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.followLabel.textAlignment = NSTextAlignmentCenter;
        self.followLabel.textColor = [UIColor colorWithHtmlColor:@"#787878"];
        self.followLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.followLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onClickFollow
{
    NSString *followStatus = self.data[@"follow_status"];
    NSString *status = followStatus.intValue > 0 ? @"0" : @"1";
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"following_member_id":self.data[@"member_id"],
                          @"following_store_id":@"",
                          @"following_status":status};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"member/member/editFollowingStatus"
                                          withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    NSMutableDictionary *data = [self.data mutableCopy];
                    data[@"follow_status"] = resultData[@"follow_status"];
                    _data = data;
                    
                    [self updateFollowStatus];
                }
            }
        });
    });
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.userName.text = data[@"member_name"];
    self.userMark.text = data[@"signature"];
    [self.userFans setTitle:data[@"followed_count"] forState:UIControlStateNormal];
    
    self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:data[@"icon_location"] andName:data[@"icon_name"]];
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
    
    [self updateFollowStatus];
}

- (void)updateFollowStatus
{
    NSString *followStatus = self.data[@"follow_status"];
    if (followStatus && [followStatus length] > 0)
    {
        self.followButton.hidden = NO;
        self.followLabel.hidden = NO;
        if (followStatus.intValue == 0)
        {
            [self.followButton setImage:[UIImage imageNamed:@"plus_normal@2x.png"] forState:UIControlStateNormal];
            [self.followButton setImage:[UIImage imageNamed:@"plus_highlight@2x.png"] forState:UIControlStateHighlighted];
            self.followLabel.text = @"未关注";
        }
        else if (followStatus.intValue == 1)
        {
            [self.followButton setImage:[UIImage imageNamed:@"close_highlight@2x.png"] forState:UIControlStateNormal];
            [self.followButton setImage:[UIImage imageNamed:@"close_normal@2x.png"] forState:UIControlStateHighlighted];
            self.followLabel.text = @"已关注";
        }
        else if (followStatus.intValue == 2)
        {
            [self.followButton setImage:[UIImage imageNamed:@"follow_each_normal@2x.png"] forState:UIControlStateNormal];
            [self.followButton setImage:[UIImage imageNamed:@"follow_each_highlight@2x.png"] forState:UIControlStateHighlighted];
            self.followLabel.text = @"相互关注";
        }
        else
        {
            // 是自己
            self.followButton.hidden = YES;
            self.followLabel.hidden = YES;
        }
    }
    else
    {
        self.followButton.hidden = YES;
        self.followLabel.hidden = YES;
    }
}

@end
