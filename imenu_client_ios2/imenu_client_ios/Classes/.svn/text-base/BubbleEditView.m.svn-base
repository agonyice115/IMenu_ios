//
//  BubbleEditView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "BubbleEditView.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"

#define BUBBLE_CORNER 5.0f
#define PAGE_SIDE_WIDTH 2.0f

@interface BubbleEditView ()

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *leftLabel;

@end

@implementation BubbleEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.textField = [[UITextView alloc] initWithFrame:CGRectMake(BUBBLE_CORNER, BUBBLE_CORNER,
                                                                      self.bounds.size.width-BUBBLE_CORNER*3,
                                                                      self.bounds.size.height-BUBBLE_CORNER*2-20)];
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.textField.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.delegate = self;
        [self addSubview:self.textField];
        
        self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUBBLE_CORNER+2, BUBBLE_CORNER+5,
                                                                          self.bounds.size.width-BUBBLE_CORNER-2,
                                                                          20)];
        self.placeholderLabel.backgroundColor = [UIColor clearColor];
        self.placeholderLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.placeholderLabel.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [self addSubview:self.placeholderLabel];
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUBBLE_CORNER+2,
                                                                   self.bounds.size.height-BUBBLE_CORNER-20,
                                                                   self.bounds.size.width-BUBBLE_CORNER*2-4,
                                                                   20)];
        self.leftLabel.backgroundColor = [UIColor clearColor];
        self.leftLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.leftLabel.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        self.leftLabel.textAlignment = NSTextAlignmentRight;
        self.leftLabel.text = @"还可输入140字";
        [self addSubview:self.leftLabel];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *stokeColor = [UIColor colorWithHtmlColor:@"#888888"];
    UIColor *fillColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    
    CGContextSetStrokeColorWithColor(context, stokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineWidth(context, 0.0f);
    
    CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 0.6f, [UIColor colorWithWhite:0.6f alpha:0.4f].CGColor);
    
    CGContextMoveToPoint(context, BUBBLE_CORNER, BUBBLE_CORNER*4);
    CGContextAddLineToPoint(context, 0, BUBBLE_CORNER*4-BUBBLE_CORNER/3*2);
    CGContextAddLineToPoint(context, BUBBLE_CORNER, BUBBLE_CORNER*4-BUBBLE_CORNER/3*4);
    CGContextAddArcToPoint(context, BUBBLE_CORNER, PAGE_SIDE_WIDTH, BUBBLE_CORNER*2, PAGE_SIDE_WIDTH, BUBBLE_CORNER);
    CGContextAddArcToPoint(context,
                           rect.size.width-PAGE_SIDE_WIDTH-1,
                           PAGE_SIDE_WIDTH,
                           rect.size.width-PAGE_SIDE_WIDTH-1,
                           PAGE_SIDE_WIDTH+BUBBLE_CORNER,
                           BUBBLE_CORNER);
    CGContextAddArcToPoint(context,
                           rect.size.width-PAGE_SIDE_WIDTH-1,
                           rect.size.height-PAGE_SIDE_WIDTH,
                           rect.size.width-PAGE_SIDE_WIDTH-BUBBLE_CORNER,
                           rect.size.height-PAGE_SIDE_WIDTH,
                           BUBBLE_CORNER);
    CGContextAddArcToPoint(context,
                           BUBBLE_CORNER,
                           rect.size.height-PAGE_SIDE_WIDTH,
                           BUBBLE_CORNER,
                           rect.size.height/2-BUBBLE_CORNER,
                           BUBBLE_CORNER);
    
    CGContextFillPath(context);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length > 0;
    
    int length = textView.text.length > 140 ? 0 : 140-textView.text.length;
    self.leftLabel.text = [NSString stringWithFormat:@"还可输入%d字", length];
}

@end
