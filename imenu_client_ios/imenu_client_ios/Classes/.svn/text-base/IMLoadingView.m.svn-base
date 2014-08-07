//
//  IMLoadingView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-7.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMLoadingView.h"
#import "Common.h"

@interface IMLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *loadingText;

@end

@implementation IMLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        bgView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
//        bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
//        bgView.layer.cornerRadius = 5.0f;
//        bgView.clipsToBounds = YES;
//        [self addSubview:bgView];
//        
//        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        self.loadingView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
//        [self addSubview:self.loadingView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.imageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        self.imageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loading_1.png"],
                                          [UIImage imageNamed:@"loading_2.png"], nil];
        self.imageView.animationDuration = 1.0f;
        [self addSubview:self.imageView];
        
        self.loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        self.loadingText.backgroundColor = [UIColor clearColor];
        self.loadingText.center = CGPointMake(frame.size.width/2, frame.size.height/2+65);
        self.loadingText.font = [UIFont systemFontOfSize:15.0f];
        self.loadingText.textColor = [UIColor whiteColor];
        self.loadingText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.loadingText];
    }
    return self;
}

+ (IMLoadingView *)sharedLoadingView
{
    static dispatch_once_t once;
    static id instance;
    
    dispatch_once(&once, ^{
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y += TOP_BAR_HEIGHT;
        frame.size.height -= TOP_BAR_HEIGHT;
        instance = [[IMLoadingView alloc] initWithFrame:frame];
    });
    
    return instance;
}

+ (void)showLoading
{
    [[IMLoadingView sharedLoadingView].window addSubview:[IMLoadingView sharedLoadingView]];
    [[IMLoadingView sharedLoadingView].imageView startAnimating];
    [IMLoadingView sharedLoadingView].loadingText.text = @"加载中";
    //[[IMLoadingView sharedLoadingView].loadingView startAnimating];
}

+ (void)showText:(NSString *)text
{
    [IMLoadingView sharedLoadingView].loadingText.text = text;
}

+ (void)hideLoading
{
    [[IMLoadingView sharedLoadingView] removeFromSuperview];
    [[IMLoadingView sharedLoadingView].imageView stopAnimating];
    //[[IMLoadingView sharedLoadingView].loadingView stopAnimating];
}

@end
