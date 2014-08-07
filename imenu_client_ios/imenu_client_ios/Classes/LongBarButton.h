//
//  LongBarButton.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-6.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 长条按钮
 */
@interface LongBarButton : UIView

/**
 *  @brief 设置按钮点击事件
 *
 *  @param target 响应点击事件的对象
 *  @param action 响应点击事件的方法
 */
- (void)setTarget:(id)target action:(SEL)action;

/**
 *  @brief 设置不显示右侧更多图像
 */
- (void)setNoRightMore;

/**
 *  @brief 设置不显示副标题
 */
- (void)setNoSubTitle;

/**
 *  @brief 按钮标题
 */
@property (nonatomic, strong) UILabel *title;

/**
 *  @brief 按钮副标题
 */
@property (nonatomic, strong) UILabel *subTitle;

/**
 *  @brief 图标视图
 */
@property (nonatomic, strong) UIImageView *iconView;

/**
 *  @brief 常态图标
 */
@property (nonatomic, strong) UIImage *normalIcon;

/**
 *  @brief 高亮图标
 */
@property (nonatomic, strong) UIImage *highlightIcon;

@end
