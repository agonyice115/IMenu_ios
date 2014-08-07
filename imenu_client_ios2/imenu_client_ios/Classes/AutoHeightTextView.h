//
//  AutoHeightTextView.h
//  new_car_care_ios
//
//  Created by 李亮 on 14-2-12.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutoHeightTextViewDelegate;

/**
 *  @brief 高度自适应TextView
 */
@interface AutoHeightTextView : UIView

/**
 *  @brief 可否编辑
 */
@property (nonatomic, assign) BOOL editable;

/**
 *  @brief 字体，默认为15号系统字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  @brief 文字内容
 */
@property (nonatomic, strong) NSString *text;

/**
 *  @brief 字体颜色，默认为黑色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  @brief 占位符
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  @brief 设置占位符文字的颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 *  @brief 设置占位符文字的大小
 */
@property (nonatomic, strong) UIFont *placeholderFont;

/**
 *  @brief 键盘类型
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/**
 *  @brief 背景图片
 *
 *  背景图片要能够自适应拉伸
 */
@property (nonatomic, strong) UIImageView *backgroundView;

/**
 *  @brief 右侧提示图片
 *
 *  提示图片将按照最小高度垂直居中靠右对齐
 */
@property (nonatomic, strong) UIImageView *tipsImageView;

/**
 *  @brief 最大高度，默认为float类型最大值
 */
@property (nonatomic, assign) CGFloat maxHeight;

/**
 *  @brief TextView代理
 */
@property (nonatomic, weak) id<AutoHeightTextViewDelegate> delegate;

@end

@protocol AutoHeightTextViewDelegate <NSObject>

/**
 *  @brief TextView高度发生变化
 *
 *  @param textView 发生变化的文本视图
 */
- (void)textViewHeightChanged:(AutoHeightTextView *)textView;

/**
 *  @brief TextView开始进入编辑状态
 *
 *  @param textView 进入编辑的文本视图
 */
- (void)textViewBeginEdit:(AutoHeightTextView *)textView;

/**
 *  @brief TextView结束编辑状态
 *
 *  @param textView 结束编辑的文本视图
 */
- (void)textViewEndEdit:(AutoHeightTextView *)textView;

@end
