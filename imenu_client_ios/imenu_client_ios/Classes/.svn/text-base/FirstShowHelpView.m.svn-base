//
//  FirstShowHelpView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FirstShowHelpView.h"

@interface FirstShowHelpView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FirstShowHelpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView  = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

+ (void)loadHelpView:(NSString *)type
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *obj = [userDefaults objectForKey:type];
    if (obj)
    {
        return;
    }
    [userDefaults setObject:type forKey:type];
    [userDefaults synchronize];
    
    NSString *fileName;
    if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        fileName = [NSString stringWithFormat:@"%@-1136.png", type];
    }
    else
    {
        fileName = [NSString stringWithFormat:@"%@-960.png", type];
    }
    
    FirstShowHelpView *view = [[FirstShowHelpView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.imageView.image = [UIImage imageNamed:fileName];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

@end
