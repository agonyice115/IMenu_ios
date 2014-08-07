//
//  DynamicDetailViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DynamicDetailViewController.h"
#import "UIColor+HtmlColor.h"
#import "IMSegmentedControl.h"
#import "RoundHeadView.h"
#import "Networking.h"
#import "UserData.h"
#import "Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommentCell.h"
#import "MenuPhotoView.h"
#import "FollowSelectViewController.h"
#import "TFTools.h"
#import "CommentInputView.h"
#import "MenuImageViewController.h"
#import "UIViewController+GetTop.h"
#import "ClientConfig.h"
#import <ShareSDK/ShareSDK.h>
#import "IMRefreshView.h"
#import "MineViewController.h"
#import "OthersViewController.h"

#define TOP_HEADER_VIEW_HEIGHT 130.0f

const CGFloat kGoodHeight = 50.0f;

@interface DynamicDetailViewController () <UITableViewDataSource, UITableViewDelegate, DynamicCellDelegate>

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) RoundHeadView *headPicView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userMark;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) CommentInputView *inputView;

@property (nonatomic, strong) NSArray *commentList;

@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL isNetworking;

@property (nonatomic, strong) UILabel *goodCount;
@property (nonatomic, strong) UIButton *goodButton;
@property (nonatomic, assign) int curGoodCount;
@property (nonatomic, assign) BOOL isGood;
@property (nonatomic, strong) NSString *dynamicGoodId;
@property (nonatomic, strong) NSArray *goodList;

@property (nonatomic, strong) UIView *goodListView;

@property (nonatomic, strong) UITextView *dynamicTitle;

@property (nonatomic, strong) NSString *reMemberId;

@property (nonatomic, strong) NSDictionary *shareImageView;

@property (nonatomic, strong) IMRefreshView *refreshView;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation DynamicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"main_title2", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_DYNIMIC;
        
        self.commentList = @[];
        self.reMemberId = @"";
        self.dynamicGoodId = @"";
        self.pageIndex = 1;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    height += 10.0f;
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
}

- (void)createView
{
    if (self.isCreateView)
    {
        return;
    }
    
    self.isCreateView = YES;
    
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-160,
                                                                   IMAGE_SIZE_BIG,
                                                                   IMAGE_SIZE_BIG)];
    self.photoView.image = [UIImage imageNamed:@"default_user.png"];
    self.photoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.photoView];
    
    [self createHeadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   320,
                                                                   self.view.bounds.size.height)
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.inputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-55, 320, 55)];
    [self.inputView.sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.atButton addTarget:self action:@selector(clickAtButton) forControlEvents:UIControlEventTouchUpInside];
    self.inputView.hideNoEdit = YES;
    [[self getTopParentViewController].view addSubview:self.inputView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [IMLoadingView showLoading];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.inputView)
    {
        [[self getTopParentViewController].view addSubview:self.inputView];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.inputView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self shareShopWithType:ShareTypeWeixiTimeline];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_WECHAT:
            [self shareShopWithType:ShareTypeWeixiSession];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_RENREN:
            [self shareShopWithType:ShareTypeRenren];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_SINA:
            [self shareShopWithType:ShareTypeSinaWeibo];
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
}

- (void)shareShopWithType:(ShareType)type
{
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", self.shareImageView[@"image_location"], self.shareImageView[@"image_name"]];

    if (photoUrl && photoUrl.length > 0)
    {
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:photoUrl]
                                                   options:0
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     if (finished && image)
                                                     {
                                                         [self shareShopWithType:type withImage:image];
                                                     }
                                                 }];
    }
    else
    {
        [self shareShopWithType:type withImage:[UIImage imageNamed:@"default_user.png"]];
    }
}

