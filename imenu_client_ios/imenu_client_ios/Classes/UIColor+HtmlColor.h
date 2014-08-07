//
//  UIColor+HtmlColor.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-4.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 扩充UIColor类，使得其可以通过Html颜色字符串初始化
 */
@interface UIColor (HtmlColor)

/**
 *  @brief 根据Html颜色字符串获取UIColor
 *
 *  Html字符串示例：#FF9F03，格式不匹配返回黑色。
 *
 *  @param colorString Html颜色字符串
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHtmlColor:(NSString *)colorString;

@end
