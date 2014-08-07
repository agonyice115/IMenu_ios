//
//  DynamicViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-17.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DynamicViewController.h"
#import "UIColor+HtmlColor.h"
#import "IMSegmentedControl.h"
#import "RoundHeadView.h"
#import "Networking.h"
#import "UserData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DynamicCell.h"
#import "DynamicSectionView.h"
#import "DynamicDetailViewController.h"
#import "IMConfig.h"
#import "IMPopViewController.h"
#import "NewDynamicViewController.h"
#import "IMRefreshView.h"
#import "MineViewController.h"
#import "OthersViewController.h"
#import "DynamicSwitchView.h"
#import "DynamicMessageViewController.h"

#define TOP_HEADER_VIEW_HEIGHT 130.0f


@interface DynamicViewController () <UITableViewDataSource, UITableViewDelegate, IMSegmentedControlDelegate, DynamicCellDelegate>

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) RoundHeadView *headPicView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userMark;
@property (nonatomic, strong) UIButton *userMessage;

@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) UIButton *dynamicKind;
@property (nonatomic, strong) IMSegmentedControl *dynamicGroup;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger filterIndex;
@property (nonatomic, strong) NSArray *filterList;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL isNetworking;

@property (nonatomic, strong) IMRefreshView *refreshView;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) NSDictionary *viewMemberInfo;

@property (nonatomic, strong) NSString *route;

@property (nonatomic, strong) DynamicSwitchView *switchView;

@property (nonatomic, assign) BOOL showFriend;

@property (nonatomic, strong) UIView *noContentView;

@end

@implementation DynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"main_title2", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_DYNIMIC;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_DYNIMIC;
        
        self.showFriend = YES;
        self.showPublic = YES;
        _filterList = @[];
        self.data = @[];
        self.filterIndex = 2;
        
        self.route = @"dynamic/dynamic/getDynamicList";
    }
    return self;
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT+100, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    if (self.viewMemberId.length == 0)
    {
        [self setMineData];
    }
    
    [self createSegmentView];
    
    self.switchView = [[DynamicSwitchView alloc] initWithFrame:self.view.bounds];
    self.switchView.showFriend = self.showFriend;
    [self.switchView.friendButton addTarget:self action:@selector(clickFriendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.switchView.cityButton addTarget:self action:@selector(clickCityButton) forControlEvents:UIControlEventTouchUpInside];
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
    
    // 暂时屏蔽消息功能 2014-02-18
//    height += 25.0f;
//    self.userMessage = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.userMessage.frame = CGRectMake(x+120, height, 80, 20);
//    self.userMessage.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
//    [self.userMessage setTitle:@"0消息" forState:UIControlStateNormal];
//    [self.userMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.userMessage setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//    self.userMessage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [self.headView addSubview:self.userMessage];
    height += 80;
    
    self.noContentView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 600-height)];
    self.noContentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.noContentView.hidden = YES;
    [self.headView addSubview:self.noContentView];
    
    UILabel *noContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 50)];
    noContent.text = @"您还没有动态，赶快去下单发动态吧";
    noContent.numberOfLines = 2;
    noContent.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    noContent.textColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
    noContent.backgroundColor = [UIColor clearColor];
    noContent.textAlignment = NSTextAlignmentCenter;
    [self.noContentView addSubview:noContent];
}

