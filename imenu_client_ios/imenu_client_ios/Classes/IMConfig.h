//
//  IMConfig.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-2.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief UI颜色修改通知名称
 *
 *  当UI颜色修改时，发出此名称通知
 */
#define IM_UICOLOR_CHANGED @"IM_UICOLOR_CHANGED"

/**
 *  @brief 配置类，使用单例模式
 */
@interface IMConfig : NSObject

/**
 *  @brief 单例模式对象，获取唯一实例的方法
 *
 *  @return 唯一实例对象
 */
+ (IMConfig *)sharedConfig;

- (void)setSexColor:(NSString *)sex;

/**
 *  @brief 设置背景颜色字符串
 */
@property (nonatomic, strong) NSString *bgColorString;

/**
 *  @brief 当前UI颜色设置前景色
 */
@property (nonatomic, strong, readonly) UIColor *fgColor;

/**
 *  @brief 当前UI颜色设置背景色
 */
@property (nonatomic, strong, readonly) UIColor *bgColor;

@end
