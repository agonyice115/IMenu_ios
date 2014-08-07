//
//  UIImage+Color.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-24.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 扩充UIImage以支持纯色图片
 */
@interface UIImage (Color)

/**
 *  @brief 获取指定颜色和大小的纯色图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return 生成的纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

@end
