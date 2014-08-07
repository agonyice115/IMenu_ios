//
//  LoginAndRegisterNavigationBar.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-3.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 登录注册导航栏
 *
 *  登录和注册页面导航栏形式统一，共用一个导航栏。
 */
@interface LoginAndRegisterNavigationBar : UIView

/**
 *  @brief 切换标题，具有动画效果
 *
 *  @param title 新标题文字
 */
- (void)switchTitle:(NSString *)title;

/**
 *  @brief 内容视图
 */
@property (nonatomic, strong) UIView *contentView;

/**
 *  @brief 导航栏标题
 */
@property (nonatomic, strong) UILabel *title;

/**
 *  @brief 导航栏关闭按钮
 */
@property (nonatomic, strong) UIButton *closeButton;

@end
