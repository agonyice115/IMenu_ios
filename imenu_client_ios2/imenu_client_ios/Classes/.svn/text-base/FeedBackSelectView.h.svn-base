//
//  FeedBackSelectView.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedBackSelectViewDelegate;

@interface FeedBackSelectView : UIView

- (void)setParentId:(NSString *)Id withLevel:(int)level;

@property (nonatomic, weak) id<FeedBackSelectViewDelegate> delegate;

@end

@protocol FeedBackSelectViewDelegate <NSObject>

- (void)onSelectData:(NSDictionary *)data withLevel:(int)level;

@end