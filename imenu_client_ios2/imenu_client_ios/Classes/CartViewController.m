//
//  CartViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "CartViewController.h"
#import "NoteView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "ShopTopBar.h"
#import "CartCell.h"
#import "CartData.h"
#import "LoginButton.h"
#import "IMPopViewController.h"
#import "NewDynamicViewController.h"
#import "Networking.h"
#import "UserData.h"
#import "ShopDetailsViewController.h"
#import "IMNavigationController.h"
#import "IMErrorTips.h"
#import "ShopMenuViewController.h"
#import "IMLoadingView.h"
#import "OrderPayViewController.h"
#import "ShopPaySuccessViewController.h"

@interface CartViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) ShopTopBar *shopBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *cartPeople;
@property (nonatomic, strong) UILabel *cartCount;
@property (nonatomic, strong) UILabel *cartTotalPrice;
@property (nonatomic, strong) UILabel *cartAveragePrice;
@property (nonatomic, strong) UILabel *oldPrice;

@property (nonatomic, assign) NSUInteger oldCartCount;

@end

@implementation CartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CartDataChanged:) name:CART_DATA_CHANGED object:nil];
        
        float height = TOP_BAR_HEIGHT;
        
        self.shopBar = [[ShopTopBar alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.shopBar.storeData = [CartData sharedCartData].storeData;
        [self.shopBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goShopDetail)]];
        [self.view addSubview:self.shopBar];
        
        height += MIDDLE_BAR_HEIGHT;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, 320, self.view.bounds.size.height-height-BOTTOM_BAR_HEIGHT)];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.tableView];
        [self.view sendSubviewToBack:self.tableView];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
        headerView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = headerView;
        
        float y = 0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 40, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"人均：";
        [headerView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(100, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = @"￥32.99/人";
        [headerView addSubview:label];
        self.cartAveragePrice = label;
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 40, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"人数：";
        [headerView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(125, y, 40, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = @"3人";
        [headerView addSubview:label];
        self.cartPeople = label;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(90, y-7, 43, 43);
        [button setImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"minus_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickMinus) forControlEvents:UIControlEventTouchUpInside];
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [headerView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(190-33, y-7, 43, 43);
        [button setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"plus_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickPlus) forControlEvents:UIControlEventTouchUpInside];
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [headerView addSubview:button];
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 40, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"单品：";
        [headerView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(100, y, 70, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = @"3种";
        [headerView addSubview:label];
        self.cartCount = label;
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 40, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"合计：";
        [headerView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(100, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = @"￥300.00";
        [headerView addSubview:label];
        self.cartTotalPrice = label;
        
        self.oldPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, y+8, 50, 14)];
        self.oldPrice.backgroundColor = [UIColor clearColor];
        self.oldPrice.font = [UIFont systemFontOfSize:12.0];
        self.oldPrice.textAlignment = NSTextAlignmentLeft;
        self.oldPrice.textColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
        self.oldPrice.clipsToBounds = YES;
        [headerView addSubview:self.oldPrice];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 50, 1)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
        [self.oldPrice addSubview:line];
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(100, y, 10, 10)];
        label.backgroundColor = [UIColor redColor];
        label.text = @"菜品八折";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [label sizeToFit];
        [headerView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 10, 10)];
        label.backgroundColor = [UIColor redColor];
        label.text = @"满200减10";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [label sizeToFit];
        [headerView addSubview:label];
        
        self.oldCartCount = [CartData sharedCartData].menuCount;
        [self loadData];
        
        y += 15;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, 25)];
        bgView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:bgView];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 24, 320, 0.5f)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#888888"];
        [bgView addSubview:line];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(320-PAGE_MARGIN-70, 0, 70, 25)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"菜品";
        [bgView addSubview:label];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-BOTTOM_BAR_HEIGHT, 320, BOTTOM_BAR_HEIGHT)];
        bottomView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:bottomView];
        
        // 添加加菜按钮
        LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, 0, self.view.bounds.size.width/3-1, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"cart_view_button1", nil) forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"complete_normal"] forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"complete_highlight"] forState:UIControlStateHighlighted];
        [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 5)];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [loginButton addTarget:self action:@selector(onClickAddMenu) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:loginButton];
        
        // 添加确认按钮
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, BOTTOM_BAR_HEIGHT);
        button.backgroundColor = [UIColor colorWithHtmlColor:@"#008fff"];
        button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        [button setTitle:@"支付" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"select_highlight"] forState:UIControlStateHighlighted];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 5)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button addTarget:self action:@selector(onClickOK) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
        // 添加清空按钮
        loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(self.view.bounds.size.width/3*2+1, 0, self.view.bounds.size.width/3-1, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"cart_view_button3", nil) forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"close_highlight"] forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"close_normal"] forState:UIControlStateHighlighted];
        [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 5)];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [loginButton addTarget:self action:@selector(onClickClean) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:loginButton];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[CartData sharedCartData] saveData];
}

