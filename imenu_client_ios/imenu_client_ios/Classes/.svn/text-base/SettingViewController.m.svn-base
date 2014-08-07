//
//  SettingViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-17.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SettingViewController.h"
#import "UIColor+HtmlColor.h"
#import "ShopViewController.h"
#import "UserData.h"
#import "LongBarButton.h"
#import "PersonalSettingViewController.h"
#import "GeneralSettingViewController.h"
#import "AboutSettingViewController.h"

@interface SettingViewController () <UIActionSheetDelegate>

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"setting_view_title", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
        
        float height = TOP_BAR_HEIGHT + 10.0f;
        LongBarButton *longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        longBarButton.title.text = NSLocalizedString(@"setting_view_subtitle1", nil);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"personal_setting_normal@2x.png"];
        [longBarButton setIconView:imageView];
        longBarButton.normalIcon = imageView.image;
        longBarButton.highlightIcon = [UIImage imageNamed:@"personal_setting_highlight@2x.png"];
        [longBarButton setTarget:self action:@selector(clickPersonalSetting)];
        [self.view addSubview:longBarButton];
        
        height += MIDDLE_BAR_HEIGHT + 5.0f;
        longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        longBarButton.title.text = NSLocalizedString(@"setting_view_subtitle2", nil);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"general_setting_normal@2x.png"];
        [longBarButton setIconView:imageView];
        longBarButton.normalIcon = imageView.image;
        longBarButton.highlightIcon = [UIImage imageNamed:@"general_setting_highlight@2x.png"];
        [longBarButton setTarget:self action:@selector(clickGeneralSetting)];
        [self.view addSubview:longBarButton];
        
        height += MIDDLE_BAR_HEIGHT + 5.0f;
        longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        longBarButton.title.text = NSLocalizedString(@"setting_view_subtitle3", nil);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"about_normal@2x.png"];
        [longBarButton setIconView:imageView];
        longBarButton.normalIcon = imageView.image;
        longBarButton.highlightIcon = [UIImage imageNamed:@"about_highlight@2x.png"];
        [longBarButton setTarget:self action:@selector(clickAboutSetting)];
        [self.view addSubview:longBarButton];
        
        height += MIDDLE_BAR_HEIGHT + 20.0f;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50, height, 220, 40);
        button.backgroundColor = [UIColor colorWithHtmlColor:@"#cc0000"];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#cccccc"] forState:UIControlStateHighlighted];
        [button setTitle:NSLocalizedString(@"setting_view_logout", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickLogoutButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutOK:) name:@"userLogoutOK" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickPersonalSetting
{
    PersonalSettingViewController *vc = [[PersonalSettingViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)clickGeneralSetting
{
    GeneralSettingViewController *vc = [[GeneralSettingViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)clickAboutSetting
{
    AboutSettingViewController *vc = [[AboutSettingViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)clickLogoutButton
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"tip_button_logout", nil)
                                              otherButtonTitles:nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)userLogoutOK:(NSNotification *)notification
{
    NSDictionary *result = notification.userInfo;
    if (result)
    {
        NSString *errorString = result[@"error"];
        if ([errorString length] == 0)
        {
            ShopViewController *vc = [[ShopViewController alloc] initWithNibName:nil bundle:nil];
            [[self getIMNavigationController] setRootViewController:vc];
        }
        else
        {
            if ([errorString hasPrefix:@"10|"])
            {
                // 登出失败
            }
        }
    }
    else
    {
        // 网络错误
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        return;
    }
    
    [[UserData sharedUserData] logoutUser];
}

@end