- (void)shareShopWithType:(ShareType)type withImage:(UIImage *)image
{
    NSDictionary *viewMember = self.data[@"view_member"];
    NSString *name = viewMember[@"member_name"];
    NSString *Id = self.dynamicId;
    NSDictionary *storeInfo = self.data[@"store_info"];
    NSString *shopName = storeInfo[@"store_name"];
    NSDictionary *share = [[ClientConfig sharedConfig] getShareStringWithName:name andId:Id shopName:shopName];
    NSString *title = type == ShareTypeWeixiTimeline ? share[@"content"] : share[@"title"];
    
    id<ISSContent> publishContent = [ShareSDK content:share[@"content"]
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:image quality:1.0f]
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.commentList[indexPath.row];
    NSNumber *height = dic[@"cell_height"];
    if (height)
    {
        return height.floatValue;
    }
    
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (cell == nil)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
    }
    cell.data = self.commentList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGRectGetMaxY(self.dynamicTitle.frame);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(self.dynamicTitle.frame))];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = nil;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kGoodHeight, kGoodHeight);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 6, 12, 6);
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#e4e6eb"];
    [button setImage:[UIImage imageNamed:@"good_gray@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickGood) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.goodButton = button;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kGoodHeight-20, kGoodHeight, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    label.text = [NSString stringWithFormat:@"%d", self.curGoodCount];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    self.goodCount = label;
    
    if (self.goodListView)
    {
        [view addSubview:self.goodListView];
    }
    
    if (self.dynamicTitle)
    {
        [view addSubview:self.dynamicTitle];
    }
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(320-45, kGoodHeight+CGRectGetHeight(self.dynamicTitle.frame)/2-20, 40, 40);
    button.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [button setImage:[UIImage imageNamed:@"comment_big_gray@2x.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"comment_big_blue@2x.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kGoodHeight-0.5f, 0, 0.5f, kGoodHeight)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dynamicTitle.frame)-0.5f, 320, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#dddddd"];
    [view addSubview:lineView];
    
    if (self.isGood)
    {
        self.goodButton.backgroundColor = [UIColor colorWithHtmlColor:@"#008fff"];
        [self.goodButton setImage:[UIImage imageNamed:@"big_good_white@2x.png"] forState:UIControlStateNormal];
        self.goodCount.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    }
    else
    {
        self.goodButton.backgroundColor = [UIColor colorWithHtmlColor:@"#e4e6eb"];
        [self.goodButton setImage:[UIImage imageNamed:@"big_good_gray@2x.png"] forState:UIControlStateNormal];
        self.goodCount.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    NSDictionary *data = self.commentList[indexPath.row];
    self.reMemberId = data[@"member_id"];
    if ([self.reMemberId isEqualToString:[UserData sharedUserData].memberId])
    {
        self.reMemberId = @"";
        return;
    }
    self.inputView.textView.placeholder = [NSString stringWithFormat:@"回复%@:", data[@"member_name"]];
    [self.inputView.textView becomeFirstResponder];
}

- (void)onClickUserHead:(UIGestureRecognizer *)tap
{
    RoundHeadView *view = (RoundHeadView *)tap.view;
    [self onClickUser:view.data];
}

- (void)onClickUser:(NSDictionary *)data
{
    if ([[UserData sharedUserData].memberId isEqualToString:data[@"member_id"]])
    {
        MineViewController *vc = [[MineViewController alloc] initWithNibName:nil bundle:nil];
        vc.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
        vc.baseNavigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
        [self.getIMNavigationController pushViewController:vc animated:YES];
    }
    else
    {
        OthersViewController *vc = [[OthersViewController alloc] initWithNibName:nil bundle:nil];
        [vc setUserMemberId:data[@"member_id"] andMemberName:data[@"member_name"]];
        [self.getIMNavigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y+TOP_BAR_HEIGHT <= 0)
    {
        self.refreshView.hidden = NO;
        CGPoint center = self.headView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-scrollView.contentOffset.y-TOP_BAR_HEIGHT)/2;
        self.headView.center = center;
        
        center = self.photoView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-scrollView.contentOffset.y-TOP_BAR_HEIGHT)/2;
        self.photoView.center = center;
        
        if (!self.isLoading)
        {
            self.refreshView.dy = scrollView.contentOffset.y;
            if (scrollView.contentOffset.y+TOP_BAR_HEIGHT <= -50)
            {
                self.refreshView.refreshState = REFRESH_RELEASE;
            }
            else
            {
                self.refreshView.refreshState = REFRESH_PULL;
            }
        }
    }
    
    if (scrollView.contentOffset.y+TOP_BAR_HEIGHT >= 0)
    {
        self.refreshView.hidden = YES;
    }
    
    if (self.tableView.tableFooterView && scrollView.contentOffset.y > scrollView.contentSize.height - 800)
    {
        [self loadMoreData];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y <= -(TOP_BAR_HEIGHT+50))
    {
        if (!self.isLoading)
        {
            [self startAnimation];
            
            self.pageIndex = 1;
            [self performSelector:@selector(loadDynamicData) withObject:nil afterDelay:0.5f];
        }
    }
}

- (void)startAnimation
{
    self.isLoading = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT+50, 0, 0, 0);
    self.tableView.userInteractionEnabled = NO;
    
    self.refreshView.refreshState = REFRESH_NOW;
}

