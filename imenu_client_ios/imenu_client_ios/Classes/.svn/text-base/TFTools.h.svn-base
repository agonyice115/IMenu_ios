//
//  TFTools.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-8.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 工具类
 */
@interface TFTools : NSObject

/**
 *  @brief 获取字符串的MD5编码
 *
 *  @param str 编码字符串
 *
 *  @return MD5编码
 */
+ (NSString *)md5:(NSString *)str;

/**
 *  @brief 手机号合法性校验，目前仅支持中国
 *
 *  @param mobile 待校验手机号
 *
 *  @return 返回YES表示合法手机号，否则返回NO
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  @brief 邮箱地址合法性校验
 *
 *  @param email 待校验邮箱地址
 *
 *  @return 返回YES表示合法邮箱地址，否则返回NO
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  @brief 改变图片大小
 *
 *  @param image 要更改的图片
 *  @param size  要更改的尺寸
 *
 *  @return 更改后的图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image withSize:(CGSize)size;

+ (UIImage *)clippingImage:(UIImage *)image withSize:(CGSize)size;

/**
 *  @brief 获取指定文件名在文档下的路径
 *
 *  @param fileName 文件名
 *
 *  @return 文件路径
 */
+ (NSString *)getDocumentPathOfFile:(NSString *)fileName;

+ (NSString *)getThumbImageUrlOfLacation:(NSString *)location andName:(NSString *)name;

/**
 *  @brief 获取距离描述字符串
 *
 *  距离使用概述描述，如小于50米
 *
 *  @param distance 距离
 *
 *  @return 描述字符串
 */
+ (NSString *)getDistaceString:(NSString *)distance;

+ (NSString *)getFansString:(NSString *)count;

@end
