//
//  ProgressView.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-10.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setProgress:(int)step ofTotal:(int)total
{
    for (int i = 0; i < total; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(28 * i, 0, 24, 3)];
        if (i == step)
        {
            imageView.image = [UIImage imageNamed:@"step_current.png"];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"step_default.png"];
        }
        [self addSubview:imageView];
    }
}

@end
