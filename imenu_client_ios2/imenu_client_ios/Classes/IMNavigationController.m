//
//  IMNavigationController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-11-27.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMNavigationController.h"
#import "IMConfig.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "IMPopViewController.h"
#import "LoginViewController.h"
#import "RegisterPhoneViewController.h"
#import "IMTipView.h"
#import "IMBaseViewController.h"
#import "ShopViewController.h"
#import "MineViewController.h"
#import "SearchViewController.h"
#import "DynamicViewController.h"
#import "UserData.h"

#pragma mark - IMNavigationController

@interface IMNavigationController () <UIScrollViewDelegate, UIActionSheetDelegate>

/**
 *  根视图
 */
@property (nonatomic, strong) IMBaseViewController *rootViewController;

/**
 *  子视图控件
 */
@property (nonatomic, strong) NSMutableArray *viewControllers;

/**
 *  滚动视图，用于展示子视图，实现左右滑动层级变化关系
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  子视图是否显示在导航栏下方，默认显示在下方（IOS7风格）
 */
@property (nonatomic, assign) BOOL underNavigationBar;

/**
 *  当前显示视图索引
 */
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation IMNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        
        self.underNavigationBar = YES;
        
        self.viewControllers = [NSMutableArray array];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
        
        self.navigationBarView = [[IMNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, TOP_BAR_HEIGHT)];
        self.navigationBarView.imNavigationController = self;
        [self.view addSubview:self.navigationBarView];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOK:) name:@"userLoginOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNeedLogin) name:@"userNeedLogin" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)userLoginOK:(NSNotification *)notification
{
    // 当用户登录后，刷新导航栏
    for (IMBaseViewController *vc in self.viewControllers)
    {
        vc.navigationBarType = vc.baseNavigationBarType;
    }
    
    IMBaseViewController *currentViewController = self.viewControllers[self.currentIndex];
    [self.navigationBarView setNavigationBarType:currentViewController.navigationBarType animated:NO fromTop:NO];
}

