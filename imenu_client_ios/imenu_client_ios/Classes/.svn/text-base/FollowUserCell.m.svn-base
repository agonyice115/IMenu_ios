//
//  FollowUserCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FollowUserCell.h"
#import "RoundHeadView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import <SDWebImage/SDWebImageManager.h>
#import "TFTools.h"
#import "UserData.h"
#import "Networking.h"

@interface FollowUserCell ()

@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIImageView *vipView;
@property (nonatomic, strong) UIButton *userFans;

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *followLabel;

@end

@implementation FollowUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 5, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.headView.roundSideWidth = 2.0f;
        self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
        [self addSubview:self.headView];
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+60, 10, 60, 20)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.text = @"用户昵称";
        self.userName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.userName];
        
        self.vipView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+115, 10, 20, 20)];
        [self addSubview:self.vipView];
        
        self.userFans = [UIButton buttonWithType:UIButtonTypeCustom];
        self.userFans.frame = CGRectMake(PAGE_MARGIN+60, 25, 60, 30);
        self.userFans.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.userFans setTitle:@"35" forState:UIControlStateNormal];
        [self.userFans setTitleColor:[UIColor colorWithHtmlColor:@"#787878"] forState:UIControlStateNormal];
        [self.userFans setImage:[UIImage imageNamed:@"fans_normal"] forState:UIControlStateNormal];
        self.userFans.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 2);
        self.userFans.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.userFans.userInteractionEnabled = NO;
        [self addSubview:self.userFans];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.followButton.frame = CGRectMake(self.frame.size.width-PAGE_MARGIN-40, 0, 43, 43);
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
                    NSString *successString = result[@"success"];
                    if (self.delegate)
                    {
                        [self.delegate showTips:successString];
                    }
                    
                    NSDictionary *resultData = result[@"data"];
                    NSMutableDictionary *data = [self.data mutableCopy];
                    data[@"follow_status"] = resultData[@"follow_status"];
                    _data = data;
                    
                    [self updateFollowStatus];
                }
                else
                {
                    if (self.delegate)
                    {
                        [self.delegate showTips:errorString];
                    }
                }
            }
            else
            {
                if (self.delegate)
                {
                    [self.delegate showTips:NSLocalizedString(@"networking_error", nil)];
                }
            }
        });
    });
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.userName.text = data[@"member_name"];
    [self.userName sizeToFit];
    
    CGPoint center = self.userName.center;
    center.x += self.userName.frame.size.width/2+12;
    self.vipView.center = center;
    
    [self.userFans setTitle:data[@"followed_count"] forState:UIControlStateNormal];
    [self.userFans setTitle:[TFTools getFansString:data[@"followed_count"]] forState:UIControlStateNormal];
    
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
        self.vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_vip_%@@2x.png", vipLevel]];
    }
    else
    {
        self.vipView.image = nil;
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
