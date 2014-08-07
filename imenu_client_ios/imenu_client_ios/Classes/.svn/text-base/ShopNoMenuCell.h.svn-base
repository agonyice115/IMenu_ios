//
//  ShopNoMenuCell.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-6.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCell.h"

@interface ShopNoMenuCell : UITableViewCell

/**
 *  @brief 设置数据和类型
 *
 *  @param data 商家数据
 *  @param type 显示类型，0-距离，1-价格，2-热门
 */
- (void)setData:(NSDictionary *)data withType:(NSUInteger)type;

@property (nonatomic, assign) NSUInteger index;

/**
 *  @brief 商家列表格代理对象
 */
@property (nonatomic, weak) id<ShopCellDelegate> delegate;
@end