- (void)stopAnimation
{
    if (self.isLoading)
    {
        self.isLoading = NO;
        self.refreshView.refreshState = REFRESH_PULL;
        self.refreshView.lastUpdateTime = [NSDate date];
        
        [UIView animateWithDuration:0.5f animations:^{
            [self.tableView setContentOffset:CGPointMake(0, -TOP_BAR_HEIGHT) animated:NO];
        } completion:^(BOOL finished) {
            self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
            self.tableView.userInteractionEnabled = YES;
        }];
    }
}

- (void)selectFollowUser:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSDictionary *dic = notification.object;
    if (dic == nil)
    {
        return;
    }
    
    NSString *memberName = dic[@"member_name"];
    self.inputView.textView.text = [NSString stringWithFormat:@"%@@%@ ", self.inputView.textView.text, memberName];
    [self.inputView.textView becomeFirstResponder];
}

- (void)setDynamicId:(NSString *)dynamicId
{
    _dynamicId = dynamicId;
    
    [self loadDynamicData];
}

- (void)loadDynamicData
{
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"dynamic_id":self.dynamicId,
                          @"longitude_num":[UserData sharedUserData].longitude,
                          @"latitude_num":[UserData sharedUserData].latitude};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/getDynamicDetail" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnimation];
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    self.data = [result[@"data"] lastObject];
                    [self updateDynamicData];
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

- (void)setCommentList:(NSArray *)commentList
{
    UITextView *tempView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
    tempView.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *targetFormatter = [[NSDateFormatter alloc] init];
    [targetFormatter setDateFormat:@"MM/dd HH:mm"];
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in commentList)
    {
        NSMutableDictionary *comment = [dic mutableCopy];
        
        NSDictionary *rInfo = comment[@"r_member_info"];
        
        if ([rInfo isKindOfClass:[NSDictionary class]])
        {
            NSString *rMemberName = rInfo[@"r_member_name"];
            tempView.text = [NSString stringWithFormat:@"回复%@:%@", rMemberName, comment[@"comment_content"]];
        }
        else
        {
            tempView.text = comment[@"comment_content"];
        }
        
        CGSize size = [tempView sizeThatFits:CGSizeMake(270, FLT_MAX)];
        if (size.height > 16.0f)
        {
            comment[@"cell_height"] = [NSNumber numberWithFloat:34.0f + size.height];
        }
        
        NSDate *date = [dateFormatter dateFromString:comment[@"comment_date"]];
        if (date)
        {
            comment[@"comment_date"] = [targetFormatter stringFromDate:date];
        }
        
        [list addObject:comment];
    }
    
    _commentList = list;
}

