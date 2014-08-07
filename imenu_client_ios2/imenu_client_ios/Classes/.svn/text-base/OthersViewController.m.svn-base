//
//  OthersViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-25.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "OthersViewController.h"
#import "UIColor+HtmlColor.h"
#import "RoundHeadView.h"
#import "LongBarButton.h"
#import "FollowViewController.h"
#import "FansViewController.h"
#import "Networking.h"
#import "UserData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DynamicViewController.h"
#import "TFTools.h"
#import <ShareSDK/ShareSDK.h>
#import "ClientConfig.h"
#import "IMRefreshView.h"

#define TOP_HEADER_VIEW_HEIGHT 130.0f


@interface OthersViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) RoundHeadView *headPicView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userMark;
@property (nonatomic, strong) UIButton *userScore;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) LongBarButton *userFans;
@property (nonatomic, strong) LongBarButton *userFollow;

@property (nonatomic, strong) LongBarButton *userDynamic;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) IMRefreshView *refreshView;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation OthersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"main_title1", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-160,
                                                                       IMAGE_SIZE_BIG,
                                                                       IMAGE_SIZE_BIG)];
        self.photoView.image = [UIImage imageNamed:@"default_user.png"];
        self.photoView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.photoView];
        
        [self createHeadView];
        
        [self createScrollView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createHeadView
{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-160, 320, 320)];
    self.headView.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.0f alpha:0.6f];
    [self.view addSubview:self.headView];
    
    float height = 60.0f;
    
    self.refreshView = [IMRefreshView createRefreshView];
    self.refreshView.frame = CGRectMake(0, height, 320, 50);
    self.refreshView.hidden = YES;
    [self.headView addSubview:self.refreshView];
    
    height += 50.0f;
    self.headPicView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE)];
    self.headPicView.headPic = [UIImage imageNamed:@"man_header_big.png"];
    [self.headView addSubview:self.headPicView];
    
    height -= 10.0f;
    float x = PAGE_MARGIN*2 + 100;
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 160, 50)];
    self.userName.text = @"用户名称";
    self.userName.numberOfLines = 2;
    self.userName.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
    self.userName.textColor = [UIColor whiteColor];
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:self.userName];
    
    height += 50.0f;
    self.userMark = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 160, 20)];
    self.userMark.text = @"暂无个性签名";
    self.userMark.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    self.userMark.textColor = [UIColor whiteColor];
    self.userMark.backgroundColor = [UIColor clearColor];
    self.userMark.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:self.userMark];
    
    height += 20.0f;
    self.userScore = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userScore.frame = CGRectMake(x, height, 80, 20);
    self.userScore.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [self.userScore setTitle:@"0积分" forState:UIControlStateNormal];
    [self.userScore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.userScore setImage:[UIImage imageNamed:@"score"] forState:UIControlStateNormal];
    self.userScore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.headView addSubview:self.userScore];
    
    height += 25.0f;
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followButton.frame = CGRectMake(x, height, 70, 25);
    //self.followButton.center = CGPointMake(PAGE_MARGIN+55, PAGE_MARGIN+205);
    self.followButton.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
    self.followButton.layer.cornerRadius = 2.0f;
    self.followButton.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5f];
    [self.followButton addTarget:self action:@selector(clickFollowButton) forControlEvents:UIControlEventTouchUpInside];
    self.followButton.hidden = YES;
    [self.headView addSubview:self.followButton];
}

- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT,
                                                                     320,
                                                                     self.view.bounds.size.height-TOP_BAR_HEIGHT-TOP_HEADER_VIEW_HEIGHT)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(320, 400);
    [self.view addSubview:self.scrollView];
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    tableHeader.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self.scrollView addSubview:tableHeader];
    
    float height = 0.0f;
    LongBarButton *longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 160, MIDDLE_BAR_HEIGHT)];
    longBarButton.title.text = @"0粉丝";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    imageView.image = [UIImage imageNamed:@"fans_normal@2x.png"];
    [longBarButton setIconView:imageView];
    [longBarButton setNoSubTitle];
    longBarButton.normalIcon = imageView.image;
    //longBarButton.highlightIcon = [UIImage imageNamed:@"order_highlight@2x.png"];
    [longBarButton setTarget:self action:@selector(onClickFans)];
    [tableHeader addSubview:longBarButton];
    self.userFans = longBarButton;
    
    longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(161, height, 159, MIDDLE_BAR_HEIGHT)];
    longBarButton.title.text = @"0关注";
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    imageView.image = [UIImage imageNamed:@"follow_normal@2x.png"];
    [longBarButton setIconView:imageView];
    [longBarButton setNoSubTitle];
    longBarButton.normalIcon = imageView.image;
    //longBarButton.highlightIcon = [UIImage imageNamed:@"order_highlight@2x.png"];
    [longBarButton setTarget:self action:@selector(onClickFollow)];
    [tableHeader addSubview:longBarButton];
    self.userFollow = longBarButton;
    
    height += MIDDLE_BAR_HEIGHT + 1.0f;
    longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    longBarButton.title.text = @"动态";
    longBarButton.subTitle.text = @"0";
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    imageView.image = [UIImage imageNamed:@"dynamic_normal@2x.png"];
    [longBarButton setIconView:imageView];
    longBarButton.normalIcon = imageView.image;
    longBarButton.highlightIcon = [UIImage imageNamed:@"dynamic_highlight@2x.png"];
    [tableHeader addSubview:longBarButton];
    self.userDynamic = longBarButton;
    
    height += MIDDLE_BAR_HEIGHT;
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    shadowView.backgroundColor = [UIColor lightGrayColor];
    [tableHeader addSubview:shadowView];
}

