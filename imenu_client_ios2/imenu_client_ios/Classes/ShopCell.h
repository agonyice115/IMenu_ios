//
//  ShopCell.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-19.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCellDelegate;

/**
 *  @brief 商家列表格
 */
@interface ShopCell : UITableViewCell

/**
 *  @brief 商家列表格代理对象
 */
@property (nonatomic, weak) id<ShopCellDelegate> delegate;

/**
 *  @brief 设置数据和类型
 *
 *  @param data 商家数据
 *  @param type 显示类型，0-距离，1-价格，2-热门
 */
- (void)setData:(NSDictionary *)data withType:(NSUInteger)type;

@end


/**
 *  @brief 商家列表格代理
 */
@protocol ShopCellDelegate <NSObject>

/**
 *  @brief 点击了标题
 *
 *  @param data 商家数据
 */
- (void)onClickTitleWithData:(NSDictionary *)data;

/**
 *  @brief 点击了菜品
 *
 *  @param data 菜品数据
 *  @param shop 商家数据
 */
- (void)onClickDishesWithData:(NSDictionary *)data andShopData:(NSDictionary *)shop;

/**
 *  @brief 点击了更多
 *
 *  @param data 商家数据
 */
- (void)onClickMoreWithData:(NSDictionary *)data;

@end