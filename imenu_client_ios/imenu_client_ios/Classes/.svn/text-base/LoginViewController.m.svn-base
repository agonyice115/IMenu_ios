//
//  LoginViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-3.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "LoginButton.h"
#import "IMPopViewController.h"
#import "FindPasswordViewController.h"
#import "Networking.h"
#import "TFTools.h"
#import "LongBarButton.h"
#import "AreaSelectViewController.h"
#import "UserData.h"
#import "IMErrorTips.h"
#import "KeyBoardCompleteView.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *accountTitle;
@property (nonatomic, strong) UITextField *accountContent;
@property (nonatomic, strong) UILabel *passwordTitle;
@property (nonatomic, strong) UITextField *passwordContent;

@property (nonatomic, strong) IMErrorTips *errorTips;

@property (nonatomic, strong) LongBarButton *areaButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) LoginButton *loginButton;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        float height = self.view.bounds.size.height * 0.25f;
        
        // 添加地区选择
        self.areaButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.areaButton.clipsToBounds = YES;
        self.areaButton.title.text = @"中国（+86）";
        [self.areaButton setTarget:self action:@selector(clickAreaButton)];
        [self.view addSubview:self.areaButton];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 300)];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.contentView];
        
        height = 0;
        
        // 添加账户输入
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.accountTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
        self.accountTitle.textAlignment = NSTextAlignmentLeft;
        self.accountTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.accountTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [view addSubview:self.accountTitle];
        
        self.accountContent = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+80, 10, self.view.bounds.size.width-PAGE_MARGIN*2-120, 25)];
        self.accountContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.accountContent.textAlignment = NSTextAlignmentLeft;
        self.accountContent.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.accountContent.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.accountContent.returnKeyType = UIReturnKeyNext;
        self.accountContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.accountContent.delegate = self;
        [view addSubview:self.accountContent];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.view.bounds.size.width-23-PAGE_MARGIN, 12, 23, 23);
        [button setImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"switch_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickSwitchButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [self.contentView addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加密码输入
        view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.passwordTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
        self.passwordTitle.textAlignment = NSTextAlignmentLeft;
        self.passwordTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.passwordTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.passwordTitle.text = NSLocalizedString(@"login_view_password", nil);
        [view addSubview:self.passwordTitle];
        
        self.passwordContent = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+80, 10, self.view.bounds.size.width-PAGE_MARGIN*2-120, 25)];
        self.passwordContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordContent.textAlignment = NSTextAlignmentLeft;
        self.passwordContent.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.passwordContent.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.passwordContent.returnKeyType = UIReturnKeyDone;
        self.passwordContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordContent.secureTextEntry = YES;
        self.passwordContent.placeholder = NSLocalizedString(@"login_view_password_default", nil);
        self.passwordContent.delegate = self;
        [view addSubview:self.passwordContent];
        
        [self.contentView addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 10;
        // 添加忘记密码
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.view.bounds.size.width-100-PAGE_MARGIN, height, 100, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#008fff"] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"login_view_forgot_password", nil) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"password"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickForgotButton) forControlEvents:UIControlEventTouchUpInside];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:button];
        
        // 添加进入按钮
        self.loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width, BOTTOM_BAR_HEIGHT);
        [self.loginButton setTitle:NSLocalizedString(@"login_view_enter", nil) forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@"enter_normal"] forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@"enter_highlight"] forState:UIControlStateHighlighted];
        [self.loginButton setImage:[UIImage imageNamed:@"enter_disabled"] forState:UIControlStateDisabled];
        [self.loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 20)];
        [self.loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.loginButton addTarget:self action:@selector(clickEnterButton) forControlEvents:UIControlEventTouchUpInside];
        self.loginButton.enabled = NO;
        [self.view addSubview:self.loginButton];
        
        KeyBoardCompleteView *completeView = [[KeyBoardCompleteView alloc] initWithFrame:CGRectMake(0, 600, 320, 30)];
        [completeView.completeButton addTarget:self action:@selector(overEdit) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:completeView];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginUserOK:) name:@"loginUserOK" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setIsPhoneLogin:(BOOL)isPhoneLogin
{
    _isPhoneLogin = isPhoneLogin;
    
    if (isPhoneLogin)
    {
        self.accountTitle.text = NSLocalizedString(@"login_view_phone", nil);
        self.accountContent.placeholder = NSLocalizedString(@"login_view_phone_default", nil);
        self.accountContent.keyboardType = UIKeyboardTypePhonePad;
        
        CGRect frame = self.contentView.frame;
        frame.origin.y = self.areaButton.frame.origin.y;
        self.contentView.frame = frame;
        
        frame = self.areaButton.frame;
        frame.size.height = 0;
        self.areaButton.frame = frame;
        
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = self.contentView.frame;
            frame.origin.y = self.areaButton.frame.origin.y + MIDDLE_BAR_HEIGHT + 1;
            self.contentView.frame = frame;
            
            frame = self.areaButton.frame;
            frame.size.height = MIDDLE_BAR_HEIGHT;
            self.areaButton.frame = frame;
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        self.accountTitle.text = NSLocalizedString(@"login_view_mail", nil);
        self.accountContent.placeholder = NSLocalizedString(@"login_view_mail_default", nil);
        self.accountContent.keyboardType = UIKeyboardTypeEmailAddress;
        
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = self.contentView.frame;
            frame.origin.y = self.areaButton.frame.origin.y;
            self.contentView.frame = frame;
            
            frame = self.areaButton.frame;
            frame.size.height = 0;
            self.areaButton.frame = frame;
        } completion:^(BOOL finished) {
            self.areaButton.hidden = YES;
        }];
    }
}

