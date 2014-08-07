//
//  NewOrderViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOrderViewController : UIViewController

- (void)showPublishButton;

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *orderId;

@end
