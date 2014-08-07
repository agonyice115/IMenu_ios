//
//  SearchResultViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchDynamicCell.h"
#import "SearchMenuCell.h"
#import "SearchShopCell.h"
#import "SearchUserCell.h"
#import "UserData.h"
#import "Networking.h"
#import "UIColor+HtmlColor.h"
#import "IMNavigationController.h"
#import "ShopDetailsViewController.h"
#import "MenuDetailViewController.h"
#import "MineViewController.h"
#import "OthersViewController.h"
#import "DynamicDetailViewController.h"
#import "IMErrorTips.h"
#import "IMLoadingView.h"

#define SEARCH_COUNT @"20"

@interface SearchResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) NSUInteger searchIndex;
@property (nonatomic, strong) NSString *searchValue;

@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL isNetworking;

@end

@implementation SearchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.data = [NSArray array];
        self.searchIndex = 2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 40)];
        imageView.center = CGPointMake(160, self.view.bounds.size.height/2-90);
        imageView.image = [UIImage imageNamed:@"logo.png"];
        [self.view addSubview:imageView];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
        {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.tableView];
        
        self.tableView.hidden = YES;
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

#pragma mark - UITableView 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
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
    if (self.searchIndex == 0)
    {
        SearchMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchMenuCell"];
        if (cell == nil)
        {
            cell = [[SearchMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchMenuCell"];
        }
        cell.data = self.data[indexPath.row];
        return cell;
    }
    else if (self.searchIndex == 1)
    {
        SearchShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchShopCell"];
        if (cell == nil)
        {
            cell = [[SearchShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchShopCell"];
        }
        cell.data = self.data[indexPath.row];
        return cell;
    }
    else if (self.searchIndex == 2)
    {
        SearchDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchDynamicCell"];
        if (cell == nil)
        {
            cell = [[SearchDynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchDynamicCell"];
        }
        cell.data = self.data[indexPath.row];
        return cell;
    }
    else
    {
        SearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchUserCell"];
        if (cell == nil)
        {
            cell = [[SearchUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchUserCell"];
        }
        cell.data = self.data[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMBaseViewController *parentVC = (IMBaseViewController *)self.parentViewController;
    NSDictionary *data = self.data[indexPath.row];
    
    switch (self.searchIndex)
    {
        case 0:
        {
            MenuDetailViewController *vc = [[MenuDetailViewController alloc] initWithNibName:nil bundle:nil];
            [vc setMenuId:data[@"menu_id"]];
            [parentVC.getIMNavigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            ShopDetailsViewController *vc = [[ShopDetailsViewController alloc] initWithNibName:nil bundle:nil];
            [vc setStoreId:data[@"store_id"] andStoreName:data[@"store_name"]];
            [parentVC.getIMNavigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            DynamicDetailViewController *vc = [[DynamicDetailViewController alloc] initWithNibName:nil bundle:nil];
            vc.dynamicId = data[@"dynamic_id"];
            [parentVC.getIMNavigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            if ([[UserData sharedUserData].memberId isEqualToString:data[@"member_id"]])
            {
                MineViewController *vc = [[MineViewController alloc] initWithNibName:nil bundle:nil];
                vc.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
                vc.baseNavigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
                [parentVC.getIMNavigationController pushViewController:vc animated:YES];
            }
            else
            {
                OthersViewController *vc = [[OthersViewController alloc] initWithNibName:nil bundle:nil];
                [vc setUserMemberId:data[@"member_id"] andMemberName:data[@"member_name"]];
                [parentVC.getIMNavigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > scrollView.contentSize.height - 800)
    {
        [self loadMoreData];
    }
}

- (void)loadMoreData
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
    
    switch (self.searchIndex)
    {
        case 0:
            [self searchMenu];
            break;
            
        case 1:
            [self searchShop];
            break;
            
        case 2:
            [self searchDynamic];
            break;
            
        case 3:
            [self searchUser];
            break;
            
        default:
            break;
    }
}

- (void)setIndex:(NSUInteger)index andValue:(NSString *)value
{
    if (value.length == 0)
    {
        return;
    }
    
    self.searchIndex = index;
    self.searchValue = value;
    self.pageIndex = 1;
    
    self.tableView.hidden = YES;
    
    [IMLoadingView showLoading];
    
    switch (index)
    {
        case 0:
            [self searchMenu];
            break;
            
        case 1:
            [self searchShop];
            break;
            
        case 2:
            [self searchDynamic];
            break;
            
        case 3:
            [self searchUser];
            break;
            
        default:
            break;
    }
}

- (void)searchMenu
{
    NSDictionary *dic = @{@"filter_data":self.searchValue,
                          @"count":SEARCH_COUNT,
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex]};
    
    [self sendSearch:dic withRoute:@"search/search/searchMenu"];
}

- (void)searchShop
{
    NSDictionary *dic = @{@"filter_data":self.searchValue,
                          @"count":SEARCH_COUNT,
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex],
                          @"longitude_num":[UserData sharedUserData].longitude,
                          @"latitude_num":[UserData sharedUserData].latitude};
    
    [self sendSearch:dic withRoute:@"search/search/searchStore"];
}

- (void)searchDynamic
{
    NSDictionary *dic = @{@"filter_data":self.searchValue,
                          @"count":SEARCH_COUNT,
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex]};
    
    [self sendSearch:dic withRoute:@"search/search/searchDynamic"];
}

- (void)searchUser
{
    NSDictionary *dic = @{@"filter_data":self.searchValue,
                          @"count":SEARCH_COUNT,
                          @"member_id":[UserData sharedUserData].memberId,
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex]};
    
    [self sendSearch:dic withRoute:@"search/search/searchMember"];
}

- (void)sendSearch:(NSDictionary *)dic withRoute:(NSString *)route
{
    self.isNetworking = YES;
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:route withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isNetworking = NO;
            [IMLoadingView hideLoading];
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    NSArray *data = nil;
                    
                    switch (self.searchIndex)
                    {
                        case 0:
                            data = resultData[@"menu_list"];
                            break;
                            
                        case 1:
                            data = resultData[@"store_list"];
                            break;
                            
                        case 2:
                            data = resultData[@"dynamic_list"];
                            break;
                            
                        case 3:
                            data = resultData[@"member_list"];
                            break;
                            
                        default:
                            data = @[];
                            break;
                    }
                    
                    if (self.pageIndex == 1)
                    {
                        self.data = data;
                        if (self.data.count > 0)
                        {
                            [self.tableView reloadData];
                            self.tableView.hidden = NO;
                        }
                        else
                        {
                            IMErrorTips *tips = [IMErrorTips showTips:NSLocalizedString(@"search_view_error_tip1", nil) inView:self.view.superview.superview asError:YES];
                            [tips hideAfterDelay:2.0];
                        }
                    }
                    else
                    {
                        self.data = [self.data arrayByAddingObjectsFromArray:data];
                        [self.tableView reloadData];
                    }
                    
                    if ([data count] == 20)
                    {
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
                }
            }
            else
            {
            }
        });
    });
}

@end
