//
//  NewDishesView.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-7.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDishesView : UIView

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
