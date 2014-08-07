//
//  IMProgressView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-26.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMProgressView.h"

@interface IMProgressView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *loadingText;

@end

@implementation IMProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.imageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loading_1.png"],
                                          [UIImage imageNamed:@"loading_2.png"], nil];
        self.imageView.animationDuration = 1.0f;
        [self addSubview:self.imageView];
        
        self.loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 20)];
        self.loadingText.font = [UIFont systemFontOfSize:15.0f];
        self.loadingText.textColor = [UIColor whiteColor];
        self.loadingText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.loadingText];
    }
    return self;
}

+ (IMProgressView *)createProgressView
{
    return [[IMProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 120)];
}

- (void)setProgress:(float)progress
{
    [self.imageView startAnimating];
    self.loadingText.text = [NSString stringWithFormat:@"%d%%", (int)(progress*100)];
}

@end
