//
//  DishesView.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-19.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 菜品视图
 */
@interface DishesView : UIView

/**
 *  @brief 菜品图像
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 *  @brief 菜品名称
 */
@property (nonatomic, strong) UILabel *dishesName;

/**
 *  @brief 菜品价格
 */
@property (nonatomic, strong) UILabel *dishesPrice;

@property (nonatomic, strong) NSDictionary *data;

@end