- (void)updateDynamicData
{
    [self createView];
    [IMLoadingView hideLoading];
    
    NSDictionary *viewMember = self.data[@"view_member"];
    self.userName.text = viewMember[@"member_name"];
    self.userMark.text = viewMember[@"signature"];
    
    NSString *vipLevel = viewMember[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.headPicView.vipPic = [UIImage imageNamed:[NSString stringWithFormat:@"user_vip_%@@2x.png", vipLevel]];
    }
    
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", viewMember[@"iconLocation"], viewMember[@"iconName"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:logoUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headPicView.headPic = image;
                                                 }
                                             }];
    
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", viewMember[@"dynamic_location"], viewMember[@"dynamic_name"]];
    [self.photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_user.png"]];
    
    [self createTableHeaderView];
    
    NSDictionary *dynamicInfo = [self.data[@"dynamic_info"] lastObject];
    
    self.goodListView = [[UIView alloc] initWithFrame:CGRectMake(kGoodHeight, 0, 320-kGoodHeight, kGoodHeight)];
    self.goodListView.backgroundColor = [UIColor colorWithHtmlColor:@"#e4e6eb"];
    
    self.dynamicTitle = [[UITextView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, kGoodHeight, 260, 50)];
    self.dynamicTitle.backgroundColor = [UIColor whiteColor];
    self.dynamicTitle.text = dynamicInfo[@"title"];;
    self.dynamicTitle.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    self.dynamicTitle.textColor = [UIColor blackColor];
    [self.dynamicTitle sizeToFit];
    self.dynamicTitle.userInteractionEnabled = NO;
    [self.tableView reloadData];
    
    NSString *goodCount = dynamicInfo[@"goods_count"];
    if (goodCount.intValue > 0)
    {
        self.curGoodCount = goodCount.intValue;
        self.goodCount.text = goodCount;
        // 加载赞数据
        [self loadGoodData];
    }
    NSString *commentCount = dynamicInfo[@"comment_count"];
    if (commentCount.intValue > 0)
    {
        // 加载评论数据
        self.pageIndex = 1;
        [self loadCommentData];
    }
}

- (void)createTableHeaderView
{
    NSArray *menuList = self.data[@"menu_list"];
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    tableHeader.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    float height = 4.0f;
    NSUInteger count = menuList.count;
    for (int i = 0; i < count; i++)
    {
        int row = i/3;
        int col = i%3;
        
        NSDictionary *menuData = menuList[i];
        MenuPhotoView *photoView = [[MenuPhotoView alloc] initWithFrame:CGRectMake(6+col*(IMAGE_SIZE_MIDDLE+4),
                                                                                   height+row*(IMAGE_SIZE_MIDDLE+4),
                                                                                   IMAGE_SIZE_MIDDLE,
                                                                                   IMAGE_SIZE_MIDDLE)];
        photoView.dishesName.text = menuData[@"menu_name"];
        photoView.data = menuData;
        photoView.showCommentAndGoods = YES;
        photoView.tag = i+100;
        photoView.imageView.image = [UIImage imageNamed:@"default_small.png"];
        NSString *thumbUrl = [TFTools getThumbImageUrlOfLacation:menuData[@"image_location"]
                                                         andName:menuData[@"image_name"] ];
        if (thumbUrl && [thumbUrl length] > 0)
        {
            [photoView.imageView setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
        }
        
        NSString *imageId = menuData[@"member_menu_image_id"];
        if (imageId && imageId.length > 0)
        {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuCamera:)];
            [photoView addGestureRecognizer:singleTap];
        }
        
        if (i == 0)
        {
            self.shareImageView = menuData;
        }
        
        [tableHeader addSubview:photoView];
    }
    
    height += ((count-1)/3+1)*(IMAGE_SIZE_MIDDLE+4);
    
    NSDictionary *dynamicInfo = [self.data[@"dynamic_info"] lastObject];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(254, height, 60, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [button setTitle:[NSString stringWithFormat:@"%@人", dynamicInfo[@"people"]] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateDisabled];
    [button setImage:[UIImage imageNamed:@"fans_normal"] forState:UIControlStateDisabled];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    button.enabled = NO;
    [tableHeader addSubview:button];
    
    NSDictionary *storeInfo = self.data[@"store_info"];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(6, height, 240, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [button setTitle:storeInfo[@"address"] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateDisabled];
    [button setImage:[UIImage imageNamed:@"map_normal"] forState:UIControlStateDisabled];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 8)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    button.enabled = NO;
    [tableHeader addSubview:button];
    
    height += 30;
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    shadowView.backgroundColor = [UIColor lightGrayColor];
    [tableHeader addSubview:shadowView];
    
    height += 1;
    tableHeader.frame = CGRectMake(0, TOP_HEADER_VIEW_HEIGHT, 320, height);
    
    UIView *trueHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height+TOP_HEADER_VIEW_HEIGHT)];
    trueHeader.backgroundColor = [UIColor clearColor];
    [trueHeader addSubview:tableHeader];
    
    self.tableView.tableHeaderView = trueHeader;
}

