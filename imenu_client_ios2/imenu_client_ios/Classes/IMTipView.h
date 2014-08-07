//
//  IMTipView.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-9.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 二级提示视图
 */
@interface IMTipView : UIView

/**
 *  @brief 提示文字
 */
@property (nonatomic, strong) UILabel *tips;

/**
 *  @brief 提示默认按钮
 */
@property (nonatomic, strong) UIButton *defaultButton;

@end
