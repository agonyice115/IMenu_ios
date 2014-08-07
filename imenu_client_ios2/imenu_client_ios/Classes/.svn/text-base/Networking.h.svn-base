//
//  Networking.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-8.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 网络访问类
 */
@interface Networking : NSObject

+ (Networking *)sharedNetworking;

/**
 *  @brief post请求，使用KEY=VALUE方式
 *
 *  @param data  发送的数据
 *  @param route 请求的route
 *  @param token 请求的token
 *
 *  @return 请求响应数据，请求失败返回nil
 */
+ (NSDictionary *)postData:(NSDictionary *)data withRoute:(NSString *)route withToken:(NSString *)token;

/**
 *  @brief post请求，使用multipart/form-data方式
 *
 *  @param data  发送的数据
 *  @param route 请求的route
 *  @param token 请求的token
 *  @param image 发送的图像数据
 *
 *  @return 请求响应数据，请求失败返回nil
 */
+ (NSDictionary *)postData:(NSDictionary *)data withRoute:(NSString *)route withToken:(NSString *)token withImage:(UIImage *)image;

- (void)startNetCheck;

@property (nonatomic, assign) BOOL isWiFi;
@property (nonatomic, assign) BOOL isAutoWiFi;

@end