- (void)CartDataChanged:(NSNotification *)notification
{
    [self loadData];
}

- (void)CartDataSaved:(NSNotification *)notification
{
    [self addOrder];
}

- (void)CartDataSavedError:(NSNotification *)notification
{
    [IMLoadingView hideLoading];
    IMErrorTips *tips = [IMErrorTips showTips:NSLocalizedString(@"networking_error", nil) inView:self.view asError:YES];
    [tips hideAfterDelay:2.0];
}

- (void)loadData
{
    if ([CartData sharedCartData].menuCount == 0)
    {
        IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
        [pVC backToMainView];
        return;
    }
    
    if ([CartData sharedCartData].menuCount != self.oldCartCount)
    {
        self.oldCartCount = [CartData sharedCartData].menuCount;
        [self.tableView reloadData];
    }
    
    self.cartPeople.text = [NSString stringWithFormat:@"%d人", [CartData sharedCartData].peopleCount];
    self.cartCount.text = [NSString stringWithFormat:@"%d种", [CartData sharedCartData].menuCount];
    
    
    if ([CartData sharedCartData].couponPrice != [CartData sharedCartData].totalPrice)
    {
        self.cartTotalPrice.text = [NSString stringWithFormat:@"￥%.2f", [CartData sharedCartData].totalPrice];
        
        self.oldPrice.hidden = NO;
        CGRect frame = self.oldPrice.frame;
        frame.size = CGSizeMake(50, 14);
        self.oldPrice.frame = frame;
        self.oldPrice.text = [NSString stringWithFormat:@"￥%.2f", [CartData sharedCartData].couponPrice];
        [self.oldPrice sizeToFit];
    }
    else
    {
        self.oldPrice.hidden = YES;
        
        self.cartTotalPrice.text = [NSString stringWithFormat:@"￥%.2f", [CartData sharedCartData].totalPrice];
    }
    
    if ([CartData sharedCartData].peopleCount == 0)
    {
        self.cartAveragePrice.text = @"￥0.00/人";
    }
    else
    {
        self.cartAveragePrice.text = [NSString stringWithFormat:@"￥%.2f/人", [CartData sharedCartData].totalPrice/[CartData sharedCartData].peopleCount];
    }
}

- (void)onClickPlus
{
    [CartData sharedCartData].peopleCount += 1;
}

- (void)onClickMinus
{
    if ([CartData sharedCartData].peopleCount > 0)
    {
        [CartData sharedCartData].peopleCount -= 1;
    }
}

- (void)onClickAddMenu
{
    UIViewController *viewController = self.parentViewController.presentingViewController;
    
    if ([viewController isKindOfClass:[IMNavigationController class]])
    {
        IMNavigationController *baseVC = (IMNavigationController *)viewController;
        [self.parentViewController dismissViewControllerAnimated:YES completion:^{
            ShopMenuViewController *vc = [[ShopMenuViewController alloc] initWithNibName:nil bundle:nil];
            vc.storeData = [CartData sharedCartData].storeData;
            [baseVC pushViewController:vc animated:YES];
        }];
    }
}

- (void)onClickOK
{
    if ([CartData sharedCartData].peopleCount < 1)
    {
        IMErrorTips *tips = [IMErrorTips showTips:NSLocalizedString(@"cart_view_error_tip1", nil) inView:self.view asError:YES];
        [tips hideAfterDelay:2.0];
        return;
    }
    
    [IMLoadingView showLoading];
    
    if ([CartData sharedCartData].dataChanged)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CartDataSaved:) name:CART_DATA_SAVED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CartDataSavedError:) name:CART_DATA_SAVED_ERROR object:nil];
        [[CartData sharedCartData] saveData];
        return;
    }
    
    [self addOrder];
}