- (void)createSegmentView
{
    BOOL showKindButton = NO;
    if (self.viewMemberId.length > 0 && [self.viewMemberId isEqualToString:[UserData sharedUserData].memberId])
    {
        showKindButton = YES;
    }
    
    CGFloat width = showKindButton ? 230 : 300;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT, 320, 100)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    IMSegmentedControl *seg = [[IMSegmentedControl alloc] initWithFrame:CGRectMake(10, 60, width, 30)
                                                     withSegmentedItems:@[NSLocalizedString(@"dynamic_group_title3", nil),
                                                                          NSLocalizedString(@"dynamic_group_title2", nil),
                                                                          NSLocalizedString(@"dynamic_group_title1", nil)]
                                                                atIndex:0];
    seg.delegate = self;
    [view addSubview:seg];
    [self.view addSubview:view];
    
    if (YES)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(70, 10, 180, 40);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5aaa"] forState:UIControlStateNormal];
        [button setTitle:@"3条新消息" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"dynamic_msg_bg"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickMessageButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        imageView.image = [UIImage imageNamed:@"man_header_small.png"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0f;
        [button addSubview:imageView];
    }
    
    if (showKindButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(250, 60, 60, 30);
        button.backgroundColor = [IMConfig sharedConfig].bgColor;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5.0f;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#cccccc"] forState:UIControlStateHighlighted];
        [button setTitle:NSLocalizedString(@"dynamic_button_un_public", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickKindButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        self.dynamicKind = button;
        
        if (self.showPublic)
        {
            [self.dynamicKind setTitle:NSLocalizedString(@"dynamic_button_un_public", nil) forState:UIControlStateNormal];
        }
        else
        {
            [self.dynamicKind setTitle:NSLocalizedString(@"dynamic_button_public", nil) forState:UIControlStateNormal];
        }
    }
    
    self.segmentView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [IMLoadingView showLoading];
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
        case IM_NAVIGATION_ITEM_DYNIMIC:
        {
            [[self getIMNavigationController].view addSubview:self.switchView];
        }
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
}

- (void)clickFriendButton
{
    [self.switchView removeFromSuperview];
    if ([self.route isEqualToString:@"dynamic/dynamic/getDynamicList"])
    {
        return;
    }
    
    self.pageIndex = 1;
    
    [IMLoadingView showLoading];
    self.route = @"dynamic/dynamic/getDynamicList";
    [[self getIMNavigationController].navigationBarView setMiddleTitle:@"朋友动态"];
    [self loadData];
}

- (void)clickCityButton
{
    [self.switchView removeFromSuperview];
    if ([self.route isEqualToString:@"dynamic/dynamic/getRecommendDynamicList"])
    {
        return;
    }
    
    self.pageIndex = 1;
    
    [IMLoadingView showLoading];
    self.route = @"dynamic/dynamic/getRecommendDynamicList";
    [[self getIMNavigationController].navigationBarView setMiddleTitle:@"全城动态"];
    [self loadData];
}

- (void)segmented:(IMSegmentedControl *)segment clickSegmentItemAtIndex:(NSUInteger)index bySort:(BOOL)isAscending
{
    if (self.filterIndex == 2-index)
    {
        return;
    }
    
    self.filterIndex = 2-index;
    self.pageIndex = 1;
    
    [IMLoadingView showLoading];
    [self loadData];
}

- (void)setFilterList:(NSArray *)filterList
{
    NSMutableArray *array = [NSMutableArray array];
    
    int startIndex = 0;
    for (NSDictionary *dic in filterList)
    {
        NSMutableDictionary *data = [dic mutableCopy];
        data[@"start_index"] = [NSNumber numberWithInt:startIndex];
        
        startIndex += [dic[@"value"] intValue];
        
        [array addObject:data];
    }
    
    _filterList = array;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return TOP_HEADER_VIEW_HEIGHT-30.0f+50.0f;
    }
    
    return 260.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = 1;
    for (NSDictionary *dic in self.filterList)
    {
        NSNumber *startIndex = dic[@"start_index"];
        if (startIndex.intValue >= self.data.count)
        {
            break;
        }
        
        count += 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    
    --section;
    NSDictionary *dic = self.filterList[section];
    NSString *value = dic[@"value"];
    NSNumber *startIndex = dic[@"start_index"];
    int count = self.data.count - startIndex.intValue;
    if (value.intValue < count)
    {
        return value.integerValue;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    NSDictionary *filter = self.filterList[indexPath.section-1];
    NSNumber *startIndex = filter[@"start_index"];
    NSDictionary *dic = self.data[startIndex.intValue + indexPath.row];
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
    if (cell == nil)
    {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicCell"];
        cell.delegate = self;
    }
    if (self.viewMemberInfo)
    {
        [cell setData:dic andMemberInfo:self.viewMemberInfo];
    }
    else
    {
        cell.data = dic;
    }
    
    if (self.viewMemberId.length > 0 && [self.viewMemberId isEqualToString:[UserData sharedUserData].memberId])
    {
        cell.isPublic = self.showPublic;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
    NSDictionary *dic = self.filterList[section-1];
    
    NSString *title = dic[@"key"];
    switch (self.filterIndex)
    {
        case 0:
        {
            title = [title stringByAppendingString:@"年"];
        }
            break;
            
        case 1:
        {
            title = [NSString stringWithFormat:@"%@年%@月", [title substringToIndex:4], [title substringFromIndex:4]];
        }
            break;
            
        default:
        {
            title = [NSString stringWithFormat:@"%@年第%@周", [title substringToIndex:4], [title substringFromIndex:4]];
        }
            break;
    }
    
    DynamicSectionView *view = [[DynamicSectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view.sectionTitle setTitle:title forState:UIControlStateDisabled];
    view.sectionCount.text = [NSString stringWithFormat:@"共%@单", dic[@"value"]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    
    NSDictionary *filter = self.filterList[indexPath.section-1];
    NSNumber *startIndex = filter[@"start_index"];
    NSDictionary *dic = self.data[startIndex.intValue + indexPath.row];
    if (!self.showPublic)
    {
        IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
        viewController.bottomAnimation = NO;
        
        NewDynamicViewController *vc = [[NewDynamicViewController alloc] initWithNibName:nil bundle:nil];
        vc.dynamicId = dic[@"dynamic_id"];
        [viewController setRootViewController:vc withTitle:NSLocalizedString(@"dynimic_view_title", nil) animated:NO];
        
        [[self getIMNavigationController] presentViewController:viewController animated:YES completion:nil];
    }
    else
    {
        DynamicDetailViewController *vc = [[DynamicDetailViewController alloc] initWithNibName:nil bundle:nil];
        vc.dynamicId = dic[@"dynamic_id"];
        [[self getIMNavigationController] pushViewController:vc animated:YES];
    }
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
    CGFloat y = scrollView.contentOffset.y+(TOP_BAR_HEIGHT+50);
    if (y <= 0)
    {
        self.refreshView.hidden = NO;
        CGPoint center = self.headView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-y)/2;
        self.headView.center = center;
        
        center = self.photoView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-y)/2;
        self.photoView.center = center;
        
        if (!self.isLoading)
        {
            self.refreshView.dy = scrollView.contentOffset.y;
            if (y <= -80)
            {
                self.refreshView.refreshState = REFRESH_RELEASE;
            }
            else
            {
                self.refreshView.refreshState = REFRESH_PULL;
            }
        }
    }
    else
    {
        CGPoint center = self.headView.center;
        center.y = TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2;
        self.headView.center = center;
        
        center = self.photoView.center;
        center.y = TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2;
        self.photoView.center = center;
    }
    
    if (y < TOP_HEADER_VIEW_HEIGHT)
    {
        CGRect frame = self.segmentView.frame;
        frame.origin.y = TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT-y;
        self.segmentView.frame = frame;
    }
    else
    {
        CGRect frame = self.segmentView.frame;
        frame.origin.y = TOP_BAR_HEIGHT;
        self.segmentView.frame = frame;
    }
    
    if (y >= 0)
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
    if (scrollView.contentOffset.y <= -(TOP_BAR_HEIGHT+50+80))
    {
        if (!self.isLoading)
        {
            [self startAnimation];
            
            self.pageIndex = 1;
            [self performSelector:@selector(loadData) withObject:nil afterDelay:0.5f];
        }
    }
}

- (void)startAnimation
{
    self.isLoading = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT+50+80, 0, 0, 0);
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
            [self.tableView setContentOffset:CGPointMake(0, -(TOP_BAR_HEIGHT+50)) animated:NO];
        } completion:^(BOOL finished) {
            self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT+50, 0, 0, 0);
            self.tableView.userInteractionEnabled = YES;
        }];
    }
}

