//
//  ShopMenuViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-27.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopMenuViewController.h"
#import "ShopMenuCell.h"
#import "MenuDetailViewController.h"
#import "Networking.h"
#import "MenuFilterViewController.h"
#import "CartBar.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "FirstShowHelpView.h"
#import "ShopMenuSearchViewController.h"
#import "IMPopViewController.h"

@interface ShopMenuViewController () <UITableViewDataSource, UITableViewDelegate, FilterSelectViewDelegate>

@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, strong) MenuFilterViewController *menuFilter;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) CartBar *cartBar;

@end

@implementation ShopMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = @"麦当劳";
        self.menuList = [NSArray array];
        self.data = [NSMutableArray array];
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SEARCH;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_SHOP;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [IMLoadingView showLoading];
}

- (BOOL)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId
{
    if ([super onNavigationItemClicked:navigationItemId])
    {
        return YES;
    }
    
    switch (navigationItemId)
    {
        case IM_NAVIGATION_ITEM_SEARCH_MENU:
        {
            IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
            viewController.bottomAnimation = NO;
            
            ShopMenuSearchViewController *vc = [[ShopMenuSearchViewController alloc] initWithNibName:nil bundle:nil];
            vc.storeData = self.storeData;
            vc.data = self.data;
            [viewController setRootViewController:vc withTitle:@"菜单搜索" animated:NO];
            
            [[self getIMNavigationController] presentViewController:viewController animated:YES completion:nil];
        }
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
}

- (void)createView
{
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(120, 0, 200, self.view.bounds.size.height)];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
    {
        self.menuTableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    self.menuTableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 50, 0);
    [self.view addSubview:self.menuTableView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 40)];
    imageView.center = CGPointMake(100, -30);
    imageView.image = [UIImage imageNamed:@"logo.png"];
    [self.menuTableView addSubview:imageView];
    
    self.menuFilter = [[MenuFilterViewController alloc] initWithNibName:nil bundle:nil];
    self.menuFilter.delegate = self;
    
    [self addChildViewController:self.menuFilter];
    self.menuFilter.view.frame = CGRectMake(0, TOP_BAR_HEIGHT, 120, self.view.bounds.size.height-TOP_BAR_HEIGHT);
    [self.view addSubview:self.menuFilter.view];
    self.menuFilter.storeData = self.storeData;
    [self.menuFilter didMoveToParentViewController:self];
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(120, TOP_BAR_HEIGHT, 0.5, self.view.bounds.size.height-TOP_BAR_HEIGHT)];
    sepView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:sepView];
    
    self.cartBar = [[CartBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, BOTTOM_BAR_HEIGHT)];
    self.cartBar.presentedViewController = self;
    [self.view addSubview:self.cartBar];
    
    self.cartBar.storeId = self.storeData[@"store_id"];
    [self.cartBar refreshCartBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStoreData:(NSDictionary *)storeData
{
    _storeData = storeData;
    
    self.navigationTitle = storeData[@"store_name"];
    
    NSDictionary *dic = @{@"store_id":storeData[@"store_id"]};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"store/menu/getMenuListAndCategoryList"
                                          withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    [FirstShowHelpView loadHelpView:HELP_MENU];
                    
                    [self createView];
                    NSString *successString = result[@"success"];
                    [self showTips:successString];
                    
                    NSDictionary *resultData = [result[@"data"] lastObject];
                    [self parseMenuData:resultData];
                    [self.menuFilter setFilterData:self.data];
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

- (void)parseMenuData:(NSDictionary *)data
{
    NSMutableDictionary *menuData = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in data[@"menu_list"])
    {
        menuData[dic[@"menu_id"]] = dic;
    }
    
    NSMutableArray *filterData = [data[@"menu_category_list"] mutableCopy];
    [filterData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *sort1 = obj1[@"sort_order"];
        NSString *sort2 = obj2[@"sort_order"];
        if (sort1.intValue < sort2.intValue)
        {
            return NSOrderedAscending;
        }
        else if (sort1.intValue > sort2.intValue)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
    
    self.data = [NSMutableArray array];
    NSMutableArray *leftMenu = [NSMutableArray arrayWithArray:data[@"menu_list"]];
    
    if (filterData.count > 0)
    {
        for (NSDictionary *filter in filterData)
        {
            NSString *ids = filter[@"menu_ids"];
            if (!ids || ids.length == 0)
            {
                continue;
            }
            
            NSArray *arr = [ids componentsSeparatedByString:@"|"];
            NSMutableArray *menuList = [NSMutableArray array];
            for (NSString *menuId in arr)
            {
                [menuList addObject:menuData[menuId]];
                [leftMenu removeObject:menuData[menuId]];
            }
            
            [menuList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString *sort1 = obj1[@"sort_order"];
                NSString *sort2 = obj2[@"sort_order"];
                if (sort1.intValue < sort2.intValue)
                {
                    return NSOrderedAscending;
                }
                else if (sort1.intValue > sort2.intValue)
                {
                    return NSOrderedDescending;
                }
                else
                {
                    return NSOrderedSame;
                }
            }];
            
            NSMutableDictionary *mutFilter = [filter mutableCopy];
            mutFilter[@"data"] = menuList;
            
            [self.data addObject:mutFilter];
        }
        
        if (leftMenu.count > 0)
        {
            NSMutableDictionary *mutFilter = [NSMutableDictionary dictionary];
            mutFilter[@"menu_category_name"] = @"未分类";
            mutFilter[@"menu_category_id"] = @"-1";
            mutFilter[@"menu_category_image_location"] = @"";
            mutFilter[@"menu_category_image_name"] = @"";
            mutFilter[@"sort_order"] = @"9999";
            mutFilter[@"parent_id"] = @"0";
            mutFilter[@"menu_ids"] = @"";
            mutFilter[@"data"] = leftMenu;
            
            [self.data addObject:mutFilter];
        }
    }
    else
    {
        NSMutableDictionary *mutFilter = [NSMutableDictionary dictionary];
        mutFilter[@"menu_category_name"] = @"全部";
        mutFilter[@"menu_category_id"] = @"0";
        mutFilter[@"menu_category_image_location"] = @"";
        mutFilter[@"menu_category_image_name"] = @"";
        mutFilter[@"sort_order"] = @"9999";
        mutFilter[@"parent_id"] = @"0";
        mutFilter[@"menu_ids"] = @"";
        mutFilter[@"data"] = data[@"menu_list"];
        
        [self.data addObject:mutFilter];
    }
}

#pragma mark - UITableView 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menuList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *filter = self.menuList[section];
    NSArray *data = filter[@"data"];
    return [data count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *filter = self.menuList[section];
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithHtmlColor:@"#e4e6eb"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 20)];
    titleLabel.textColor=[UIColor colorWithHtmlColor:@"#5a5a5a"];
    titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = filter[@"menu_category_name"];
    
    [myView addSubview:titleLabel];
    return myView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopMenuCell"];
    if (cell == nil)
    {
        cell = [[ShopMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopMenuCell"];
    }
    cell.storeData = self.storeData;
    NSDictionary *filter = self.menuList[indexPath.section];
    NSArray *data = filter[@"data"];
    [cell setData:data[indexPath.row] showImage:[Networking sharedNetworking].isWiFi];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuDetailViewController *vc = [[MenuDetailViewController alloc] initWithNibName:nil bundle:nil];
    NSDictionary *filter = self.menuList[indexPath.section];
    NSArray *data = filter[@"data"];
    NSDictionary *menu = data[indexPath.row];
    [vc setMenuId:menu[@"menu_id"]];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

#pragma mark - FilterSelectView 代理方法

- (void)onSelectId:(NSString *)Id withData:(NSDictionary *)data by:(FilterSelectViewController *)filter
{
    if ([Id isEqualToString:@"0"])
    {
        self.menuList = self.data;
    }
    else
    {
        for (NSDictionary *filter in self.data)
        {
            if ([Id isEqualToString:filter[@"menu_category_id"]])
            {
                self.menuList = @[filter];
                break;
            }
        }
    }
    
    [self.menuTableView setContentOffset:CGPointMake(0, -TOP_BAR_HEIGHT) animated:NO];
    [self.menuTableView reloadData];
}

@end
