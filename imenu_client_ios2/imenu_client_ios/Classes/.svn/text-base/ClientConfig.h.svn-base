//
//  ClientConfig.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-2.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONFIG_VERSION_NAME_REGION @"region"
#define CONFIG_VERSION_NAME_CATEGORY @"category"
#define CONFIG_VERSION_NAME_ENVIRONMENT @"environment"
#define CONFIG_VERSION_NAME_SERVICE @"service"
#define CONFIG_VERSION_NAME_MENU_UNIT @"menu_unit"
#define CONFIG_VERSION_NAME_MENU_TASTE @"menu_taste"
#define CONFIG_VERSION_NAME_AREA_CODE @"area_code"
#define CONFIG_VERSION_NAME_SHARE_MENU @"share_menu"
#define CONFIG_VERSION_NAME_SHARE_STORE @"share_store"
#define CONFIG_VERSION_NAME_SHARE_MEMBER @"share_member"
#define CONFIG_VERSION_NAME_SHARE_DYNAMIC @"share_dynamic"
#define CONFIG_VERSION_NAME_VERSION_IOS @"version_ios"
#define CONFIG_VERSION_NAME_SKIN @"client_skin"
#define CONFIG_VERSION_NAME_FEEDBACK @"feedback"
#define CONFIG_VERSION_NAME_ABOUT_INFO @"about_info"
#define CONFIG_VERSION_NAME_MOBILE_TOKEN @"mobile_token"

@interface ClientConfig : NSObject

/**
 *  @brief 单例模式对象，获取唯一实例的方法
 *
 *  @return 唯一实例对象
 */
+ (ClientConfig *)sharedConfig;

- (NSString *)getGuanwang;
- (NSString *)getWechat;

- (NSArray *)getServiceList:(NSArray *)list;
- (NSArray *)getEnvironmentList:(NSArray *)list;
- (NSString *)getMenuTasteUrlById:(NSString *)menuTasteId;

- (NSDictionary *)getShareStringWithName:(NSString *)name andId:(NSString *)Id from:(NSString *)key;
- (NSDictionary *)getShareStringWithName:(NSString *)name andId:(NSString *)Id shopName:(NSString *)shopName;

- (NSString *)getRegionStringById:(NSString *)regionId;

@property (nonatomic, strong) NSDictionary *regionFilterData;

@property (nonatomic, assign) BOOL updateVersion;

@end
