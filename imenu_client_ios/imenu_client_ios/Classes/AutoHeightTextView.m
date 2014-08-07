//
//  AutoHeightTextView.m
//  new_car_care_ios
//
//  Created by 李亮 on 14-2-12.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "AutoHeightTextView.h"

@interface AutoHeightTextView () <UITextViewDelegate>

@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, assign) CGFloat previousContentHeight;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation AutoHeightTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.minHeight = frame.size.height;
        self.maxHeight = FLT_MAX;
        self.previousContentHeight = self.minHeight;
        
        self.textView = [[UITextView alloc] initWithFrame:self.bounds];
        self.textView.font = [UIFont systemFontOfSize:15.0f];
        self.textView.textColor = [UIColor blackColor];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.delegate = self;
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        {
            self.textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        }
        [self addSubview:self.textView];
        
        self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 0)];
        self.placeholderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.placeholderLabel];
        
        self.placeholderColor = [UIColor lightGrayColor];
        self.placeholderFont = [UIFont systemFontOfSize:15.0f];
    }
    return self;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = placeholderFont;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setEditable:(BOOL)editable
{
    self.textView.editable = editable;
}

- (BOOL)editable
{
    return [self.textView isEditable];
}

- (void)setFont:(UIFont *)font
{
    self.textView.font = font;
    self.placeholderLabel.font = font;
    
    [self calculateHeight];
}

- (UIFont *)font
{
    return self.textView.font;
}

- (void)setText:(NSString *)text
{
    if (text == nil)
    {
        return;
    }
    
    self.placeholderLabel.hidden = text.length > 0;
    
    self.textView.text = text;
    
    [self calculateHeight];
}

- (NSString *)text
{
    return self.textView.text;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textView.textColor = textColor;
}

- (UIColor *)textColor
{
    return self.textColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
}

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    self.textView.keyboardType = keyboardType;
}

- (UIKeyboardType)keyboardType
{
    return self.textView.keyboardType;
}

- (void)setBackgroundView:(UIImageView *)backgroundView
{
    if (_backgroundView)
    {
        [_backgroundView removeFromSuperview];
    }
    
    _backgroundView = backgroundView;
    
    if (backgroundView)
    {
        backgroundView.frame = self.bounds;
        [self addSubview:backgroundView];
        [self sendSubviewToBack:backgroundView];
    }
}

- (void)setTipsImageView:(UIImageView *)tipsImageView
{
    if (_tipsImageView)
    {
        [_tipsImageView removeFromSuperview];
    }
    
    _tipsImageView = tipsImageView;
    
    if (tipsImageView)
    {
        CGRect frame = tipsImageView.frame;
        frame.origin.x = self.frame.size.width-10-frame.size.width;
        frame.origin.y = self.minHeight/2-frame.size.height/2;
        tipsImageView.frame = frame;
        [self addSubview:tipsImageView];
    }
    
    [self calculateHeight];
}

#pragma mark - 重载响应者事件

- (BOOL)canBecomeFirstResponder
{
    return [self.textView canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    return [self.textView canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [self.textView isFirstResponder];
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.delegate)
    {
        [self.delegate textViewBeginEdit:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.delegate)
    {
        [self.delegate textViewEndEdit:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        self.placeholderLabel.hidden = YES;
    }
    else
    {
        self.placeholderLabel.hidden = NO;
    }
    
    [self calculateHeight];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y + scrollView.bounds.size.height > scrollView.contentSize.height)
    {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height-scrollView.bounds.size.height) animated:NO];
    }
}

- (void)calculateHeight
{
    UITextView *tempTextView = [[UITextView alloc] init];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        tempTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    tempTextView.text = self.text;
    tempTextView.font = self.textView.font;
    CGSize size = [tempTextView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, FLT_MAX)];
    CGFloat contentHeight = size.height;
    contentHeight = contentHeight < self.minHeight ? self.minHeight : contentHeight;
    contentHeight = contentHeight > self.maxHeight ? self.maxHeight : contentHeight;
    
    CGRect frame = self.frame;
    frame.size.height = contentHeight;
    self.frame = frame;
    
    frame = self.bounds;
    
    if (self.backgroundView)
    {
        self.backgroundView.frame = frame;
    }
    
    if (self.tipsImageView)
    {
        frame.size.width -= 10+self.tipsImageView.frame.size.width;
    }
    
    self.textView.frame = frame;
    
    frame = self.placeholderLabel.frame;
    frame.size.width = self.textView.frame.size.width-10*2;
    self.placeholderLabel.frame = frame;
    
    if (contentHeight != self.previousContentHeight)
    {
        self.previousContentHeight = contentHeight;
        
        if (self.delegate)
        {
            [self.delegate textViewHeightChanged:self];
        }
    }
}

@end
