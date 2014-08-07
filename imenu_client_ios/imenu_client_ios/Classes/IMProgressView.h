//
//  IMProgressView.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-26.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMProgressView : UIView

+ (IMProgressView *)createProgressView;
- (void)setProgress:(float)progress;

@end
