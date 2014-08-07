//
//  IMRefreshView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMRefreshView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@interface IMRefreshView ()

@property (nonatomic, strong) UIImageView *loadImage;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation IMRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.loadImage = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 30, 30)];
        [self addSubview:self.loadImage];
        
        self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+40, 15, 80, 20)];
        self.refreshLabel.font = [UIFont systemFontOfSize:10.0f];
        self.refreshLabel.textAlignment = NSTextAlignmentLeft;
        self.refreshLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.refreshLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-PAGE_MARGIN-120, 15, 120, 20)];
        self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.timeLabel];
        
        self.darkTheme = NO;
        self.refreshState = REFRESH_PULL;
        self.lastUpdateTime = [NSDate date];
    }
    return self;
}

+ (IMRefreshView *)createRefreshView
{
    return [[IMRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
}

- (void)setDarkTheme:(BOOL)darkTheme
{
    _darkTheme = darkTheme;
    
    if (darkTheme)
    {
        self.loadImage.image = [UIImage imageNamed:@"loading_dark.png"];
        self.refreshLabel.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.timeLabel.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    }
    else
    {
        self.loadImage.image = [UIImage imageNamed:@"loading_white.png"];
        self.refreshLabel.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
        self.timeLabel.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    }
}

- (void)setDy:(CGFloat)dy
{
    _dy = dy;
    
    self.loadImage.transform = CGAffineTransformMakeRotation(M_PI/50*dy);
}

- (void)setRefreshState:(REFRESH_ENUM)refreshState
{
    _refreshState = refreshState;
    
    switch (refreshState)
    {
        case REFRESH_PULL:
        {
            self.refreshLabel.text = @"下拉刷新";
            [self stopAnimation];
        }
            break;
            
        case REFRESH_NOW:
        {
            self.refreshLabel.text = @"正在刷新";
            [self startAnimation];
        }
            break;
            
        case REFRESH_RELEASE:
        {
            self.refreshLabel.text = @"释放立即刷新";
            [self stopAnimation];
        }
            break;
            
        default:
            break;
    }
}

- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"最后更新:今天 HH:mm"];
    self.timeLabel.text = [dateFormatter stringFromDate:lastUpdateTime];
}

- (void)startAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: 0.0f ];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.loadImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation
{
    [self.loadImage.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
