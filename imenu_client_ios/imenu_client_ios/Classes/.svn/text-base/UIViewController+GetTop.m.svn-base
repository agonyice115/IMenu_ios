//
//  UIViewController+GetTop.m
//  new_car_care_ios
//
//  Created by 李亮 on 14-2-11.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "UIViewController+GetTop.h"

@implementation UIViewController (GetTop)

- (UIViewController *)getTopParentViewController
{
    UIViewController *parentViewController = self.parentViewController;
    UIViewController *currentViewController = self;
    
    while (parentViewController != nil)
    {
        currentViewController = parentViewController;
        parentViewController = currentViewController.parentViewController;
    }
    return currentViewController;
}

@end
