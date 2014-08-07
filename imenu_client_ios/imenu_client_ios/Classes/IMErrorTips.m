//
//  IMErrorTips.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-5.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMErrorTips.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"

@interface IMErrorTips ()

@property (nonatomic, strong) UIImageView *errorImage;
@property (nonatomic, strong) UILabel *errorTips;

@end

@implementation IMErrorTips

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHtmlColor:@"#ffe6e6"];
        self.layer.borderColor = [UIColor colorWithHtmlColor:@"#ff5400"].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
        
        self.errorImage = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 3, 23, 23)];
        self.errorImage.image = [UIImage imageNamed:@"error_orange.png"];
        [self addSubview:self.errorImage];
        
        self.errorTips = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN + 30, 5, 320-PAGE_MARGIN*2-30, 20)];
        self.errorTips.backgroundColor = [UIColor clearColor];
        self.errorTips.textColor = [UIColor colorWithHtmlColor:@"#ff5400"];
        self.errorTips.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        [self addSubview:self.errorTips];
    }
    return self;
}

+ (IMErrorTips *)showTips:(NSString *)tips inView:(UIView *)view asError:(BOOL)error
{
    IMErrorTips *errorTips = [[IMErrorTips alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, 320, 0)];
    errorTips.errorTips.text = tips;
    [view addSubview:errorTips];
    
    if (error)
    {
        errorTips.backgroundColor = [UIColor colorWithHtmlColor:@"#ffe6e6"];
        errorTips.layer.borderColor = [UIColor colorWithHtmlColor:@"#ff5400"].CGColor;
        errorTips.errorImage.image = [UIImage imageNamed:@"error_orange.png"];
        errorTips.errorTips.textColor = [UIColor colorWithHtmlColor:@"#ff5400"];
    }
    else
    {
        errorTips.backgroundColor = [UIColor colorWithHtmlColor:@"#f1ffe6"];
        errorTips.layer.borderColor = [UIColor colorWithHtmlColor:@"#339900"].CGColor;
        errorTips.errorImage.image = [UIImage imageNamed:@"error_green.png"];
        errorTips.errorTips.textColor = [UIColor colorWithHtmlColor:@"#339900"];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        errorTips.frame = CGRectMake(0, TOP_BAR_HEIGHT, 320, 30);
    }];
    
    return errorTips;
}

- (void)hideAfterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(hideSelf) withObject:nil afterDelay:delay];
}

- (void)hideSelf
{
    [self removeFromSuperview];
}

@end
