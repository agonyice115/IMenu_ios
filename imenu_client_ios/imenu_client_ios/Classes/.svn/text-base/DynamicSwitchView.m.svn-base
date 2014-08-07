//
//  DynamicSwitchView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DynamicSwitchView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@implementation DynamicSwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (void)setShowFriend:(BOOL)showFriend
{
    if (_showFriend)
    {
        return;
    }
    
    _showFriend = YES;
    if (showFriend)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, TOP_BAR_HEIGHT+4, 160, 100)];
        view.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        view.layer.cornerRadius = 4.0f;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, 140, 30);
        [button setTitle:@"朋友动态" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"dynamic_friend"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [view addSubview:button];
        
        self.friendButton = button;
        
        button =  [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 60, 140, 30);
        [button setTitle:@"全城动态" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"dynamic_city"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [view addSubview:button];
        
        self.cityButton = button;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 140, 1)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [view addSubview:line];
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, TOP_BAR_HEIGHT+4, 160, 50)];
        view.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        view.layer.cornerRadius = 4.0f;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, 140, 30);
        [button setTitle:@"全城动态" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"dynamic_city"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [view addSubview:button];
        
        self.cityButton = button;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