- (void)addOrder
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"member_id"] = [UserData sharedUserData].memberId;
    dic[@"mobile"] = [UserData sharedUserData].mobile;
    dic[@"email"] = [UserData sharedUserData].email;
    dic[@"coupon_id"] = @"0";
    dic[@"people"] = [NSString stringWithFormat:@"%d", [CartData sharedCartData].peopleCount];
    dic[@"total"] = [NSString stringWithFormat:@"%.2f", [CartData sharedCartData].totalPrice];
    dic[@"create_date"] = [CartData sharedCartData].createDate;
    dic[@"modify_date"] = [CartData sharedCartData].modifyDate;
    dic[@"store_id"] = [CartData sharedCartData].storeId;
    NSMutableArray *menuList = [NSMutableArray array];
    for (NSDictionary *menu in [CartData sharedCartData].cartList)
    {
        NSString *menuCount = menu[@"menu_count"];
        if (menuCount.intValue > 0)
        {
            [menuList addObject:@{@"menu_id":menu[@"menu_id"],
                                  @"menu_count":menu[@"menu_count"]}];
        }
    }
    dic[@"menu_list"] = menuList;
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"order/order/addOrder" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [IMLoadingView hideLoading];
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    NSDictionary *orderInfo = resultData[@"order_info"];
                    NSDictionary *storeInfo = orderInfo[@"store_info"];
                    NSString *signType = storeInfo[@"signing_type"];
                    
                    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
                    
                    if (signType.intValue == 0)
                    {
                        NewDynamicViewController *viewController = [[NewDynamicViewController alloc] initWithNibName:nil bundle:nil];
                        viewController.isHidePhoto = YES;
                        viewController.dynamicId = resultData[@"dynamic_id"];
                        viewController.orderId = orderInfo[@"order_id"];
                        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"dynimic_view_title", nil) animated:YES];
                        
                        [pVC showInfoButtonWithTarget:viewController action:@selector(showOrder)];
                    }
                    else if (signType.intValue == 1)
                    {
                        OrderPayViewController *viewController = [[OrderPayViewController alloc] initWithNibName:nil bundle:nil];
                        viewController.data = resultData;
                        [pVC setRootViewController:viewController withTitle:@"在线支付" animated:YES];
                    }
                    else
                    {
                        ShopPaySuccessViewController *viewController = [[ShopPaySuccessViewController alloc] initWithNibName:nil bundle:nil];
                        viewController.data = resultData;
                        [pVC setRootViewController:viewController withTitle:@"订单提交结果" animated:YES];
                    }
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:self];
                    [[CartData sharedCartData] cleanData];
                }
                else
                {
                    IMErrorTips *tips = [IMErrorTips showTips:[errorString substringFromIndex:3] inView:self.view asError:YES];
                    [tips hideAfterDelay:2.0];
                }
            }
        });
    });
}

- (void)onClickClean
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定要清空购物车吗？"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"tip_button_ok", nil)
                                              otherButtonTitles:nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        return;
    }
    
    [[CartData sharedCartData] cleanData];
    
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    [pVC backToMainView];
}

- (void)goShopDetail
{
    UIViewController *viewController = self.presentingViewController;
    
    if ([viewController isKindOfClass:[IMNavigationController class]])
    {
        IMNavigationController *baseVC = (IMNavigationController *)viewController;
        [self dismissViewControllerAnimated:YES completion:^{
            ShopDetailsViewController *vc = [[ShopDetailsViewController alloc] initWithNibName:nil bundle:nil];
            [vc setStoreId:[CartData sharedCartData].storeData[@"store_id"] andStoreName:[CartData sharedCartData].storeData[@"store_name"]];
            [baseVC pushViewController:vc animated:YES];
        }];
    }
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
    return [[CartData sharedCartData].cartList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell"];
    if (cell == nil)
    {
        cell = [[CartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CartCell"];
    }
    cell.data = [CartData sharedCartData].cartList[indexPath.row];
    return cell;
}

@end
