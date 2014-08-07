//
//  IMTipView.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-9.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMTipView.h"
#import "IMConfig.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"

@interface IMTipView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation IMTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, self.bounds.size.height/2-80, self.bounds.size.width-PAGE_MARGIN*2, 160)];
        self.contentView.layer.cornerRadius = 10.0f;
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
        self.contentView.layer.shadowOpacity = 0.8f;
        self.contentView.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        [self addSubview:self.contentView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width/2-12, 25, 23, 23)];
        imageView.image = [UIImage imageNamed:@"info_highlight@2x.png"];
        [self.contentView addSubview:imageView];
        
        self.tips = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, self.contentView.bounds.size.width-10, 20)];
        self.tips.backgroundColor = [UIColor clearColor];
        self.tips.textColor = [UIColor whiteColor];
        self.tips.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.tips.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.tips];
        
        self.defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.defaultButton.frame = CGRectMake(self.contentView.bounds.size.width/2-50, 105, 100, 35);
        self.defaultButton.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.defaultButton.layer.cornerRadius = 5.0f;
        self.defaultButton.layer.borderWidth = 1.0f;
        self.defaultButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.defaultButton setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [self.defaultButton setTitle:NSLocalizedString(@"tip_button_ok", nil) forState:UIControlStateNormal];
        [self.defaultButton addTarget:self action:@selector(clickDefaultButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.defaultButton];
    }
    return self;
}

- (void)clickDefaultButton
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
