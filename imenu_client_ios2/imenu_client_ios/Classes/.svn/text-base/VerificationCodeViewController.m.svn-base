//
//  VerificationCodeViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-5.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "VerificationCodeViewController.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "LoginButton.h"
#import "IMPopViewController.h"
#import "ResetPasswordViewController.h"
#import "RegisterFormViewController.h"
#import "TFTools.h"
#import "Networking.h"
#import "ProgressView.h"
#import "KeyBoardCompleteView.h"

@interface VerificationCodeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *verificationCode;
@property (nonatomic, strong) UIImageView *verificationCodeTips;
@property (nonatomic, strong) UILabel *timerTips;
@property (nonatomic, strong) UILabel *timer;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) LoginButton *resendButton;
@property (nonatomic, strong) LoginButton *nextButton;

@end

@implementation VerificationCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        self.seconds = 30;
        
        float height = self.view.bounds.size.height * 0.25f;
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height - 30, SECOND_FONT_SIZE*11, 20)];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = NSLocalizedString(@"forgot_view_phone_tip1", nil);
        tip.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        tip.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:tip];
        
        self.phone = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+SECOND_FONT_SIZE*11, height-30, self.view.bounds.size.width-PAGE_MARGIN*2-SECOND_FONT_SIZE*11, 20)];
        self.phone.backgroundColor = [UIColor clearColor];
        self.phone.text = @"138****3829";
        self.phone.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.phone.textColor = [UIColor colorWithHtmlColor:@"#008fff"];
        [self.view addSubview:self.phone];
        
        // 添加验证码输入
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.verificationCode = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, self.view.bounds.size.width-PAGE_MARGIN*2-20, 25)];
        self.verificationCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.verificationCode.textAlignment = NSTextAlignmentLeft;
        self.verificationCode.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.verificationCode.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.verificationCode.returnKeyType = UIReturnKeyDone;
        self.verificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.verificationCode.placeholder = NSLocalizedString(@"forgot_view_phone_default1", nil);
        self.verificationCode.keyboardType = UIKeyboardTypeNumberPad;
        self.verificationCode.delegate = self;
        [view addSubview:self.verificationCode];
        
        self.verificationCodeTips = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-PAGE_MARGIN-20, 12, 20, 20)];
        [view addSubview:self.verificationCodeTips];
        
        [self.view addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 10;
        // 添加验证码重新获取倒计时
        tip = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, self.view.bounds.size.width-PAGE_MARGIN*2, 20)];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = NSLocalizedString(@"forgot_view_phone_tip2", nil);
        tip.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        tip.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:tip];
        self.timerTips = tip;
        
        self.timer = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+SECOND_FONT_SIZE*4, height, SECOND_FONT_SIZE*2, 20)];
        self.timer.backgroundColor = [UIColor clearColor];
        self.timer.text = @"60";
        self.timer.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.timer.textColor = [UIColor colorWithHtmlColor:@"#008fff"];
        self.timer.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.timer];
        
        ProgressView *progressView = [[ProgressView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-36, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT - 15, 90, 3)];
        [progressView setProgress:1 ofTotal:3];
        [self.view addSubview:progressView];
        
        // 添加重新发送按钮
        LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width/2, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"forgot_view_phone_resend", nil) forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"resend_normal"] forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"resend_highlight"] forState:UIControlStateHighlighted];
        [loginButton setImage:[UIImage imageNamed:@"resend_disabled"] forState:UIControlStateDisabled];
        [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 10)];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        loginButton.enabled = NO;
        [loginButton addTarget:self action:@selector(clickResendButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        self.resendButton = loginButton;
        
        // 添加下一步按钮
        loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width/2, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"forgot_view_phone_next", nil) forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"next_normal"] forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"next_highlight"] forState:UIControlStateHighlighted];
        [loginButton setImage:[UIImage imageNamed:@"next_disabled"] forState:UIControlStateDisabled];
        [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 10)];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        loginButton.enabled = NO;
        [loginButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        self.nextButton = loginButton;
        
        // 添加底部按钮分割线
        view = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, 1, BOTTOM_BAR_HEIGHT)];
        view.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [self.view addSubview:view];
        
        KeyBoardCompleteView *completeView = [[KeyBoardCompleteView alloc] initWithFrame:CGRectMake(0, 600, 320, 30)];
        [completeView.completeButton addTarget:self action:@selector(overEdit) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:completeView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
    
#if DEBUG
    if ([self.verificationCode.text length] == 0)
    {
        self.verificationCode.text = self.verifyCode;
    }
#endif
}

