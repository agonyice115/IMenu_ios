//
//  ShopViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-16.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopViewController.h"
#import "UserData.h"
#import "IMSegmentedControl.h"
#import "ShopCell.h"
#import "UIColor+HtmlColor.h"
#import "ShopDetailsViewController.h"
#import "ShopMenuViewController.h"
#import "MenuDetailViewController.h"
#import "ShopFilterViewController.h"
#import "Networking.h"
#import "ShopMapViewController.h"
#import "IMPopViewController.h"
#import "ShopNoMenuCell.h"
#import "IMRefreshView.h"
#import "FirstShowHelpView.h"

@interface ShopViewController () <UITableViewDataSource, UITableViewDelegate, ShopCellDelegate, IMSegmentedControlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *sortView;

@property (nonatomic, assign) CGFloat startPosY;
@property (nonatomic, assign) BOOL isDraging;
@property (nonatomic, assign) BOOL isShowSortView;

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *regionId;

@property (nonatomic, assign) NSUInteger currentSortIndex;
@property (nonatomic, assign) BOOL ascending;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL isNetworking;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, assign) BOOL isShowMenuImage;

@property (nonatomic, strong) IMRefreshView *refreshView;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation ShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"main_title3", nil);
        
        if ([UserData sharedUserData].isLogin)
        {
            self.navigationBarType = IM_NAVIGATION_BAR_TYPE_SHOP;
        }
        else
        {
            self.navigationBarType = IM_NAVIGATION_BAR_TYPE_UNLOGIN;
        }
        self.baseNavigationBarType = IM_NAVIGATION_BAR_TYPE_SHOP;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_SHOP;
        
        self.regionId = [UserData sharedUserData].shopRegionId;
        if (!self.regionId)
        {
            self.regionId = @"29";
        }
        self.categoryId = @"0";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopRegionIdChanged) name:@"ShopRegionIdChanged" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isShowMenuImage = [Networking sharedNetworking].isWiFi;
    
    // 加载列表视图
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT+50, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    self.refreshView = [IMRefreshView createRefreshView];
    self.refreshView.center = CGPointMake(160, -30);
    self.refreshView.hidden = YES;
    self.refreshView.darkTheme = YES;
    [self.tableView addSubview:self.refreshView];
    
    // 加载排序视图
    if ([[UserData sharedUserData].longitude isEqualToString:@"0"])
    {
        self.currentSortIndex = 2;
    }
    else
    {
        self.currentSortIndex = 0;
    }
    self.isShowSortView = YES;
    IMSegmentedControl *seg = [[IMSegmentedControl alloc] initWithFrame:CGRectMake(20, 10, 280, 30)
                                                     withSegmentedItems:@[NSLocalizedString(@"store_sort_title1", nil),
                                                                          NSLocalizedString(@"store_sort_title2", nil),
                                                                          NSLocalizedString(@"store_sort_title3", nil)]
                                                                atIndex:self.currentSortIndex];
    seg.delegate = self;
    seg.isSorted = YES;
    
    self.sortView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, 320, 50)];
    self.sortView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.sortView.clipsToBounds = YES;
    [self.sortView addSubview:seg];
    [self.view addSubview:self.sortView];
    
    self.ascending = NO;
    
    //[self createLocationShow];
    
    [self loadShopData];
}

- (void)shopRegionIdChanged
{
    self.regionId = [UserData sharedUserData].shopRegionId;
    
    [self loadShopData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createLocationShow
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdating) name:@"LocationUpdating" object:nil];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-20, 320, 20)];
    self.locationLabel.backgroundColor = [UIColor whiteColor];
    self.locationLabel.text = [NSString stringWithFormat:@"(%@, %@)", [UserData sharedUserData].latitude, [UserData sharedUserData].longitude];
    [self.view addSubview:self.locationLabel];
}

- (void)locationUpdating
{
    self.locationLabel.text = [NSString stringWithFormat:@"(%@, %@)", [UserData sharedUserData].latitude, [UserData sharedUserData].longitude];
}

