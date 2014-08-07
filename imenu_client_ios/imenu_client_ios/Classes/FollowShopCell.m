//
//  FollowShopCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FollowShopCell.h"
#import "RoundHeadView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import <SDWebImage/SDWebImageManager.h>
#import "TFTools.h"
#import "UserData.h"
#import "Networking.h"
#import "IMConfig.h"

@interface FollowShopCell () <UIActionSheetDelegate>

@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UIButton *shopAddress;

@property (nonatomic, strong) UIButton *unfoldButton;

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *followLabel;

@property (nonatomic, strong) UIView *foldView;

@end

@implementation FollowShopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 5, IMAGE_SIZE_SMALL, IMAGE_SIZE_SMALL)];
        self.headView.roundSideWidth = 2.0f;
        self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
        [self addSubview:self.headView];
        
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+60, 10, self.frame.size.width-PAGE_MARGIN*2-100, 20)];
        self.shopName.backgroundColor = [UIColor clearColor];
        self.shopName.text = @"商户名称";
        self.shopName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.shopName.textAlignment = NSTextAlignmentLeft;
        self.shopName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.shopName];
        
        self.shopAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shopAddress.frame = CGRectMake(PAGE_MARGIN+60, 30, self.frame.size.width-PAGE_MARGIN*2-100, 20);
        self.shopAddress.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.shopAddress setTitle:@"我家住在黄土高坡啊坡坡啊坡坡" forState:UIControlStateNormal];
        [self.shopAddress setTitleColor:[UIColor colorWithHtmlColor:@"#787878"] forState:UIControlStateNormal];
        [self.shopAddress setImage:[UIImage imageNamed:@"map_normal"] forState:UIControlStateNormal];
        self.shopAddress.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
        self.shopAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.shopAddress.userInteractionEnabled = NO;
        [self addSubview:self.shopAddress];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.frame.size.width-PAGE_MARGIN-33, 0, 43, 43);
        [button setImage:[UIImage imageNamed:@"menu_dark@2x.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickUnfold) forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button addSubview:[self getLabel:@"展开" withColor:@"#787878"]];
        [self addSubview:button];
        
        self.foldView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width,
                                                                 0,
                                                                 self.frame.size.width-PAGE_MARGIN-60,
                                                                 self.frame.size.height)];
        self.foldView.backgroundColor = [IMConfig sharedConfig].bgColor;
        [self addSubview:self.foldView];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.foldView.frame.size.width-PAGE_MARGIN-33, 0, 43, 43);
        [button setImage:[UIImage imageNamed:@"minus_white@2x.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"minus_highlight@2x.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickFold) forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button addSubview:[self getLabel:@"收起" withColor:@"#ffffff"]];
        [self.foldView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN-10, 0, 43, 43);
        [button setImage:[UIImage imageNamed:@"tel_normal@2x.png"] forState:UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:@"minus_highlight@2x.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickTel) forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [button addSubview:[self getLabel:@"电话" withColor:@"#ffffff"]];
        [self.foldView addSubview:button];
        
        float space = (self.foldView.frame.size.width-PAGE_MARGIN*2-43*4+20)/3;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN+43+space-10, 0, 43, 43);
        [button setImage:[UIImage imageNamed:@"address_normal@2x.png"] forState:UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:@"minus_highlight@2x.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickMap) forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [button addSubview:[self getLabel:@"地址" withColor:@"#ffffff"]];
        [self.foldView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN+(43+space)*2-10, 0, 43, 43);
        [button setImage:[UIImage imageNamed:@"close_normal@2x.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"close_highlight@2x.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickFollow) forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.followLabel = [self getLabel:@"已关注" withColor:@"#ffffff"];
        [button addSubview:self.followLabel];
        [self.foldView addSubview:button];
        self.followButton = button;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)getLabel:(NSString *)title withColor:(NSString *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    label.center = CGPointMake(22, 43);
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHtmlColor:color];
    return label;
}

- (void)clickUnfold
{
    [UIView animateWithDuration:0.2f animations:^{
        self.foldView.frame = CGRectMake(PAGE_MARGIN+60,
                                         0,
                                         self.frame.size.width-PAGE_MARGIN-60,
                                         self.frame.size.height);
    }];
}

- (void)clickFold
{
    [UIView animateWithDuration:0.2f animations:^{
        self.foldView.frame = CGRectMake(self.frame.size.width,
                                         0,
                                         self.frame.size.width-PAGE_MARGIN-60,
                                         self.frame.size.height);
    }];
}

- (void)clickTel
{
    if ([self.data[@"tel_2"] length] > 0)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                             destructiveButtonTitle:self.data[@"tel_1"]
                                                  otherButtonTitles:self.data[@"tel_2"], nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                             destructiveButtonTitle:self.data[@"tel_1"]
                                                  otherButtonTitles:nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)clickMap
{
    
}

- (void)onClickFollow
{
    NSString *followStatus = self.data[@"follow_status"];
    NSString *status = followStatus.intValue > 0 ? @"0" : @"1";
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"following_member_id":@"",
                          @"following_store_id":self.data[@"store_id"],
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
    
    [UIView animateWithDuration:0.0f animations:^{
        self.foldView.frame = CGRectMake(self.frame.size.width,
                                         0,
                                         self.frame.size.width-PAGE_MARGIN-60,
                                         self.frame.size.height);
    }];
    
    self.shopName.text = data[@"store_name"];
    
    [self.shopAddress setTitle:data[@"address"] forState:UIControlStateNormal];
    
    self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:data[@"store_logo_location"] andName:data[@"store_logo_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
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
            [self.followButton setImage:[UIImage imageNamed:@"plus_white@2x.png"] forState:UIControlStateNormal];
            [self.followButton setImage:[UIImage imageNamed:@"plus_highlight@2x.png"] forState:UIControlStateHighlighted];
            self.followLabel.text = @"未关注";
        }
        else if (followStatus.intValue == 1)
        {
            [self.followButton setImage:[UIImage imageNamed:@"close_normal@2x.png"] forState:UIControlStateNormal];
            [self.followButton setImage:[UIImage imageNamed:@"close_highlight@2x.png"] forState:UIControlStateHighlighted];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        return;
    }
    
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.data[@"tel_1"]]]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.data[@"tel_2"]]]];
    }
}

@end
