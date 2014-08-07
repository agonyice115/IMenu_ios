//
//  ResetPasswordViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-6.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 重设密码视图控制器
 */
@interface ResetPasswordViewController : UIViewController

/**
 *  @brief 地区码
 */
@property (nonatomic, strong) NSString *areaCode;

/**
 *  @brief 手机号码
 */
@property (nonatomic, strong) NSString *phoneString;

/**
 *  @brief 加密校验码
 */
@property (nonatomic, strong) NSString *menuCode;

@end
