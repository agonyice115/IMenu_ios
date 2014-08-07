//
//  FilterSelectViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-2.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterSelectViewDelegate;

/**
 *  @brief 筛选分类选择视图控制器
 */
@interface FilterSelectViewController : UIViewController

/**
 *  @brief 增加地区显示
 */
@property (nonatomic, assign) BOOL showRegionButton;

/**
 *  @brief 当前选择ID
 */
@property (nonatomic, strong) NSString *currentId;

@property (nonatomic, weak) id<FilterSelectViewDelegate> delegate;

/**
 *  @brief 设置初始选择ID及分类数据
 *
 *  @param currentId 初始选择ID
 *  @param data      分类数据
 */
- (void)setCurrentId:(NSString *)currentId withData:(NSDictionary *)data;

@end

@protocol FilterSelectViewDelegate <NSObject>

- (void)onSelectId:(NSString *)Id withData:(NSDictionary *)data by:(FilterSelectViewController *)filter;

@end
