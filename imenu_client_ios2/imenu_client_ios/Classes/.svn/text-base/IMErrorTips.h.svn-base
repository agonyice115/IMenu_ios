//
//  IMErrorTips.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-5.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 提示框
 *
 *  显示在导航栏下方，进行各种提示
 */
@interface IMErrorTips : UIView

/**
*  @brief 创建并显示提示框
*
*  @param tips  提示文字
*  @param view  提示框显示所在视图
*  @param error 是否是错误提示
*
*  @return 返回创建的提示框
*/
+ (IMErrorTips *)showTips:(NSString *)tips inView:(UIView *)view asError:(BOOL)error;

- (void)hideAfterDelay:(NSTimeInterval)delay;

@end
