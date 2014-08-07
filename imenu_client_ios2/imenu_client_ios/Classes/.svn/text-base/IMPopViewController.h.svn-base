//
//  LoginAndRegisterMainViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-3.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 登陆注册页主框架控制器
 *
 *  用于承载登录、注册子视图，封装了子视图过渡切换功能，及底部彩条动画。
 */
@interface IMPopViewController : UIViewController

/**
 *  @brief 设置根视图
 *
 *  该方法在初始化完成后，应当立即被调用，以设置需要显示的根视图。
 *  当前已有根视图，则进行替换。
 *
 *  @param viewController 要设置的根视图
 *  @param title          视图标题
 *  @param flag           是否显示动画
 */
- (void)setRootViewController:(UIViewController *)viewController withTitle:(NSString *)title animated:(BOOL)flag;

/**
 *  @brief 退回主视图
 */
- (void)backToMainView;

/**
 *  @brief 隐藏关闭按钮
 */
- (void)hideCloseButton;

- (void)showInfoButtonWithTarget:(id)target action:(SEL)action;

/**
 *  @brief 是否显示底部彩条动画
 */
@property (nonatomic, assign) BOOL bottomAnimation;

@end
