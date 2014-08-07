//
//  CartData.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 购物车变更通知名称
 *
 *  当购物车数据变化时，发出此名称通知
 */
#define CART_DATA_CHANGED @"CART_DATA_CHANGED"
#define CART_DATA_SAVED @"CART_DATA_SAVED"
#define CART_DATA_SAVED_ERROR @"CART_DATA_SAVED_ERROR"

@interface CartData : NSObject

/**
 *  @brief 单例模式对象，获取唯一实例的方法
 *
 *  @return 唯一实例对象
 */
+ (CartData *)sharedCartData;

- (void)addMenu:(NSDictionary *)menuData;
- (void)removeMenu:(NSDictionary *)menuData;

- (void)addMenuCount:(NSString *)menuId;
- (void)redMenuCount:(NSString *)menuId;

- (void)loadData;
- (void)saveData;
- (void)cleanData;

- (BOOL)isOrder:(NSString *)menuId;

@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSDictionary *storeData;

@property (nonatomic, assign) NSUInteger peopleCount;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, assign) float couponPrice;
@property (nonatomic, strong) NSMutableArray *cartList;
@property (nonatomic, assign, readonly) NSUInteger menuCount;

@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *modifyDate;

@property (nonatomic, assign) BOOL dataChanged;

@property (nonatomic, assign) BOOL hasCouponPrice;
@property (nonatomic, strong) NSString *couponId;

@end
