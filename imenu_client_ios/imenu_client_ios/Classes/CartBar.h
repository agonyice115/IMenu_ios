//
//  CartBar.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartBar : UIView

- (void)refreshCartBar;

@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, weak) UIViewController *presentedViewController;

@end
