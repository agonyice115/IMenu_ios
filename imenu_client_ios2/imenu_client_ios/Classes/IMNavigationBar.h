//
//  IMNavigationBar.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-11-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@class IMNavigationController;

/**
 *  @brief iMenu导航栏
 *
 *  为滑动式层级定制的导航栏
 */
@interface IMNavigationBar : UIView

/**
 *  @brief 设置导航栏类型
 *
 *  新的导航栏类型将替换掉旧的
 *
 *  @param type     要设置的导航栏类型
 *  @param animated 是否使用动画
 *  @param top      动画是否是自顶向下
 */
- (void)setNavigationBarType:(IM_NAVIGATION_BAR_TYPE)type animated:(BOOL)animated fromTop:(BOOL)top;

/**
 *  @brief 设置中部标题
 *
 *  @param title 标题
 */
- (void)setMiddleTitle:(NSString *)title;

/**
 *  @brief 所属的iMenu导航控制器
 */
@property (nonatomic, strong) IMNavigationController *imNavigationController;

@end