- (void)setViewMemberId:(NSString *)viewMemberId
{
    _viewMemberId = viewMemberId;
    
    self.pageIndex = 1;
    [self loadData];
}

- (void)loadMoreData
{
    if (self.isNetworking)
    {
        return;
    }
    
    self.pageIndex += 1;
    [self loadData];
}

- (void)loadData
{
    self.isNetworking = YES;
    
    NSString *dynamicType = @"";
    if (self.viewMemberId.length > 0 && [self.viewMemberId isEqualToString:[UserData sharedUserData].memberId])
    {
        dynamicType = self.showPublic ? @"1" : @"2";
    }
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"view_member_id":self.viewMemberId,
                          @"filter_date_type":[NSString stringWithFormat:@"%d", self.filterIndex+1],
                          @"dynamic_count":@"10",
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex],
                          @"menu_count":@"3",
                          @"dynamic_last_date":@"0",
                          @"dynamic_type":dynamicType,
                          @"longitude_num":[UserData sharedUserData].longitude,
                          @"latitude_num":[UserData sharedUserData].latitude};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:self.route withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = [result[@"data"] lastObject];
                    
                    if (![[UserData sharedUserData].memberId isEqualToString:self.viewMemberId] && self.pageIndex == 1 && [resultData[@"dynamic_list"] count] == 0)
                    {
                        self.showFriend = NO;
                        self.route = @"dynamic/dynamic/getRecommendDynamicList";
                        [[self getIMNavigationController].navigationBarView setMiddleTitle:@"全城动态"];
                        [self loadData];
                        return;
                    }
                    
                    [self createView];
                    
                    [self setViewMemberData:resultData[@"view_member"]];
                    self.filterList = resultData[@"filter_date_list"];
                    
                    if (self.pageIndex == 1)
                    {
                        [self.tableView setContentOffset:CGPointMake(0, -(TOP_BAR_HEIGHT+50)) animated:NO];
                        self.data = resultData[@"dynamic_list"];
                    }
                    else
                    {
                        self.data = [self.data arrayByAddingObjectsFromArray:resultData[@"dynamic_list"]];
                    }
                    
                    [self.tableView reloadData];
                    
                    self.noContentView.hidden = self.data.count > 0;
                    
                    NSDictionary *filter = self.filterList.lastObject;
                    if (filter)
                    {
                        NSString *value = filter[@"value"];
                        NSNumber *startIndex = filter[@"start_index"];
                        
                        if (self.data.count < value.intValue+startIndex.intValue)
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
            
            self.isNetworking = NO;
            [self stopAnimation];
            [IMLoadingView hideLoading];
        });
    });
}

