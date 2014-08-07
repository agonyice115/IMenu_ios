//
//  CommentInputView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-2-7.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "CommentInputView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "UIView+AnimationOptionsForCurve.h"

@interface CommentInputView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation CommentInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCloseView:)]];
        
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.bgView];
        
//        self.atButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.atButton.frame = CGRectMake(PAGE_MARGIN, 10, 30, 35);
//        [self.atButton setTitle:@"@" forState:UIControlStateNormal];
//        self.atButton.titleLabel.font = [UIFont boldSystemFontOfSize:26];
//        [self.atButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.bgView addSubview:self.atButton];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.backgroundColor = [UIColor whiteColor];
        self.sendButton.frame = CGRectMake(320-PAGE_MARGIN-50, 10, 50, 35);
        [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        [self.sendButton setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
        self.sendButton.layer.cornerRadius = 3.0f;
        [self.bgView addSubview:self.sendButton];
        
        self.textView = [[AutoHeightTextView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 320-PAGE_MARGIN*2-60, 35)];
        self.textView.maxHeight = 140.0f;
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.textView.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.textView.layer.cornerRadius = 3.0f;
        self.textView.delegate = self;
        [self.bgView addSubview:self.textView];
        
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

- (void)clearContent
{
    self.textView.text = @"";
}

- (void)setHideNoEdit:(BOOL)hideNoEdit
{
    _hideNoEdit = hideNoEdit;
    if (hideNoEdit)
    {
        self.hidden = YES;
    }
}

- (void)clickCloseView:(UIGestureRecognizer *)recognizer
{
    [self.textView resignFirstResponder];
}

#pragma mark - AutoHeightText delegate

- (void)textViewHeightChanged:(AutoHeightTextView *)textView
{
    CGRect inputViewFrame = self.bgView.frame;
    inputViewFrame.origin.y = CGRectGetMaxY(inputViewFrame)-CGRectGetHeight(self.textView.frame)-20;
    inputViewFrame.size.height = CGRectGetHeight(self.textView.frame)+20;
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.bgView.frame = inputViewFrame;
                     }];
}

- (void)textViewBeginEdit:(AutoHeightTextView *)textView
{
    
}

- (void)textViewEndEdit:(AutoHeightTextView *)textView
{
}

#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    if ([self.textView isFirstResponder])
    {
        self.hidden = NO;
        [self keyboardWillShowHide:notification isShow:YES];
    }
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    if ([self.textView isFirstResponder])
    {
        [self keyboardWillShowHide:notification isShow:NO];
    }
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
                         
                         CGRect inputViewFrame = isShow ? CGRectMake(0, 0, 320, 480) : self.bgView.bounds;
                         self.frame = CGRectMake(inputViewFrame.origin.x,
                                                 keyboardY - inputViewFrame.size.height,
                                                 inputViewFrame.size.width,
                                                 inputViewFrame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (!isShow && self.hideNoEdit)
                         {
                             self.hidden = YES;
                         }
                     }];
}

@end