- (void)overEdit
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.verificationCode)
    {
        if ([self.verificationCode.text isEqualToString:self.verifyCode])
        {
            self.verificationCodeTips.image = [UIImage imageNamed:@"right.png"];
            self.nextButton.enabled = YES;
        }
        else
        {
            self.verificationCodeTips.image = [UIImage imageNamed:@"error.png"];
            self.nextButton.enabled = NO;
        }
    }
}

- (void)startTimer
{
    self.seconds = 30;
    self.resendButton.enabled = NO;
    self.timer.hidden = NO;
    self.timerTips.hidden = NO;
    
    self.timer.text = [NSString stringWithFormat:@"%d", self.seconds];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
}

- (void)timerFire:(NSTimer *)timer
{
    self.seconds--;
    
    if (self.seconds <= 0)
    {
        self.seconds = 0;
        [timer invalidate];
        self.resendButton.enabled = YES;
        self.timer.hidden = YES;
        self.timerTips.hidden = YES;
    }
    
    self.timer.text = [NSString stringWithFormat:@"%d", self.seconds];
}

- (void)clickResendButton
{
    NSString *md5 = [TFTools md5:[self.phoneString stringByAppendingString:ENCODE_STRING]];
    
    if (self.isRegister)
    {
        NSDictionary *dic = @{@"areaCode":@"86", @"mobile":self.phoneString, @"code":md5};
        
        dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(downloadQueue, ^{
            NSDictionary *result = [Networking postData:dic withRoute:@"member/member/getVerifyCode" withToken:@""];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result)
                {
                    NSString *errorString = result[@"error"];
                    if ([errorString length] == 0)
                    {
                        //NSString *successString = result[@"success"];
                        NSDictionary *resultData = result[@"data"];
                        NSString *menuCode = resultData[@"menuCode"];
                        NSString *verifyCode = resultData[@"verifyCode"];
                        
                        self.menuCode = menuCode;
                        self.verifyCode = verifyCode;
                        
                        [self startTimer];
                    }
                }
            });
        });
    }
    else
    {
        NSDictionary *dic = @{@"type":@"1",
                              @"loginName":self.phoneString,
                              @"code":md5};
        
        dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(downloadQueue, ^{
            NSDictionary *result = [Networking postData:dic withRoute:@"member/member/forgetPassword" withToken:@""];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result)
                {
                    NSString *errorString = result[@"error"];
                    if ([errorString length] == 0)
                    {
                        //NSString *successString = result[@"success"];
                        NSDictionary *resultData = result[@"data"];
                        if (resultData && [resultData isKindOfClass:[NSDictionary class]])
                        {
                            NSString *menuCode = resultData[@"menuCode"];
                            NSString *verifyCode = resultData[@"verifyCode"];
                            
                            self.menuCode = menuCode;
                            self.verifyCode = verifyCode;
                            
                            [self startTimer];
                        }
                    }
                }
            });
        });
    }
}

- (void)clickNextButton
{
    if (!self.nextButton.enabled)
    {
        return;
    }
    
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    
    if (self.isRegister)
    {
        RegisterFormViewController *viewController = [[RegisterFormViewController alloc] initWithNibName:nil bundle:nil];
        viewController.phoneString = self.phoneString;
        viewController.areaCode = self.areaCode;
        viewController.menuCode = self.menuCode;
        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"register_title1", nil) animated:YES];
    }
    else
    {
        ResetPasswordViewController *viewController = [[ResetPasswordViewController alloc] initWithNibName:nil bundle:nil];
        viewController.phoneString = self.phoneString;
        viewController.areaCode = self.areaCode;
        viewController.menuCode = self.menuCode;
        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"forgot_title3", nil) animated:YES];
    }
}

@end
