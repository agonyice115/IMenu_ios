//
//  ShopTopBar.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTopBar : UIView

@property (nonatomic, strong) NSDictionary *storeData;
@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, assign) BOOL hideRightMore;

@end