- (BOOL)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId
{
    if ([super onNavigationItemClicked:navigationItemId])
    {
        return YES;
    }
    
    switch (navigationItemId)
    {
        case IM_NAVIGATION_ITEM_SHARE_FRIENDS:
            [self shareUserWithType:ShareTypeWeixiTimeline];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_WECHAT:
            [self shareUserWithType:ShareTypeWeixiSession];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_RENREN:
            [self shareUserWithType:ShareTypeRenren];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_SINA:
            [self shareUserWithType:ShareTypeSinaWeibo];
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
}

- (void)shareUserWithType:(ShareType)type
{
    NSDictionary *viewData = self.data[@"view_member"];
    NSString *name = viewData[@"member_name"];
    NSString *Id = viewData[@"member_id"];
    NSDictionary *share = [[ClientConfig sharedConfig] getShareStringWithName:name andId:Id from:@"share_member"];
    NSString *title = type == ShareTypeWeixiTimeline ? share[@"content"] : share[@"title"];
    
    id<ISSContent> publishContent = [ShareSDK content:share[@"content"]
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:self.headPicView.headPic quality:1.0f]
                                                title:title
                                                  url:share[@"link"]
                                          description:share[@"description"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:publishContent type:type authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (error)
        {
            NSLog(@"[%d]%@", error.errorCode, error.errorDescription);
        }
        if (SSResponseStateSuccess == state)
        {
            self.navigationBarType = self.baseNavigationBarType;
            [[self getIMNavigationController].navigationBarView setNavigationBarType:self.navigationBarType animated:YES fromTop:NO];
        }
    }];
}

- (void)setUserMemberId:(NSString *)memberId andMemberName:(NSString *)memberName
{
    self.navigationTitle = memberName;
    self.userName.text = memberName;
    self.headPicView.headPic = [UIImage imageNamed:@"man_header_big.png"];
    
    self.isLoading = YES;
    [self loadUserData:memberId];
}

- (void)loadUserData:(NSString *)memberId
{
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"view_member_id":memberId,
                          @"last_date":@"0"};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"member/member/getMemberDetail"
                                          withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnimation];
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSString *successString = result[@"success"];
                    [self showTips:successString];
                    
                    self.data = result[@"data"];
                    [self updateData];
                }
                else
                {
                    [self showTips:errorString];
                }
            }
            else
            {
                [self showTips:NSLocalizedString(@"networking_error", nil)];
            }
        });
    });
}

