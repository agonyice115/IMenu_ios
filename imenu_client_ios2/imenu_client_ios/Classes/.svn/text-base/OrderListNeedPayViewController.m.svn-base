//
//  OrderListNeedPayViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-30.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "OrderListNeedPayViewController.h"
#import "Common.h"
#import "ShopTopBar.h"
#import "NoteView.h"
#import "UIColor+HtmlColor.h"
#import "IMSegmentedControl.h"
#import "DynamicSectionView.h"
#import "IMPopViewController.h"
#import "NewOrderViewController.h"
#import "UserData.h"
#import "Networking.h"
#import "OrderNeedPayCell.h"

#define TOP_HEADER_VIEW_HEIGHT 60.0f

@interface OrderListNeedPayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ShopTopBar *shopBar;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger filterIndex;
@property (nonatomic, strong) NSArray *filterList;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL isNetworking;

@end

@implementation OrderListNeedPayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = @"待付款订单";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
        
        _filterList = @[];
        self.data = @[];
        self.filterIndex = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [IMLoadingView showLoading];
//    self.pageIndex = 1;
//    [self loadData];
    
    [self createView];
}

- (void)createView
{
    if (self.isCreateView)
    {
        return;
    }
    
    self.isCreateView = YES;
    
    [self createHeaderView];
    
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
    self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createHeaderView
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, 320, TOP_HEADER_VIEW_HEIGHT)];
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headerView];
    
    float height = 0;
    
    self.shopBar = [[ShopTopBar alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    self.shopBar.hideRightMore = YES;
    [self.headerView addSubview:self.shopBar];
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
    
    return 70.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
//    int count = 1;
//    for (NSDictionary *dic in self.filterList)
//    {
//        NSNumber *startIndex = dic[@"start_index"];
//        if (startIndex.intValue >= self.data.count)
//        {
//            break;
//        }
//        
//        count += 1;
//    }
//    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    
    return 10;
//    --section;
//    NSDictionary *dic = self.filterList[section];
//    NSString *value = dic[@"value"];
//    NSNumber *startIndex = dic[@"start_index"];
//    int count = self.data.count - startIndex.intValue;
//    if (value.intValue < count)
//    {
//        return value.integerValue;
//    }
//    return count;
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
    
    OrderNeedPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderNeedPayCell"];
    if (cell == nil)
    {
        cell = [[OrderNeedPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderNeedPayCell"];
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
    
//    NSDictionary *dic = self.filterList[section-1];
//    
//    NSString *title = dic[@"key"];
//    switch (self.filterIndex)
//    {
//        case 0:
//        {
//            title = [title stringByAppendingString:@"年"];
//        }
//            break;
//            
//        case 1:
//        {
//            title = [NSString stringWithFormat:@"%@年%@月", [title substringToIndex:4], [title substringFromIndex:4]];
//        }
//            break;
//            
//        default:
//        {
//            title = [NSString stringWithFormat:@"%@年第%@周", [title substringToIndex:4], [title substringFromIndex:4]];
//        }
//            break;
//    }
    
    DynamicSectionView *view = [[DynamicSectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    //[view.sectionTitle setTitle:title forState:UIControlStateDisabled];
    //view.sectionCount.text = [NSString stringWithFormat:@"共%@单", dic[@"value"]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//        return;
//    }
//    
//    NSDictionary *filter = self.filterList[indexPath.section-1];
//    NSNumber *startIndex = filter[@"start_index"];
//    NSDictionary *dic = self.data[startIndex.intValue + indexPath.row];
//    
//    IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
//    viewController.bottomAnimation = NO;
//    
//    NewOrderViewController *vc = [[NewOrderViewController alloc] initWithNibName:nil bundle:nil];
//    vc.orderId = dic[@"order_id"];
//    [viewController setRootViewController:vc withTitle:NSLocalizedString(@"order_view_title", nil) animated:NO];
//    
//    [[self getIMNavigationController] presentViewController:viewController animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y+TOP_BAR_HEIGHT;
    
    {
        CGRect frame = self.headerView.frame;
        frame.origin.y = TOP_BAR_HEIGHT-y;
        self.headerView.frame = frame;
    }
    
//    if (y < TOP_HEADER_VIEW_HEIGHT)
//    {
//        CGRect frame = self.segmentView.frame;
//        frame.origin.y = TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT-y;
//        self.segmentView.frame = frame;
//    }
//    else
//    {
//        CGRect frame = self.segmentView.frame;
//        frame.origin.y = TOP_BAR_HEIGHT;
//        self.segmentView.frame = frame;
//    }
//    
//    if (self.tableView.tableFooterView && scrollView.contentOffset.y > scrollView.contentSize.height - 800)
//    {
//        [self loadMoreData];
//    }
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
                          @"filter_date_type":[NSString stringWithFormat:@"%d", self.filterIndex+1],
                          @"order_count":@"20",
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex]};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"order/order/getOrderList" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createView];
            self.isNetworking = NO;
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = [result[@"data"] lastObject];
                    
                    if (self.pageIndex == 1)
                    {
                        [self setViewMemberData:resultData[@"member_info"]];
                        self.filterList = resultData[@"filter_date_list"];
                        
                        [self.tableView setContentOffset:CGPointMake(0, -(TOP_BAR_HEIGHT+50)) animated:NO];
                        self.data = resultData[@"order_list"];
                    }
                    else
                    {
                        self.data = [self.data arrayByAddingObjectsFromArray:resultData[@"order_list"]];
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
            
            [IMLoadingView hideLoading];
        });
    });
}

- (void)setViewMemberData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    self.shopBar.userData = data;
}

@end
