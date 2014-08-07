//
//  IMSegmentedControl.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-2.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMSegmentedControlDelegate;

/**
 *  @brief iMenu分段控件
 *
 *  自定义分段控件以实现排序指示功能。
 */
@interface IMSegmentedControl : UIView

/**
 *  @brief 初始化方法
 *
 *  @param frame 设置控件位置和大小
 *  @param items 设置控件选项，NSString对象数组，用来初始化选项文字
 *  @param index 设置控件初始选中项
 *
 *  @return 初始化完成的分段控件对象
 */
- (id)initWithFrame:(CGRect)frame withSegmentedItems:(NSArray *)items atIndex:(NSUInteger)index;

/**
 *  @brief 是否可排序
 */
@property (nonatomic, assign) BOOL isSorted;

/**
 *  @brief 分段选择器代理对象
 */
@property (nonatomic, weak) id<IMSegmentedControlDelegate> delegate;

@end


/**
 *  @brief 分段选择器代理
 */
@protocol IMSegmentedControlDelegate <NSObject>

/**
 *  @brief 点击了分段选择项
 *
 *  @param segment     分段选择控件
 *  @param index       项索引
 *  @param isAscending 排序类型
 */
- (void)segmented:(IMSegmentedControl*)segment clickSegmentItemAtIndex:(NSUInteger)index bySort:(BOOL)isAscending;

@end