- (BOOL)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId
{
    if ([super onNavigationItemClicked:navigationItemId])
    {
        return YES;
    }
    
    switch (navigationItemId)
    {
        case IM_NAVIGATION_ITEM_SHOP:
        {
            ShopFilterViewController *vc = [[ShopFilterViewController alloc] initWithNibName:nil bundle:nil];
            vc.regionId = self.regionId;
            vc.categoryId = self.categoryId;
            vc.shopVC = self;
            [[self getIMNavigationController] presentViewController:vc animated:YES completion:nil];
        }
            break;
            
        case IM_NAVIGATION_ITEM_MAP:
        {
            if (self.data == nil)
            {
                return YES;
            }
            IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
            viewController.bottomAnimation = NO;
            
            NSString *orderType = self.ascending ? @"DESC" : @"ASC";
            NSDictionary *dic = @{@"category_id":self.categoryId,
                                  @"region_id":self.regionId,
                                  @"sort_type":[NSString stringWithFormat:@"%d", self.currentSortIndex+1],
                                  @"order_type":orderType,
                                  @"store_count":@"15",
                                  @"menu_count":@"1",
                                  @"longitude_num":[UserData sharedUserData].longitude,
                                  @"latitude_num":[UserData sharedUserData].latitude};
            
            ShopMapViewController *vc = [[ShopMapViewController alloc] initWithNibName:nil bundle:nil];
            vc.type = self.currentSortIndex;
            vc.storeList = self.data;
            vc.urlData = dic;
            vc.pageIndex = self.pageIndex;
            [viewController setRootViewController:vc withTitle:NSLocalizedString(@"store_map_title", nil) animated:NO];
            
            [[self getIMNavigationController] presentViewController:viewController animated:YES completion:nil];
        }
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
}

- (void)setCategoryId:(NSString *)categoryId andRegionId:(NSString *)regionId
{
    if ([categoryId isEqualToString:_categoryId] && [regionId isEqualToString:_regionId])
    {
        return;
    }
    
    _categoryId = categoryId;
    _regionId = regionId;
    
    NSLog(@"选择了：【分类】%@，【区域】%@", categoryId, regionId);
    [self loadShopData];
}

- (void)segmented:(IMSegmentedControl *)segment clickSegmentItemAtIndex:(NSUInteger)index bySort:(BOOL)isAscending
{
    self.currentSortIndex = index;
    self.ascending = isAscending;
    
    [self loadShopData];
}

- (void)loadShopData
{
    if (self.isNetworking)
    {
        return;
    }
    
    self.data = nil;
    self.tableView.hidden = YES;
    self.pageIndex = 1;
    
    [IMLoadingView showLoading];
    [self loadDataFromServer];
}

- (void)loadMoreShopData
{
    if (self.isNetworking)
    {
        return;
    }
    
    if (self.tableView.tableFooterView == nil)
    {
        return;
    }
    
    self.pageIndex += 1;
    
    [self loadDataFromServer];
}

- (void)loadDataFromServer
{
    self.isNetworking = YES;
    
    NSString *orderType = self.ascending ? @"DESC" : @"ASC";
    NSDictionary *dic = @{@"category_id":self.categoryId,
                          @"region_id":self.regionId,
                          @"sort_type":[NSString stringWithFormat:@"%d", self.currentSortIndex+1],
                          @"order_type":orderType,
                          @"store_count":@"15",
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex],
                          @"menu_count":@"6",
                          @"longitude_num":[UserData sharedUserData].longitude,
                          @"latitude_num":[UserData sharedUserData].latitude};
    
    __weak ShopViewController *wself = self;
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"store/store/getStoreListAndMenus" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.isNetworking = NO;
            [wself stopAnimation];
            [IMLoadingView hideLoading];
            wself.isShowMenuImage = [Networking sharedNetworking].isWiFi;
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    if (wself.isShowMenuImage)
                    {
                        if ([UserData sharedUserData].isLogin)
                        {
                            [FirstShowHelpView loadHelpView:HELP_STORE_WIFI_LOGIN];
                        }
                        else
                        {
                            [FirstShowHelpView loadHelpView:HELP_STORE_WIFI];
                        }
                    }
                    else
                    {
                        if ([UserData sharedUserData].isLogin)
                        {
                            [FirstShowHelpView loadHelpView:HELP_STORE_3G_LOGIN];
                        }
                        else
                        {
                            [FirstShowHelpView loadHelpView:HELP_STORE_3G];
                        }
                    }
                    
                    NSDictionary *resultData = result[@"data"];
                    NSArray *storeList = resultData[@"store_list"];
                    if ([storeList isKindOfClass:[NSArray class]])
                    {
                        if (wself.pageIndex == 1)
                        {
                            wself.data = storeList;
                            wself.tableView.hidden = NO;
                            [wself.tableView reloadData];
                            if (wself.isShowSortView)
                            {
                                [wself.tableView setContentOffset:CGPointMake(0, -TOP_BAR_HEIGHT-50) animated:NO];
                            }
                            else
                            {
                                [wself.tableView setContentOffset:CGPointMake(0, -TOP_BAR_HEIGHT) animated:NO];
                            }
                            
                            if ([storeList count] == 15)
                            {
                                if (wself.tableView.tableFooterView == nil)
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
                                    
                                    wself.tableView.tableFooterView = footView;
                                }
                            }
                            else
                            {
                                wself.tableView.tableFooterView = nil;
                            }
                        }
                        else
                        {
                            wself.data = [wself.data arrayByAddingObjectsFromArray:storeList];
                            [wself.tableView reloadData];
                        }
                    }
                    else
                    {
                        wself.tableView.tableFooterView = nil;
                    }
                }
                else
                {
                    [wself showTips:errorString];
                }
            }
            else
            {
                [wself showTips:NSLocalizedString(@"networking_error", nil)];
                
                if (wself.tableView.hidden)
                {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [button setTitle:@"点击重新加载" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateNormal];
                    button.bounds = CGRectMake(0, 0, 320, 300);
                    button.center = wself.tableView.center;
                    [button addTarget:wself action:@selector(reloadData:) forControlEvents:UIControlEventTouchUpInside];
                    [wself.view addSubview:button];
                }
            }
        });
    });
}

