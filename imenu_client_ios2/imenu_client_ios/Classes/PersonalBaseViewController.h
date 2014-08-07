//
//  PersonalBaseViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-14.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterNavigationBar.h"

/**
 *  @brief 个人信息设置视图控制器基类
 *
 *  创建了导航栏及内容视图，继承自此类时需要重载didEditPersonalInfo方法
 */
@interface PersonalBaseViewController : UIViewController

/**
 *  @brief 完成个人信息编辑
 *
 *  子类应当重载该方法，并在确定关闭视图时调用基类方法
 */
- (void)didEditPersonalInfo;

/**
 *  @brief 内容视图
 */
@property (nonatomic, strong) UIView *contentView;

/**
 *  @brief 导航视图
 */
@property (nonatomic, strong) LoginAndRegisterNavigationBar *navigationBarView;

@end
