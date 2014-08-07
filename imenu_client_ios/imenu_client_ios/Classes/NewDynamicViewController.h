//
//  NewDynamicViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDynamicViewController : UIViewController

@property (nonatomic, assign) BOOL isHidePhoto;
@property (nonatomic, strong) NSString *dynamicId;
@property (nonatomic, strong) NSString *orderId;

- (void)showOrder;
- (void)showMenuCamera:(NSInteger)index;

@end
