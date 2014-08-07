//
//  SecondaryViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-15.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 二级视图控制器基类
 */
@interface SecondaryViewController : UIViewController

/**
 *  @brief 内容视图
 */
@property (nonatomic, strong) UIView *contentView;

/**
 *  @brief 导航栏标题
 */
@property (nonatomic, strong) UILabel *navigationTitle;

@end
