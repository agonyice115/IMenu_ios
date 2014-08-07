//
//  RegisterPhoneViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-6.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "RegisterPhoneViewController.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "LoginButton.h"
#import "LongBarButton.h"
#import "IMPopViewController.h"
#import "VerificationCodeViewController.h"
#import "TFTools.h"
#import "Networking.h"
#import "ClauseViewController.h"
#import "AreaSelectViewController.h"
#import "ProgressView.h"
#import "IMErrorTips.h"
#import "IMWebViewController.h"
#import "KeyBoardCompleteView.h"

@interface RegisterPhoneViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneContent;
@property (nonatomic, strong) IMErrorTips *errorTips;
@property (nonatomic, strong) LoginButton *nextButton;

@end

@implementation RegisterPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        float height = self.view.bounds.size.height * 0.25f;
        
        // 添加地区选择
        LongBarButton *button = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        button.title.text = @"中国（+86）";
        [button setTarget:self action:@selector(clickAreaButton)];
        [self.view addSubview:button];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加密码输入
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
        phoneTitle.textAlignment = NSTextAlignmentLeft;
        phoneTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        phoneTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        phoneTitle.text = NSLocalizedString(@"register_view_phone", nil);
        [view addSubview:phoneTitle];
        
        self.phoneContent = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+80, 10, self.view.bounds.size.width-PAGE_MARGIN*2-80, 25)];
        self.phoneContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.phoneContent.textAlignment = NSTextAlignmentLeft;
        self.phoneContent.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.phoneContent.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.phoneContent.returnKeyType = UIReturnKeyDone;
        self.phoneContent.keyboardType = UIKeyboardTypePhonePad;
        self.phoneContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.phoneContent.placeholder = NSLocalizedString(@"register_view_phone_default", nil);
        self.phoneContent.delegate = self;
        [view addSubview:self.phoneContent];
        
        [self.view addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 10;
        
        UIButton *clauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clauseButton.frame = CGRectMake(PAGE_MARGIN, height, 20, 20);
        [clauseButton setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [clauseButton setImage:[UIImage imageNamed:@"check_highlight"] forState:UIControlStateSelected];
        [clauseButton addTarget:self action:@selector(clickIconButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clauseButton];
        
        clauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clauseButton.frame = CGRectMake(PAGE_MARGIN+22, height, self.view.bounds.size.width - PAGE_MARGIN*2-22, 20);
        clauseButton.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [clauseButton setTitleColor:[UIColor colorWithHtmlColor:@"#008fff"] forState:UIControlStateNormal];
        [clauseButton setTitleColor:[UIColor colorWithHtmlColor:@"#004888"] forState:UIControlStateHighlighted];
        [clauseButton setTitle:NSLocalizedString(@"register_view_clause", nil) forState:UIControlStateNormal];
        clauseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [clauseButton addTarget:self action:@selector(clickClauseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clauseButton];
        
        ProgressView *progressView = [[ProgressView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-36, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT - 15, 90, 3)];
        [progressView setProgress:0 ofTotal:3];
        [self.view addSubview:progressView];
        
        // 添加下一步按钮
        LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"register_view_next", nil) forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"next_normal"] forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"next_highlight"] forState:UIControlStateHighlighted];
        [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 20)];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [loginButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        self.nextButton = loginButton;
        
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

- (void)overEdit
{
    [self.view endEditing:YES];
}

- (void)clickAreaButton
{
    AreaSelectViewController *viewController = [[AreaSelectViewController alloc] initWithNibName:nil bundle:nil];
    [self.parentViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)clickIconButton:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    
    self.nextButton.enabled = !button.selected;
}

- (void)clickClauseButton
{
    IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
    viewController.bottomAnimation = NO;
    
    IMWebViewController *vc = [[IMWebViewController alloc] initWithNibName:nil bundle:nil];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"imenu_fuwu" ofType:@"html"];
    vc.url = [NSURL fileURLWithPath:filePath];
    [viewController setRootViewController:vc withTitle:@"服务条款" animated:NO];
    
    [self.parentViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([TFTools validateMobile:self.phoneContent.text])
    {
        [self hideTips];
    }
    else
    {
        [self showTips:NSLocalizedString(@"login_view_error_tip1", nil) asError:YES];
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

- (void)clickNextButton
{
    if (self.errorTips)
    {
        return;
    }
    
    NSString *phoneString = self.phoneContent.text;
    if (phoneString.length == 0)
    {
        return;
    }
    
    NSString *md5 = [TFTools md5:[phoneString stringByAppendingString:ENCODE_STRING]];
    NSDictionary *dic = @{@"areaCode":@"86", @"mobile":phoneString, @"code":md5};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"member/member/getVerifyCode" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    NSString *menuCode = resultData[@"menuCode"];
                    NSString *verifyCode = resultData[@"verifyCode"];
                    
                    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
                    [pVC hideCloseButton];
                    
                    VerificationCodeViewController *viewController = [[VerificationCodeViewController alloc] initWithNibName:nil bundle:nil];
                    viewController.isRegister = YES;
                    viewController.phone.text = [phoneString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    viewController.phoneString = phoneString;
                    viewController.areaCode = @"86";
                    viewController.menuCode = menuCode;
                    viewController.verifyCode = verifyCode;
                    [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"register_title1", nil) animated:YES];
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

@end
