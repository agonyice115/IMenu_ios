//
//  FindPasswordViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-5.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "LoginButton.h"
#import "IMPopViewController.h"
#import "VerificationCodeViewController.h"
#import "TFTools.h"
#import "Networking.h"
#import "IMTipView.h"
#import "ProgressView.h"
#import "IMErrorTips.h"
#import "KeyBoardCompleteView.h"

@interface FindPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *accountTitle;
@property (nonatomic, strong) UITextField *accountContent;

@property (nonatomic, strong) IMErrorTips *errorTips;

@property (nonatomic, strong) LoginButton *loginButton;

@end

@implementation FindPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        float height = self.view.bounds.size.height * 0.25f;
        
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
        self.accountContent.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.accountContent.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.accountContent.returnKeyType = UIReturnKeyDone;
        self.accountContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.accountContent.delegate = self;
        [view addSubview:self.accountContent];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.view.bounds.size.width-23-PAGE_MARGIN, 12, 23, 23);
        [button setImage:[UIImage imageNamed:@"switch_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"switch_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickSwitchButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [self.view addSubview:view];
        
        ProgressView *progressView = [[ProgressView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-36, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT - 15, 90, 3)];
        [progressView setProgress:0 ofTotal:3];
        [self.view addSubview:progressView];
        
        // 添加确认按钮
        self.loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width, BOTTOM_BAR_HEIGHT);
        [self.loginButton setTitle:NSLocalizedString(@"forgot_view_phone_confirm", nil) forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@"enter_normal"] forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@"enter_highlight"] forState:UIControlStateHighlighted];
        [self.loginButton setImage:[UIImage imageNamed:@"enter_highlight"] forState:UIControlStateDisabled];
        [self.loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 20)];
        [self.loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.loginButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
        self.loginButton.enabled = NO;
        [self.view addSubview:self.loginButton];
        
        KeyBoardCompleteView *completeView = [[KeyBoardCompleteView alloc] initWithFrame:CGRectMake(0, 600, 320, 30)];
        [completeView.completeButton addTarget:self action:@selector(overEdit) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:completeView];
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
        if (self.isPhoneFindPassword)
        {
            if ([TFTools validateMobile:self.accountContent.text])
            {
                [self hideTips];
            }
            else
            {
                [self showTips:NSLocalizedString(@"forgot_view_error_tip1", nil) asError:YES];
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
                [self showTips:NSLocalizedString(@"forgot_view_error_tip2", nil) asError:YES];
            }
        }
    }
    
    if ([self.accountContent.text length] > 0 &&
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
        [self.accountContent resignFirstResponder];
        
        [self clickConfirmButton];
    }
    return NO;
}

- (void)setIsPhoneFindPassword:(BOOL)isPhoneFindPassword
{
    _isPhoneFindPassword = isPhoneFindPassword;
    
    if (isPhoneFindPassword)
    {
        self.accountTitle.text = NSLocalizedString(@"forgot_view_phone", nil);
        self.accountContent.placeholder = NSLocalizedString(@"forgot_view_phone_default", nil);
        self.accountContent.keyboardType = UIKeyboardTypePhonePad;
    }
    else
    {
        self.accountTitle.text = NSLocalizedString(@"forgot_view_mail", nil);
        self.accountContent.placeholder = NSLocalizedString(@"forgot_view_mail_default", nil);
        self.accountContent.keyboardType = UIKeyboardTypeEmailAddress;
    }
}

- (void)clickSwitchButton
{
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    
    FindPasswordViewController *viewController = [[FindPasswordViewController alloc] initWithNibName:nil bundle:nil];
    viewController.isPhoneFindPassword = !self.isPhoneFindPassword;
    
    if (viewController.isPhoneFindPassword)
    {
        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"forgot_title1", nil) animated:NO];
    }
    else
    {
        [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"forgot_title2", nil) animated:NO];
    }
    
}

- (void)clickConfirmButton
{
    if (!self.loginButton.enabled)
    {
        return;
    }
    
    NSString *md5 = [TFTools md5:[self.accountContent.text stringByAppendingString:ENCODE_STRING]];
    
    if (self.isPhoneFindPassword)
    {
        NSDictionary *dic = @{@"type":@"1",
                              @"loginName":self.accountContent.text,
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
                            
                            IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
                            
                            VerificationCodeViewController *viewController = [[VerificationCodeViewController alloc] initWithNibName:nil bundle:nil];
                            viewController.isRegister = NO;
                            viewController.phone.text = [self.accountContent.text stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                            viewController.phoneString = self.accountContent.text;
                            viewController.areaCode = @"86";
                            viewController.menuCode = menuCode;
                            viewController.verifyCode = verifyCode;
                            [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"register_title1", nil) animated:YES];
                        }
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
            });
        });
    }
    else
    {
        NSDictionary *dic = @{@"type":@"2",
                              @"loginName":self.accountContent.text,
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
                        NSString *successString = result[@"success"];
                        
                        IMTipView *tip = [[IMTipView alloc] initWithFrame:self.view.bounds];
                        tip.tips.text = successString;
                        [self.view addSubview:tip];
                    }
                }
            });
        });
    }
}

@end