- (void)setMineData
{
    self.userName.text = [UserData sharedUserData].memberName;
    self.userMark.text = [UserData sharedUserData].memberSignature;
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", [UserData sharedUserData].iconLocation, [UserData sharedUserData].iconName];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:logoUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headPicView.headPic = image;
                                                 }
                                             }];
    
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", [UserData sharedUserData].dynamicLocation, [UserData sharedUserData].dynamicName];
    [self.photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_user.png"]];
}

- (void)setViewMemberData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    if ([self.route isEqualToString:@"dynamic/dynamic/getRecommendDynamicList"])
    {
        return;
    }
    
    self.viewMemberInfo = data;
    
    self.userName.text = data[@"member_name"];
    self.userMark.text = data[@"signature"];
    
    NSString *vipLevel = data[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.headPicView.vipPic = [UIImage imageNamed:[NSString stringWithFormat:@"user_vip_%@@2x.png", vipLevel]];
    }
    
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", data[@"iconLocation"], data[@"iconName"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:logoUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headPicView.headPic = image;
                                                 }
                                             }];
    
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", data[@"dynamic_location"], data[@"dynamic_name"]];
    [self.photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_user.png"]];
}

- (void)clickKindButton
{
    self.showPublic = !self.showPublic;
    
    [IMLoadingView showLoading];
    self.pageIndex = 1;
    [self loadData];
}

- (void)clickMessageButton
{
    DynamicMessageViewController *vc = [[DynamicMessageViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)setShowPublic:(BOOL)showPublic
{
    _showPublic = showPublic;
    
    if (self.showPublic)
    {
        [self.dynamicKind setTitle:NSLocalizedString(@"dynamic_button_un_public", nil) forState:UIControlStateNormal];
    }
    else
    {
        [self.dynamicKind setTitle:NSLocalizedString(@"dynamic_button_public", nil) forState:UIControlStateNormal];
    }
}

@end