- (void)removeSubViewControllersFromIndex:(NSUInteger)index
{
    NSUInteger count = [self.viewControllers count];
    
    for (NSUInteger i = index; i < count; ++i)
    {
        UIViewController *viewController = self.viewControllers[i];
        
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
    
    [self.viewControllers removeObjectsInRange:NSMakeRange(index, count-index)];
}

- (void)setRootViewController:(IMBaseViewController *)viewController
{
    // 首先移除原有视图
    [self removeSubViewControllersFromIndex:0];
    
    _rootViewController = viewController;
    [self.viewControllers addObject:viewController];
    
    // 添加新的视图
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.bounds;
    [self.scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    // 修改滚动视图以显示根视图
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.scrollView.contentOffset = CGPointZero;
    self.currentIndex = 0;
    
    [self.navigationBarView setNavigationBarType:viewController.navigationBarType animated:YES fromTop:NO];
}

- (void)pushViewController:(IMBaseViewController *)viewController animated:(BOOL)animated
{
    // 添加视图时，必须有根视图
    if (self.rootViewController == nil)
    {
        return;
    }
    
    // 推入视图时禁用触摸，防止双击导致两次推入
    self.scrollView.userInteractionEnabled = NO;
    
    if (![UserData sharedUserData].isLogin)
    {
        viewController.navigationBarType = IM_NAVIGATION_BAR_TYPE_UNLOGIN_SECONDARY;
    }
    viewController.kindNavigationBarType = self.rootViewController.kindNavigationBarType;
    
    NSUInteger nextIndex = self.currentIndex+1;
    // 首先移除当前视图的后继视图
    [self removeSubViewControllersFromIndex:nextIndex];
    
    // 添加新的视图
    [self.viewControllers addObject:viewController];
    [self addChildViewController:viewController];
    
    CGRect frame = self.view.bounds;
    frame.origin.x = nextIndex * frame.size.width;
    viewController.view.frame = frame;
    
    [self.scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    self.scrollView.contentSize = CGSizeMake(frame.origin.x + frame.size.width, frame.size.height);
    
    // 显示新加入的视图
    [self moveToNextViewControllerAnimated:animated];
}

- (void)moveToNextViewControllerAnimated:(BOOL)animated
{
    NSUInteger nextIndex = self.currentIndex+1;
    if (nextIndex < [self.viewControllers count])
    {
        IMBaseViewController *nextViewController = self.viewControllers[nextIndex];
        CGRect frame = nextViewController.view.frame;
        [self.scrollView scrollRectToVisible:frame animated:animated];
        self.currentIndex = nextIndex;
        
        [self.navigationBarView setNavigationBarType:nextViewController.navigationBarType animated:YES fromTop:NO];
    }
}

- (void)moveToPreViewControllerAnimated:(BOOL)animated
{
    if (self.currentIndex == 0)
    {
        return;
    }
    NSUInteger preIndex = self.currentIndex-1;
    IMBaseViewController *nextViewController = self.viewControllers[preIndex];
    CGRect frame = nextViewController.view.frame;
    [self.scrollView scrollRectToVisible:frame animated:animated];
    self.currentIndex = preIndex;
    
    [self.navigationBarView setNavigationBarType:nextViewController.navigationBarType animated:YES fromTop:YES];
}

#pragma mark - UIScrollView 代理方法

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = (NSUInteger)(scrollView.contentOffset.x/320);
    if (index == self.currentIndex)
    {
        return;
    }
    
    BOOL isFromTop = index < self.currentIndex;
    self.currentIndex = index;
    IMBaseViewController *nextViewController = self.viewControllers[index];
    [self.navigationBarView setNavigationBarType:nextViewController.navigationBarType animated:YES fromTop:isFromTop];
}

#pragma mark - 处理NavigationItem点击事件

- (NSString *)getCurrentViewTitle
{
    IMBaseViewController *currentViewController = self.viewControllers[self.currentIndex];
    return currentViewController.navigationTitle;
}

- (IM_NAVIGATION_ITEM_ID)getCurrentViewKindId
{
    IMBaseViewController *currentViewController = self.viewControllers[self.currentIndex];
    return currentViewController.kindNavigationBarType;
}

- (void)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId
{
    IMBaseViewController *currentViewController = self.viewControllers[self.currentIndex];
    
    // 如果要切换的是当前视图所属分类，等同于关闭
    if (currentViewController.kindNavigationBarType == navigationItemId)
    {
        navigationItemId = IM_NAVIGATION_ITEM_CLOSE;
    }
    
    // 首先交由当前视图处理
    if ([currentViewController onNavigationItemClicked:navigationItemId])
    {
        return;
    }
    
    // 自行处理其他情况
    switch (navigationItemId)
    {
        case IM_NAVIGATION_ITEM_LOGIN:
            [self clickLoginButton];
            break;
            
        case IM_NAVIGATION_ITEM_REGISTER:
            [self clickRegisterButton];
            break;
            
        case IM_NAVIGATION_ITEM_BACK:
            [self moveToPreViewControllerAnimated:YES];
            break;
            
        case IM_NAVIGATION_ITEM_SWITCH_SHOP:
        {
            ShopViewController *vc = [[ShopViewController alloc] initWithNibName:nil bundle:nil];
            [self setRootViewController:vc];
            [IMLoadingView hideLoading];
        }
            break;
            
        case IM_NAVIGATION_ITEM_SWITCH_MINE:
        {
            MineViewController *vc = [[MineViewController alloc] initWithNibName:nil bundle:nil];
            [self setRootViewController:vc];
            [IMLoadingView hideLoading];
        }
            break;
            
        case IM_NAVIGATION_ITEM_SWITCH_DYNIMIC:
        {
            [self.navigationBarView setMiddleTitle:@"朋友动态"];
            DynamicViewController *vc = [[DynamicViewController alloc] initWithNibName:nil bundle:nil];
            [vc setViewMemberId:@""];
            [self setRootViewController:vc];
            [IMLoadingView hideLoading];
        }
            break;
            
        case IM_NAVIGATION_ITEM_SWITCH_SERCH:
        {
            SearchViewController *vc = [[SearchViewController alloc] initWithNibName:nil bundle:nil];
            [self setRootViewController:vc];
            [IMLoadingView hideLoading];
        }
            break;
            
        case IM_NAVIGATION_ITEM_NONE:
            break;
            
        case IM_NAVIGATION_ITEM_TITLE:
            break;
            
        default:
            NSAssert(NO, @"未处理的点击事件：%d", navigationItemId);
            break;
    }
}

- (void)clickLoginButton
{
    IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
    viewController.bottomAnimation = YES;
    
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    login.isPhoneLogin = YES;
    [viewController setRootViewController:login withTitle:NSLocalizedString(@"login_title_phone", nil) animated:NO];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)clickRegisterButton
{
    IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
    viewController.bottomAnimation = YES;
    
    RegisterPhoneViewController *reg = [[RegisterPhoneViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setRootViewController:reg withTitle:NSLocalizedString(@"register_title1", nil) animated:NO];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)userNeedLogin
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"tip_button_login_title", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"tip_button_login", nil)
                                              otherButtonTitles:NSLocalizedString(@"tip_button_register", nil), nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 2)
    {
        if (self.presentedViewController)
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
    if (buttonIndex == 0)
    {
        [self clickLoginButton];
    }
    else if (buttonIndex == 1)
    {
        [self clickRegisterButton];
    }
}

@end

