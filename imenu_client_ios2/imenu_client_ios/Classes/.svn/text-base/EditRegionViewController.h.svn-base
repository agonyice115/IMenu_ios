//
//  EditRegionViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "PersonalBaseViewController.h"

@protocol EditRegionViewDelegate;

/**
 *  @brief 编辑地区
 */
@interface EditRegionViewController : PersonalBaseViewController

/**
 *  @brief 当前选择ID
 */
@property (nonatomic, strong) NSString *currentId;

@property (nonatomic, weak) id<EditRegionViewDelegate> delegate;

/**
 *  @brief 设置初始选择ID及分类数据
 *
 *  @param currentId 初始选择ID
 *  @param data      分类数据
 */
- (void)setCurrentId:(NSString *)currentId withData:(NSDictionary *)data;

@end

@protocol EditRegionViewDelegate <NSObject>

- (void)onSelectId:(NSString *)Id withData:(NSDictionary *)data by:(EditRegionViewController *)filter;

@end
