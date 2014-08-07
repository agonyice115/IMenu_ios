//
//  RegionSelectView.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-25.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegionSelectViewDelegate;

@interface RegionSelectView : UIView

/**
 *  @brief 设置初始选择ID及分类数据
 *
 *  @param currentId 初始选择ID
 *  @param data      分类数据
 */
- (void)setCurrentId:(NSString *)currentId withData:(NSDictionary *)data;

@property (nonatomic, weak) id<RegionSelectViewDelegate> delegate;

@end

@protocol RegionSelectViewDelegate <NSObject>

- (void)onSelectId:(NSString *)Id withData:(NSDictionary *)data by:(RegionSelectView *)filter;

@end
