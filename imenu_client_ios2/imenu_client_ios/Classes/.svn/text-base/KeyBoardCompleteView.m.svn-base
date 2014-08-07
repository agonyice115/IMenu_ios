//
//  KeyBoardCompleteView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-5-23.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "KeyBoardCompleteView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@implementation KeyBoardCompleteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHtmlColor:@"#efefef"];
        
        self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.completeButton.frame = CGRectMake(frame.size.width - 70, 0, 70, frame.size.height);
        self.completeButton.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        [self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.completeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.completeButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillShowKeyboard:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillHideKeyboard:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    self.hidden = NO;
    [self keyboardWillShowHide:notification isShow:YES];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification isShow:NO];
}

- (void)keyboardWillShowHide:(NSNotification *)notification isShow:(BOOL)isShow
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = keyboardRect.origin.y;
                         
                         self.frame = CGRectMake(self.frame.origin.x,
                                                 keyboardY - self.frame.size.height,
                                                 self.frame.size.width,
                                                 self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         self.hidden = !isShow;
                     }];
}

@end
