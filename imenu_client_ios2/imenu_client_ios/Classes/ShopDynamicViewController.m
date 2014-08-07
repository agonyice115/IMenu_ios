//
//  ShopDynamicViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-22.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopDynamicViewController.h"
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

#define TOP_HEADER_VIEW_HEIGHT 130.0f


@interface ShopDynamicViewController () <UITableViewDataSource, UITableViewDelegate, IMSegmentedControlDelegate, DynamicCellDelegate>

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

@end

@implementation ShopDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = @"商家动态";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_DYNIMIC;
        
        _filterList = @[];
        self.data = @[];
        self.filterIndex = 2;
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
    self.photoView.image = [UIImage imageNamed:@"default_shop.png"];
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
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT+50, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    [self createSegmentView];
}

- (void)createHeadView
{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-160, 320, 320)];
    self.headView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    [self.view addSubview:self.headView];
    
    float height = 60.0f;
    
    self.refreshView = [IMRefreshView createRefreshView];
    self.refreshView.frame = CGRectMake(0, height, 320, 50);
    self.refreshView.hidden = YES;
    [self.headView addSubview:self.refreshView];
    
    height += 50.0f;
    self.headPicView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE)];
    self.headPicView.headPic = [UIImage imageNamed:@"shop_logo_big.png"];
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
}

- (void)createSegmentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT, 320, 50)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    IMSegmentedControl *seg = [[IMSegmentedControl alloc] initWithFrame:CGRectMake(10, 10, 300, 30)
                                                     withSegmentedItems:@[NSLocalizedString(@"dynamic_group_title3", nil),
                                                                          NSLocalizedString(@"dynamic_group_title2", nil),
                                                                          NSLocalizedString(@"dynamic_group_title1", nil)]
                                                                atIndex:0];
    seg.delegate = self;
    [view addSubview:seg];
    [self.view addSubview:view];
    
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
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
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
        return TOP_HEADER_VIEW_HEIGHT-30.0f;
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
    
    cell.data = dic;
    
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
    DynamicDetailViewController *vc = [[DynamicDetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.dynamicId = dic[@"dynamic_id"];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
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

- (void)setStoreId:(NSString *)storeId
{
    _storeId = storeId;
    
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
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"store_id":self.storeId,
                          @"filter_date_type":[NSString stringWithFormat:@"%d", self.filterIndex+1],
                          @"dynamic_count":@"20",
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex],
                          @"menu_count":@"3",
                          @"dynamic_last_date":@"0",
                          @"longitude_num":[UserData sharedUserData].longitude,
                          @"latitude_num":[UserData sharedUserData].latitude};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/getStoreDynamicList" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = [result[@"data"] lastObject];
                    
                    [self createView];
                    
                    [self setViewStoreData:resultData[@"view_store"]];
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
    [self.photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_shop.png"]];
}

- (void)setViewStoreData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    self.viewMemberInfo = data;
    
    self.userName.text = data[@"store_name"];
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", data[@"store_logo_location"], data[@"store_logo_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:logoUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headPicView.headPic = image;
                                                 }
                                             }];
    
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", data[@"store_dynamic_location"], data[@"store_dynamic_name"]];
    [self.photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_shop.png"]];
}

@end