- (void)updateData
{
    NSDictionary *viewData = self.data[@"view_member"];
    
    NSString *vipLevel = viewData[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.headPicView.vipPic = [UIImage imageNamed:[NSString stringWithFormat:@"user_vip_%@@2x.png", vipLevel]];
    }
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", viewData[@"iconLocation"], viewData[@"iconName"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:logoUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headPicView.headPic = image;
                                                 }
                                             }];
    
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", viewData[@"dynamic_location"], viewData[@"dynamic_name"]];
    [self.photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_user.png"]];
    
    self.userFans.title.text = [NSString stringWithFormat:@"%@粉丝", [TFTools getFansString:viewData[@"followed_count"]]];
    self.userFollow.title.text = [NSString stringWithFormat:@"%@关注", [TFTools getFansString:viewData[@"following_count"]]];
    
    self.userMark.text = viewData[@"signature"];
    
    [self.userScore setTitle:[NSString stringWithFormat:@"%@积分", viewData[@"score"]] forState:UIControlStateNormal];
    
    NSDictionary *dynamicInfo = self.data[@"dynamic_info"];
    self.userDynamic.subTitle.text = dynamicInfo[@"dynamic_count"];
    if (self.userDynamic.subTitle.text.intValue > 0)
    {
        [self.userDynamic setTarget:self action:@selector(clickDynamic)];
    }
    
    [self updateFollowStatus];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        self.refreshView.hidden = NO;
        
        CGPoint center = self.headView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-scrollView.contentOffset.y)/2;
        self.headView.center = center;
        
        center = self.photoView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-scrollView.contentOffset.y)/2;
        self.photoView.center = center;
        
        if (!self.isLoading)
        {
            self.refreshView.dy = scrollView.contentOffset.y;
            if (scrollView.contentOffset.y <= -80)
            {
                self.refreshView.refreshState = REFRESH_RELEASE;
            }
            else
            {
                self.refreshView.refreshState = REFRESH_PULL;
            }
        }
    }
    
    if (scrollView.contentOffset.y >= 0)
    {
        self.refreshView.hidden = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y <= -80)
    {
        if (!self.isLoading)
        {
            [self startAnimation];
            
            NSDictionary *viewData = self.data[@"view_member"];
            [self performSelector:@selector(loadUserData:) withObject:viewData[@"member_id"] afterDelay:0.5f];
        }
    }
}

- (void)startAnimation
{
    self.isLoading = YES;
    self.scrollView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    self.scrollView.userInteractionEnabled = NO;
    
    self.refreshView.refreshState = REFRESH_NOW;
}

- (void)stopAnimation
{
    if (!self.isLoading)
    {
        return;
    }
    self.isLoading = NO;
    self.refreshView.refreshState = REFRESH_PULL;
    self.refreshView.lastUpdateTime = [NSDate date];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.scrollView setContentOffset:CGPointZero animated:NO];
    } completion:^(BOOL finished) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollView.userInteractionEnabled = YES;
    }];
}

- (void)onClickFollow
{
    NSDictionary *viewData = self.data[@"view_member"];
    NSString *follow = viewData[@"following_count"];
    if (follow.intValue > 0)
    {
        FollowViewController *vc = [[FollowViewController alloc] initWithNibName:nil bundle:nil];
        vc.data = @{@"following_member_id":viewData[@"member_id"],
                    @"name":viewData[@"member_name"]};
        [[self getIMNavigationController] pushViewController:vc animated:YES];
    }
}

- (void)onClickFans
{
    NSDictionary *viewData = self.data[@"view_member"];
    NSString *fans = viewData[@"followed_count"];
    if (fans.intValue > 0)
    {
        FansViewController *vc = [[FansViewController alloc] initWithNibName:nil bundle:nil];
        vc.data = @{@"followed_member_id":viewData[@"member_id"],
                    @"followed_store_id":@"",
                    @"name":viewData[@"member_name"]};
        [[self getIMNavigationController] pushViewController:vc animated:YES];
    }
}

- (void)clickFollowButton
{
    NSDictionary *viewData = self.data[@"view_member"];
    NSString *followStatus = viewData[@"follow_status"];
    NSString *status = followStatus.intValue > 0 ? @"0" : @"1";
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"following_member_id":viewData[@"member_id"],
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
                    [self showTips:successString];
                    
                    NSDictionary *resultData = result[@"data"];
                    NSMutableDictionary *data = [self.data mutableCopy];
                    NSMutableDictionary *viewMember = [data[@"view_member"] mutableCopy];
                    viewMember[@"follow_status"] = resultData[@"follow_status"];
                    data[@"view_member"] = viewMember;
                    _data = data;
                    
                    [self updateFollowStatus];
                }
                else
                {
                    [self showTips:errorString];
                }
            }
            else
            {
                [self showTips:NSLocalizedString(@"networking_error", nil)];
            }
        });
    });
}

- (void)updateFollowStatus
{
    NSDictionary *viewData = self.data[@"view_member"];
    NSString *followStatus = viewData[@"follow_status"];
    if (followStatus && [followStatus length] > 0)
    {
        self.followButton.hidden = NO;
        if (followStatus.intValue == 0)
        {
            [self.followButton setTitle:@"未关注" forState:UIControlStateNormal];
        }
        else if (followStatus.intValue == 1)
        {
            [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        }
        else
        {
            [self.followButton setTitle:@"相互关注" forState:UIControlStateNormal];
        }
    }
}

- (void)clickDynamic
{
    DynamicViewController *vc = [[DynamicViewController alloc] initWithNibName:nil bundle:nil];
    vc.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
    vc.baseNavigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
    NSDictionary *viewData = self.data[@"view_member"];
    vc.viewMemberId = viewData[@"member_id"];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

@end