- (void)showTips:(NSString *)tips asError:(BOOL)error
{
    [self hideTips];
    self.errorTips = [IMErrorTips showTips:tips inView:self.view asError:error];
}

- (void)hideTips
{
    if (self.errorTips)
    {
        [self.errorTips removeFromSuperview];
        self.errorTips = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

- (void)overEdit
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.accountContent)
    {
        if (self.isPhoneLogin)
        {
            if ([TFTools validateMobile:self.accountContent.text])
            {
                [self hideTips];
            }
            else
            {
                [self showTips:NSLocalizedString(@"login_view_error_tip1", nil) asError:YES];
            }
        }
        else
        {
            if ([TFTools validateEmail:self.accountContent.text])
            {
                [self hideTips];
            }
            else
            {
                [self showTips:NSLocalizedString(@"login_view_error_tip2", nil) asError:YES];
            }
        }
    }
    
    if ([self.accountContent.text length] > 0 &&
        [self.passwordContent.text length] > 0 &&
        self.errorTips == nil)
    {
        self.loginButton.enabled = YES;
    }
    else
    {
        self.loginButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountContent)
    {
        [self.passwordContent becomeFirstResponder];
    }
    else
    {
        [self hideTips];
        [self.passwordContent resignFirstResponder];
        
        [self clickEnterButton];
    }
    return NO;
}

- (void)clickAreaButton
{
    AreaSelectViewController *viewController = [[AreaSelectViewController alloc] initWithNibName:nil bundle:nil];
    [self.parentViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)clickSwitchButton
{
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    viewController.isPhoneLogin = !self.isPhoneLogin;
    
    if (viewController.isPhoneLogin)
    {
        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"login_title_phone", nil) animated:NO];
    }
    else
    {
        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"login_title_mail", nil) animated:NO];
    }
    
}

- (void)clickForgotButton
{
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    
    FindPasswordViewController *viewController = [[FindPasswordViewController alloc] initWithNibName:nil bundle:nil];
    viewController.isPhoneFindPassword = self.isPhoneLogin;
    
    if (self.isPhoneLogin)
    {
        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"forgot_title1", nil) animated:YES];
    }
    else
    {
        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"forgot_title2", nil) animated:YES];
    }
}

- (void)clickEnterButton
{
    if (!self.loginButton.enabled)
    {
        return;
    }
    
    NSString *type = @"1";
    if (!self.isPhoneLogin)
    {
        type = @"2";
    }
    NSString *md5 = [TFTools md5:[self.accountContent.text stringByAppendingString:ENCODE_STRING]];
    NSDictionary *dic = @{@"code":md5,
                          @"type":type,
                          @"loginName":self.accountContent.text,
                          @"password":self.passwordContent.text};
    
    [[UserData sharedUserData] loginUserWithData:dic];
}

- (void)loginUserOK:(NSNotification *)notification
{
    NSDictionary *result = notification.userInfo;
    if (result)
    {
        NSString *errorString = result[@"error"];
        if ([errorString length] == 0)
        {
            IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
            [pVC backToMainView];
        }
        else
        {
            if ([errorString hasPrefix:@"10|"])
            {
                [self showTips:[errorString substringFromIndex:3] asError:YES];
            }
            if ([errorString hasPrefix:@"12|"])
            {
                [self showTips:[errorString substringFromIndex:3] asError:YES];
            }
            if ([errorString hasPrefix:@"11|"])
            {
                [self showTips:[errorString substringFromIndex:3] asError:NO];
            }
        }
    }
    else
    {
        [self showTips:NSLocalizedString(@"networking_error", nil) asError:YES];
        [self performSelector:@selector(hideTips) withObject:nil afterDelay:2.0f];
    }
}

@end