- (void)clickMenuCamera:(UIGestureRecognizer *)tap
{
    MenuPhotoView *photoView = (MenuPhotoView *)tap.view;
    NSUInteger index = photoView.tag-100;
    
    NSUInteger menuIndex = 0;
    NSUInteger minus = 0;
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSDictionary *menuData in self.data[@"menu_list"])
    {
        NSMutableDictionary *data = [menuData mutableCopy];
        
        NSString *imageId = data[@"member_menu_image_id"];
        if (imageId && imageId.length > 0)
        {
            data[@"dynamic_id"] = self.dynamicId;
            data[@"member_info"] = self.data[@"view_member"];
            [dataList addObject:data];
        }
        else
        {
            if (menuIndex < index)
            {
                minus++;
            }
        }
        menuIndex++;
    }
    
    MenuImageViewController *vc = [[MenuImageViewController alloc] initWithNibName:nil bundle:nil];
    [vc setMenudata:dataList ofIndex:(index-minus) showDynamic:NO];
    [[self getIMNavigationController] presentViewController:vc animated:YES completion:nil];
}

- (void)loadGoodData
{
    NSDictionary *dynamicInfo = [self.data[@"dynamic_info"] lastObject];
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"dynamic_id":dynamicInfo[@"dynamic_id"],
                          @"count":@"30",
                          @"page":@"1"};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/getDynamicGoods" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *returnData = [result[@"data"] lastObject];
                    NSDictionary *memberGoods = returnData[@"member_goods"];
                    NSString *goodStatus = memberGoods[@"goods_status"];
                    self.dynamicGoodId = memberGoods[@"dynamic_goods_id"];
                    self.isGood = [goodStatus isEqualToString:@"1"];
                    NSString *goodsCount = returnData[@"goods_count"];
                    self.curGoodCount = goodsCount.intValue;
                    self.goodCount.text = goodsCount;
                    self.goodList = returnData[@"goods_list"];
                    
                    // 加载动态头像列表
                    [self createDynamicGoodList];
                    [self.tableView reloadData];
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

- (void)loadMoreData
{
    if (self.isNetworking)
    {
        return;
    }
    
    self.pageIndex += 1;
    [self loadCommentData];
}