- (void)reloadData:(id)sender
{
    UIButton *button = sender;
    [button removeFromSuperview];
    
    [IMLoadingView showLoading];
    [self loadDataFromServer];
}

#pragma mark - UITableView 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowMenuImage)
    {
        return 180.0f;
    }
    else
    {
        return 100.0f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowMenuImage)
    {
        ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCell"];
        if (cell == nil)
        {
            cell = [[ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        [cell setData:self.data[indexPath.row] withType:self.currentSortIndex];
        
        return cell;
    }
    else
    {
        ShopNoMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopNoMenuCell"];
        if (cell == nil)
        {
            cell = [[ShopNoMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopNoMenuCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        [cell setData:self.data[indexPath.row] withType:self.currentSortIndex];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *data = self.data[indexPath.row];
//    ShopMenuViewController *vc = [[ShopMenuViewController alloc] initWithNibName:nil bundle:nil];
//    vc.storeData = [self getStoreData:data];
//    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

#pragma mark - UIScrollView 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isDraging)
    {
        if (!self.isShowSortView && scrollView.contentOffset.y < self.startPosY)
        {
            self.isShowSortView = YES;
            [UIView animateWithDuration:0.3f animations:^{
                self.sortView.frame = CGRectMake(0, TOP_BAR_HEIGHT, 320, 50);
            } completion:^(BOOL finished) {
                self.sortView.frame = CGRectMake(0, TOP_BAR_HEIGHT, 320, 50);
            }];
        }
        else if (self.isShowSortView && scrollView.contentOffset.y > self.startPosY)
        {
            self.isShowSortView = NO;
            [UIView animateWithDuration:0.3f animations:^{
                self.sortView.frame = CGRectMake(0, TOP_BAR_HEIGHT, 320, 0);
            } completion:^(BOOL finished) {
                self.sortView.frame = CGRectMake(0, TOP_BAR_HEIGHT, 320, 0);
            }];
        }
    }
    
    if (scrollView.contentOffset.y > scrollView.contentSize.height - 800)
    {
        [self loadMoreShopData];
    }
    
    CGFloat y = scrollView.contentOffset.y+(TOP_BAR_HEIGHT+50);
    if (y <= 0)
    {
        self.refreshView.hidden = NO;
        if (!self.isLoading)
        {
            self.refreshView.dy = scrollView.contentOffset.y;
            if (y <= -50)
            {
                self.refreshView.refreshState = REFRESH_RELEASE;
            }
            else
            {
                self.refreshView.refreshState = REFRESH_PULL;
            }
        }
    }
    
    if (y >= 0)
    {
        self.refreshView.hidden = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDraging = YES;
    self.startPosY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDraging = NO;
    
    if (scrollView.contentOffset.y <= -(TOP_BAR_HEIGHT+50+50))
    {
        if (!self.isLoading)
        {
            [self startAnimation];
            
            self.pageIndex = 1;
            [self performSelector:@selector(loadDataFromServer) withObject:nil afterDelay:0.5f];
        }
    }
}

- (void)startAnimation
{
    self.isLoading = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT+50+50, 0, 0, 0);
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

#pragma mark - ShopCell 代理方法

- (void)onClickTitleWithData:(NSDictionary *)data
{
    ShopDetailsViewController *vc = [[ShopDetailsViewController alloc] initWithNibName:nil bundle:nil];
    [vc setStoreId:data[@"store_id"] andStoreName:data[@"store_name"]];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)onClickDishesWithData:(NSDictionary *)data andShopData:(NSDictionary *)shop
{
    MenuDetailViewController *vc = [[MenuDetailViewController alloc] initWithNibName:nil bundle:nil];
    [vc setMenuId:data[@"menu_id"]];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)onClickMoreWithData:(NSDictionary *)data
{
    ShopMenuViewController *vc = [[ShopMenuViewController alloc] initWithNibName:nil bundle:nil];
    vc.storeData = [self getStoreData:data];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (NSDictionary *)getStoreData:(NSDictionary *)data
{
    NSMutableDictionary *storeData = [NSMutableDictionary dictionary];
    storeData[@"store_id"] = data[@"store_id"];
    storeData[@"store_name"] = data[@"store_name"];
    storeData[@"store_logo_name"] = data[@"store_logo_name"];
    storeData[@"store_logo_location"] = data[@"store_logo_location"];
    storeData[@"vip_level"] = data[@"vip_level"];
    return storeData;
}

@end
