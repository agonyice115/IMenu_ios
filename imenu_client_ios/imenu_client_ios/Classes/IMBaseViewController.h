//
//  IMBaseViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-16.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "IMNavigationController.h"
#import "IMLoadingView.h"

@protocol IMTipsDelegate <NSObject>

- (void)showTips:(NSString *)tips;

@end

/**
 *  @brief iMenu导航视图控制器子视图控制器基类
 *
 *  所有需要显示在iMenu导航视图控制器的视图控制器都需要继承自此基类。
 */
@interface IMBaseViewController : UIViewController <IMTipsDelegate>

/**
 *  @brief 导航栏项被点击
 *
 *  @param navigationItemId 被点击的项ID
 *
 *  @return 是否处理了事件
 */
- (BOOL)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId;

/**
 *  @brief 获取所属的iMenu导航视图控制器
 *
 *  @return 所属的iMenu导航视图控制器
 */
- (IMNavigationController *)getIMNavigationController;

/**
 *  @brief 当前导航栏类型
 */
@property (nonatomic, assign) IM_NAVIGATION_BAR_TYPE navigationBarType;

/**
 *  @brief 初始导航栏类型
 */
@property (nonatomic, assign) IM_NAVIGATION_BAR_TYPE baseNavigationBarType;

/**
 *  @brief 所属导航按钮类型
 */
@property (nonatomic, assign) IM_NAVIGATION_ITEM_ID kindNavigationBarType;

/**
 *  @brief 导航栏标题
 */
@property (nonatomic, strong) NSString *navigationTitle;

/**
 *  @brief 是否创建了视图
 */
@property (nonatomic, assign) BOOL isCreateView;

@end
