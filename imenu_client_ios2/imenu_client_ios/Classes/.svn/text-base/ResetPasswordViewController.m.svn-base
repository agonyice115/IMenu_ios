//
//  ResetPasswordViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-6.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "LoginButton.h"
#import "IMPopViewController.h"
#import "TFTools.h"
#import "Networking.h"
#import "ProgressView.h"
#import "UserData.h"
#import "IMErrorTips.h"
#import "KeyBoardCompleteView.h"

@interface ResetPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *verifyPassword;

@property (nonatomic, strong) IMErrorTips *errorTips;

@end

@implementation ResetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        float height = self.view.bounds.size.height * 0.25f;
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height - 30, self.view.bounds.size.width-PAGE_MARGIN*2, 20)];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = NSLocalizedString(@"forgot_view_phone_tip3", nil);
        tip.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        tip.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:tip];
        
        // 添加密码输入
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, self.view.bounds.size.width-PAGE_MARGIN*2, 25)];
        self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.password.textAlignment = NSTextAlignmentLeft;
        self.password.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.password.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.password.returnKeyType = UIReturnKeyNext;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.password.secureTextEntry = YES;
        self.password.placeholder = NSLocalizedString(@"forgot_view_phone_default2", nil);
        self.password.delegate = self;
        [view addSubview:self.password];
        
        [self.view addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        // 添加密码校验
        view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.verifyPassword = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, self.view.bounds.size.width-PAGE_MARGIN*2, 25)];
        self.verifyPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.verifyPassword.textAlignment = NSTextAlignmentLeft;
        self.verifyPassword.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.verifyPassword.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.verifyPassword.returnKeyType = UIReturnKeyDone;
        self.verifyPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.verifyPassword.secureTextEntry = YES;
        self.verifyPassword.placeholder = NSLocalizedString(@"forgot_view_phone_default3", nil);
        self.verifyPassword.delegate = self;
        [view addSubview:self.verifyPassword];
        
        [self.view addSubview:view];
        
        ProgressView *progressView = [[ProgressView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-36, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT - 15, 90, 3)];
        [progressView setProgress:2 ofTotal:3];
        [self.view addSubview:progressView];
        
        // 添加完成按钮
        LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"forgot_view_phone_complete", nil) forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(clickCompleteButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUserPasswordOK:) name:@"resetUserPasswordOK" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (textField == self.verifyPassword)
    {
        if (![self.password.text isEqualToString:self.verifyPassword.text])
        {
            [self showTips:NSLocalizedString(@"forgot_view_error_tip4", nil) asError:YES];
        }
        else
        {
            [self hideTips];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.password)
    {
        [self.verifyPassword becomeFirstResponder];
    }
    else
    {
        [self.verifyPassword resignFirstResponder];
        
        [self clickCompleteButton];
    }
    return NO;
}

- (void)clickCompleteButton
{
    if (![self.password.text isEqualToString:self.verifyPassword.text])
    {
        [self showTips:NSLocalizedString(@"forgot_view_error_tip4", nil) asError:YES];
        return;
    }
    
    if ([self.password.text length] < 6 || [self.password.text length] > 32)
    {
        [self showTips:NSLocalizedString(@"forgot_view_error_tip3", nil) asError:YES];
        return;
    }
    
    NSString *md5 = [TFTools md5:[self.menuCode stringByAppendingString:ENCODE_STRING]];
    NSDictionary *dic = @{@"menuCode":md5,
                          @"type":@"1",
                          @"loginName":self.phoneString,
                          @"newPassword":self.password.text};
    
    [[UserData sharedUserData] resetUserPasswordWithData:dic];
}

- (void)resetUserPasswordOK:(NSNotification *)notification
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
