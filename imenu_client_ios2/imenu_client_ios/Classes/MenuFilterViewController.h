//
//  MenuFilterViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-17.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSelectViewController.h"

@interface MenuFilterViewController : UIViewController

- (void)setFilterData:(NSArray *)data;

@property (nonatomic, weak) id<FilterSelectViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) NSDictionary *storeData;

@end
