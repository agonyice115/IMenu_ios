//
//  UserData.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-8.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  @brief 用户数据类，使用单例模式
 */
@interface UserData : NSObject

/**
 *  @brief 单例模式对象，获取唯一实例的方法
 *
 *  @return 唯一实例对象
 */
+ (UserData *)sharedUserData;

/**
 *  @brief 用户登录
 *
 *  @param data 发送数据
 */
- (void)loginUserWithData:(NSDictionary *)data;

/**
 *  @brief 重设用户密码
 *
 *  @param data 发送数据
 */
- (void)resetUserPasswordWithData:(NSDictionary *)data;

/**
 *  @brief 注册新用户
 *
 *  @param data 发送数据
 */
- (void)registerUserWithData:(NSDictionary *)data;

/**
 *  @brief 载入用户数据
 */
- (void)loadingUserData;

/**
 *  @brief 编辑用户信息
 *
 *  @param data 发送数据
 */
- (void)editUserInfo:(NSDictionary *)data;

/**
 *  @brief 用户注销
 */
- (void)logoutUser;

/**
 *  @brief 用户是否登录
 */
@property (nonatomic, assign, readonly) BOOL isLogin;

/**
 *  @brief 用户ID
 */
@property (nonatomic, strong, readonly) NSString *memberId;

/**
 *  @brief 用户昵称
 */
@property (nonatomic, strong, readonly) NSString *memberName;

/**
 *  @brief 用户昵称
 */
@property (nonatomic, strong, readonly) NSString *memberSignature;

/**
 *  @brief 用户TOKEN
 */
@property (nonatomic, strong, readonly) NSString *token;

/**
 *  @brief 用户性别
 */
@property (nonatomic, strong, readonly) NSString *sex;

/**
 *  @brief 用户地区码
 */
@property (nonatomic, strong, readonly) NSString *areaCode;

/**
 *  @brief 用户手机号码
 */
@property (nonatomic, strong, readonly) NSString *mobile;

/**
 *  @brief 用户生日
 */
@property (nonatomic, strong, readonly) NSString *birthday;

/**
 *  @brief 用户真实姓名
 */
@property (nonatomic, strong, readonly) NSString *realname;

/**
 *  @brief 用户邮箱
 */
@property (nonatomic, strong, readonly) NSString *email;

/**
 *  @brief 用户经度
 */
@property (nonatomic, strong, readonly) NSString *longitude;

/**
 *  @brief 用户纬度
 */
@property (nonatomic, strong, readonly) NSString *latitude;

/**
 *  @brief 用户所在地
 */
@property (nonatomic, strong, readonly) NSString *regionId;

@property (nonatomic, assign, readonly) CLLocationCoordinate2D userCoordinate;

@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *iconLocation;

@property (nonatomic, strong) NSString *dynamicName;
@property (nonatomic, strong) NSString *dynamicLocation;

/**
 *  @brief 商家筛选时的地区ID
 */
@property (nonatomic, strong) NSString *shopRegionId;

@end
