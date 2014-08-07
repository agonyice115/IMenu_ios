//
//  VerificationCodeViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-5.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 验证码校验视图控制器
 */
@interface VerificationCodeViewController : UIViewController

/**
 *  @brief 接收验证码手机号
 */
@property (nonatomic, strong) UILabel *phone;

/**
 *  @brief 是否是注册时接收验证码，决定下一步跳转到注册视图还是找回密码视图
 */
@property (nonatomic, assign) BOOL isRegister;

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

/**
 *  @brief 验证码
 */
@property (nonatomic, strong) NSString *verifyCode;

@end