- (void)loadCommentData
{
    self.isNetworking = YES;
    
    NSDictionary *dynamicInfo = [self.data[@"dynamic_info"] lastObject];
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"dynamic_id":dynamicInfo[@"dynamic_id"],
                          @"count":@"10",
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex]};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/getDynamicComment" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.isNetworking = NO;
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *returnData = [result[@"data"] lastObject];
                    
                    if (self.pageIndex == 1)
                    {
                        [self.tableView setContentOffset:CGPointMake(0, -(TOP_BAR_HEIGHT+50)) animated:NO];
                        self.commentList = returnData[@"comment_list"];
                    }
                    else
                    {
                        self.commentList = [self.commentList arrayByAddingObjectsFromArray:returnData[@"comment_list"]];
                    }
                    
                    [self.tableView reloadData];
                    
                    if ([returnData[@"comment_list"] count] == 10)
                    {
                        // 显示加载更多
                        if (self.tableView.tableFooterView == nil)
                        {
                            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                            footView.backgroundColor = [UIColor clearColor];
                            
                            UIImageView *loading = [[UIImageView alloc] initWithFrame:CGRectMake(148, 10, 30, 30)];
                            loading.image = [UIImage imageNamed:@"loading_dark.png"];
                            CABasicAnimation* rotationAnimation;
                            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
                            rotationAnimation.duration = 2.0f;
                            rotationAnimation.cumulative = YES;
                            rotationAnimation.repeatCount = HUGE_VALF;
                            [loading.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                            [footView addSubview:loading];
                            
                            self.tableView.tableFooterView = footView;
                        }
                    }
                    else
                    {
                        self.tableView.tableFooterView = nil;
                    }
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

- (void)clickComment
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    self.reMemberId = @"";
    self.inputView.textView.placeholder = @"评论";
    [self.inputView.textView becomeFirstResponder];
}

- (void)clickGood
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    
    NSDictionary *dynamicInfo = [self.data[@"dynamic_info"] lastObject];
    NSString *goodsType = self.isGood ? @"0" : @"1";
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"dynamic_id":dynamicInfo[@"dynamic_id"],
                          @"goods_type":goodsType,
                          @"dynamic_goods_id":self.dynamicGoodId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/editDynamicGoods" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    self.isGood = !self.isGood;
                    if (self.isGood)
                    {
                        [self showTips:NSLocalizedString(@"dynamic_view_success_tip1", nil)];
                    }
                    else
                    {
                        [self showTips:NSLocalizedString(@"dynamic_view_success_tip2", nil)];
                    }
                    
                    [self loadGoodData];
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

- (void)clickAtButton
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFollowUser:) name:FOLLOW_SELECT_NAME object:nil];
    
    FollowSelectViewController *vc = [[FollowSelectViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] presentViewController:vc animated:YES completion:nil];
}

- (void)clickSendButton
{
    [self sendComment:self.inputView.textView.text toMember:self.reMemberId];
    [self.inputView clearContent];
    [self.inputView.textView resignFirstResponder];
}

- (void)sendComment:(NSString *)comment toMember:(NSString *)memberId
{
    if (!comment || comment.length == 0)
    {
        return;
    }
    
    NSDictionary *dynamicInfo = [self.data[@"dynamic_info"] lastObject];
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"dynamic_id":dynamicInfo[@"dynamic_id"],
                          @"comment_content":comment,
                          @"comment_type":@"1",
                          @"dynamic_comment_id":@"",
                          @"r_member_id":memberId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/editDynamicComment" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    [self showTips:NSLocalizedString(@"dynamic_view_success_tip3", nil)];
                    self.pageIndex = 1;
                    [self loadCommentData];
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

- (void)createDynamicGoodList
{
    self.goodListView = [[UIView alloc] initWithFrame:CGRectMake(kGoodHeight, 0, 320-kGoodHeight, kGoodHeight)];
    self.goodListView.backgroundColor = [UIColor colorWithHtmlColor:@"#e4e6eb"];
    
    for (int i = 0; i < self.goodList.count; i++)
    {
        NSDictionary *dic = self.goodList[i];
        
        RoundHeadView *imageView = [[RoundHeadView alloc] initWithFrame:CGRectMake(5+i*(IMAGE_SIZE_TINY+5), 5, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
        imageView.roundSideWidth = 1.0f;
        imageView.data = dic;
        
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickUserHead:)]];
        
        imageView.headPic = [UIImage imageNamed:@"man_header_small.png"];
        NSString *url = [TFTools getThumbImageUrlOfLacation:dic[@"iconLocation"] andName:dic[@"iconName"]];
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                                   options:0
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     if (finished && image)
                                                     {
                                                         imageView.headPic = image;
                                                     }
                                                 }];
        
        [self.goodListView addSubview:imageView];
    }
}

@end
