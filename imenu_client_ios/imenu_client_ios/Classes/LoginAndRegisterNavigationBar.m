//
//  LoginAndRegisterNavigationBar.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-3.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "LoginAndRegisterNavigationBar.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@implementation LoginAndRegisterNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect contentFrame = self.bounds;
        contentFrame.origin.y += 20.0f;
        contentFrame.size.height -= 20.0f;
        
        self.contentView = [[UIView alloc] initWithFrame:contentFrame];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = YES;
        [self addSubview:self.contentView];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10.0f, 200.0f, 25.0f)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        self.title.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.title];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
        [self.closeButton setImage:[UIImage imageNamed:@"close_normal"] forState:UIControlStateNormal];
        [self.closeButton setImage:[UIImage imageNamed:@"close_highlight"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:self.closeButton];
        
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.5;
    }
    return self;
}

- (void)switchTitle:(NSString *)title
{
    CGRect frame = self.title.frame;
    frame.origin.y += self.contentView.bounds.size.height;
    
    UILabel *newTitle = [[UILabel alloc] initWithFrame:frame];
    newTitle.backgroundColor = [UIColor clearColor];
    newTitle.text = title;
    newTitle.font = self.title.font;
    newTitle.textAlignment = self.title.textAlignment;
    newTitle.textColor = self.title.textColor;
    [self.contentView addSubview:newTitle];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.title.frame;
        newTitle.frame = frame;
        
        frame.origin.y -= self.contentView.bounds.size.height;
        self.title.frame = frame;
    } completion:^(BOOL finished) {
        self.title = newTitle;
    }];
}

@end
