//
//  IMNavigationController.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-11-27.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMNavigationBar.h"

#pragma mark - IMNavigationController

@class IMBaseViewController;

/**
 *  @brief iMenu导航控件
 *
 *  控件功能与系统导航控件类似，区别在于NavigationBar与子视图层级控制逻辑不同。
 */
@interface IMNavigationController : UIViewController

/**
 *  @brief 设置根视图
 *
 *  该方法在初始化完成后，应当立即被调用，以设置需要显示的根视图。
 *  另外，重设根视图时，此操作将移除所有子视图。
 *
 *  @param viewController 要设置的根视图
 */
- (void)setRootViewController:(IMBaseViewController *)viewController;

/**
 *  @brief 添加一个视图控件
 *
 *  在当前视图处推入一个视图，如果当前视图不是最顶层，上面的原有视图将被移除。
 *  调用该方法必须确保已经设置了根视图，否则什么也不做。
 *
 *  @param viewController 添加的视图控制器
 *  @param animated       是否使用动画
 */
- (void)pushViewController:(IMBaseViewController *)viewController animated:(BOOL)animated;

/**
 *  @brief 移动到下一视图
 *
 *  如果当前视图已经处于最顶层，那么什么也不做。
 *
 *  @param animated 是否使用动画
 */
- (void)moveToNextViewControllerAnimated:(BOOL)animated;

/**
 *  @brief 移动到上一视图
 *
 *  如果当前视图已经处于最底层，那么什么也不做。
 *
 *  @param animated 是否使用动画
 */
- (void)moveToPreViewControllerAnimated:(BOOL)animated;

/**
 *  @brief 导航栏项被点击
 *
 *  @param navigationItemId 被点击的项ID
 */
- (void)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId;

/**
 *  @brief 获取当前视图标题
 *
 *  @return 返回标题字符串
 */
- (NSString *)getCurrentViewTitle;

/**
 *  @brief 获取当前视图分类ID
 *
 *  @return 分类ID
 */
- (IM_NAVIGATION_ITEM_ID)getCurrentViewKindId;

/**
 *  @brief 导航栏视图
 */
@property (nonatomic, strong) IMNavigationBar *navigationBarView;

@end

