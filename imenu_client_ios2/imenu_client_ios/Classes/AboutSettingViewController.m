//
//  AboutSettingViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-17.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "AboutSettingViewController.h"
#import "LongBarButton.h"
#import "UIColor+HtmlColor.h"
#import "IMPopViewController.h"
#import "IMWebViewController.h"
#import "Common.h"
#import "ClientConfig.h"
#import "FeedBackViewController.h"

@interface AboutSettingViewController () <UIAlertViewDelegate>

@end

@implementation AboutSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"setting_view_subtitle3", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
        
        float height = TOP_BAR_HEIGHT + 20.0f;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(160-317.0f/4, height, 317.0f/2, 85)];
        imageView.image = [UIImage imageNamed:@"load_icon.png"];
        [self.view addSubview:imageView];
        
        height += 100.0f;
        LongBarButton *longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        longBarButton.title.text = NSLocalizedString(@"setting_view_about2", nil);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"suggest_normal@2x.png"];
        [longBarButton setIconView:imageView];
        longBarButton.normalIcon = imageView.image;
        longBarButton.highlightIcon = [UIImage imageNamed:@"suggest_highlight@2x.png"];
        [longBarButton setTarget:self action:@selector(clickFeedBack)];
        [self.view addSubview:longBarButton];
        
        height += MIDDLE_BAR_HEIGHT + 1.0f;
        longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        longBarButton.title.text = NSLocalizedString(@"setting_view_about3", nil);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"general_setting_normal@2x.png"];
        [longBarButton setIconView:imageView];
        longBarButton.normalIcon = imageView.image;
        longBarButton.highlightIcon = [UIImage imageNamed:@"general_setting_highlight@2x.png"];
        [longBarButton setTarget:self action:@selector(clickRate)];
        [self.view addSubview:longBarButton];
        
        height += MIDDLE_BAR_HEIGHT + 1.0f;
        longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        longBarButton.title.text = NSLocalizedString(@"setting_view_about4", nil);
        longBarButton.subTitle.text = NSLocalizedString(@"setting_view_about4b", nil);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"personal_setting_normal@2x.png"];
        [longBarButton setIconView:imageView];
        longBarButton.normalIcon = imageView.image;
        longBarButton.highlightIcon = [UIImage imageNamed:@"personal_setting_highlight@2x.png"];
        [longBarButton setTarget:self action:@selector(clickCheckVersion)];
        [self.view addSubview:longBarButton];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, self.view.frame.size.height-60, 80, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        [button setTitle:@"官方网站" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#008fff"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickGuanWang) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(120, self.view.frame.size.height-60, 80, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        [button setTitle:@"服务条款" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#008fff"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickFuWu) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(200, self.view.frame.size.height-60, 80, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        [button setTitle:@"官方微信" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#008fff"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickWeiXin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(120, self.view.frame.size.height-58, 1, 16)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#008fff"];
        [self.view addSubview:line];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(200, self.view.frame.size.height-58, 1, 16)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#008fff"];
        [self.view addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Copyright@2009-2014 思友科技 All Rights Reserved.";
        label.textColor = [UIColor colorWithHtmlColor:@"#888888"];
        [self.view addSubview:label];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickFeedBack
{
    FeedBackViewController *vc = [[FeedBackViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)clickRate
{
    NSString *url = [NSString stringWithFormat:@"%@%@", @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=", APPID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)clickCheckVersion
{
    if ([ClientConfig sharedConfig].updateVersion)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检查更新"
                                                            message:@"亲，发现了新版本，为了更好的美食之旅，尽快更新哦"
                                                           delegate:self
                                                  cancelButtonTitle:@"以后再说"
                                                  otherButtonTitles:@"立即更新", nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检查更新"
                                                            message:@"亲，没有发现新版本哦"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // 更新
        NSString *url = [NSString stringWithFormat:@"%@%@", @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?&id=", APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)clickGuanWang
{
    IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
    viewController.bottomAnimation = NO;
    
    IMWebViewController *vc = [[IMWebViewController alloc] initWithNibName:nil bundle:nil];
    vc.url = [NSURL URLWithString:[[ClientConfig sharedConfig] getGuanwang]];
    [viewController setRootViewController:vc withTitle:@"官方网站" animated:NO];
    
    [[self getIMNavigationController] presentViewController:viewController animated:YES completion:nil];
}

- (void)clickFuWu
{
    IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
    viewController.bottomAnimation = NO;
    
    IMWebViewController *vc = [[IMWebViewController alloc] initWithNibName:nil bundle:nil];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"imenu_fuwu" ofType:@"html"];
    vc.url = [NSURL fileURLWithPath:filePath];
    [viewController setRootViewController:vc withTitle:@"服务条款" animated:NO];
    
    [[self getIMNavigationController] presentViewController:viewController animated:YES completion:nil];
}

- (void)clickWeiXin
{
    IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
    viewController.bottomAnimation = NO;
    
    IMWebViewController *vc = [[IMWebViewController alloc] initWithNibName:nil bundle:nil];
    vc.url = [NSURL URLWithString:[[ClientConfig sharedConfig] getWechat]];
    [viewController setRootViewController:vc withTitle:@"官方微信" animated:NO];
    
    [[self getIMNavigationController] presentViewController:viewController animated:YES completion:nil];
}

@end
