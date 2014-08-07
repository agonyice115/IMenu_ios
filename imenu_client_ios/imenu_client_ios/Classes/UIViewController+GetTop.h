//
//  UIViewController+GetTop.h
//  new_car_care_ios
//
//  Created by 李亮 on 14-2-11.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 扩展UIViewController以方便获取顶级父视图
 */
@interface UIViewController (GetTop)

/**
 *  @brief 获取顶级父视图
 *
 *  @return 返回顶级父视图
 */
- (UIViewController *)getTopParentViewController;

@end
