//
//  AccountsViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-15.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "AccountsViewController.h"
#import "LongBarButton.h"
#import "Common.h"
#import "UserData.h"
#import "EditEmailViewController.h"
#import "UIColor+HtmlColor.h"
#import "IMConfig.h"
#import <ShareSDK/ShareSDK.h>
#import "IMErrorTips.h"

@interface AccountsViewController ()

@property (nonatomic, strong) LongBarButton *phone;
@property (nonatomic, strong) LongBarButton *mail;

@end

@implementation AccountsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle.text = NSLocalizedString(@"register_title5", nil);
        
        float height = TOP_BAR_HEIGHT;
        
        // 添加手机
        self.phone = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        [self.phone setNoRightMore];
        self.phone.title.text = NSLocalizedString(@"register_view_phone", nil);
        self.phone.subTitle.text = [[UserData sharedUserData].mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"phone.png"];
        [self.phone setIconView:imageView];
        [self.phone setTarget:self action:@selector(clickPhone)];
        [self.contentView addSubview:self.phone];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加邮箱
        self.mail = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.mail.title.text = NSLocalizedString(@"register_view_mail", nil);
        self.mail.subTitle.text = [UserData sharedUserData].email;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"mail.png"];
        [self.mail setIconView:imageView];
        [self.mail setTarget:self action:@selector(clickMail)];
        [self.contentView addSubview:self.mail];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加新浪微博绑定
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, MIDDLE_BAR_HEIGHT/2-10, 20, 20)];
        icon.image = [UIImage imageNamed:@"sina.png"];
        [view addSubview:icon];
        [self.contentView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+30, 10, 70, 25)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = NSLocalizedString(@"register_view_sina", nil);
        [view addSubview:label];
        
        UISwitch *bind = [[UISwitch alloc] init];
        bind.center = CGPointMake(320-PAGE_MARGIN-bind.bounds.size.width/2, MIDDLE_BAR_HEIGHT/2);
        bind.onTintColor = [IMConfig sharedConfig].bgColor;
        [view addSubview:bind];
        
        [bind setOn:[ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo] animated:NO];
        [bind addTarget:self action:@selector(switchSina:) forControlEvents:UIControlEventValueChanged];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加人人账号绑定
        view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, MIDDLE_BAR_HEIGHT/2-10, 20, 20)];
        icon.image = [UIImage imageNamed:@"renren.png"];
        [view addSubview:icon];
        [self.contentView addSubview:view];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+30, 10, 70, 25)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = NSLocalizedString(@"register_view_renren", nil);
        [view addSubview:label];
        
        bind = [[UISwitch alloc] init];
        bind.center = CGPointMake(320-PAGE_MARGIN-bind.bounds.size.width/2, MIDDLE_BAR_HEIGHT/2);
        bind.onTintColor = [IMConfig sharedConfig].bgColor;
        [view addSubview:bind];
        
        [bind setOn:[ShareSDK hasAuthorizedWithType:ShareTypeRenren] animated:NO];
        [bind addTarget:self action:@selector(switchRenren:) forControlEvents:UIControlEventValueChanged];
        
        [self.contentView addSubview:view];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editMemberInfoOK:) name:@"editMemberInfoOK" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchSina:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    if ([switchButton isOn])
    {
        [ShareSDK authWithType:ShareTypeSinaWeibo
                       options:nil
                        result:^(SSAuthState state, id<ICMErrorInfo> error) {
                            if (state == SSAuthStateSuccess)
                            {
                                IMErrorTips *tips = [IMErrorTips showTips:NSLocalizedString(@"account_view_success_tip1", nil) inView:self.view asError:NO];
                                [tips hideAfterDelay:2.0];
                            }
                            else if (state == SSAuthStateFail)
                            {
                                [switchButton setOn:NO animated:YES];
                            }
                        }];
    }
    else
    {
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    }
}

-(void)switchRenren:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    if ([switchButton isOn])
    {
        [ShareSDK authWithType:ShareTypeRenren
                       options:nil
                        result:^(SSAuthState state, id<ICMErrorInfo> error) {
                            if (state == SSAuthStateSuccess)
                            {
                                IMErrorTips *tips = [IMErrorTips showTips:NSLocalizedString(@"account_view_success_tip2", nil) inView:self.view asError:NO];
                                [tips hideAfterDelay:2.0];
                            }
                            else if (state == SSAuthStateFail)
                            {
                                [switchButton setOn:NO animated:YES];
                            }
                        }];
    }
    else
    {
        [ShareSDK cancelAuthWithType:ShareTypeRenren];
    }
}

- (void)clickPhone
{
}

- (void)clickMail
{
    EditEmailViewController *viewController = [[EditEmailViewController alloc] initWithNibName:nil bundle:nil];
    viewController.oldText = [UserData sharedUserData].email;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)editMemberInfoOK:(NSNotification *)notification
{
    NSDictionary *result = notification.userInfo;
    if (result)
    {
        NSString *errorString = result[@"error"];
        if ([errorString length] == 0)
        {
            self.mail.subTitle.text = [UserData sharedUserData].email;
        }
    }
}

@end
