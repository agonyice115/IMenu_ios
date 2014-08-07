//
//  IMRefreshView.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
    REFRESH_PULL = 0,
    REFRESH_RELEASE,
    REFRESH_NOW,
} REFRESH_ENUM;

@interface IMRefreshView : UIView

+ (IMRefreshView *)createRefreshView;

@property (nonatomic, strong) NSDate *lastUpdateTime;
@property (nonatomic, assign) REFRESH_ENUM refreshState;
@property (nonatomic, assign) BOOL darkTheme;
@property (nonatomic, assign) CGFloat dy;

@end
