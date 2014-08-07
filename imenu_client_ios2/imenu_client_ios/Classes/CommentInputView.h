//
//  CommentInputView.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-2-7.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoHeightTextView.h"

@interface CommentInputView : UIView <AutoHeightTextViewDelegate>

@property (nonatomic, strong) AutoHeightTextView *textView;
@property (nonatomic, strong) UIButton *atButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) BOOL hideNoEdit;

- (void)clearContent;

@end
