//
//  RegisterFormViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-6.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "RegisterFormViewController.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "LoginButton.h"
#import "IMPopViewController.h"
#import "RegisterCompleteViewController.h"
#import "TFTools.h"
#import "Networking.h"
#import "UserData.h"
#import "ProgressView.h"
#import "IMErrorTips.h"
#import "IMConfig.h"
#import "KeyBoardCompleteView.h"

@interface RegisterFormViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *setPasswordTitle;
@property (nonatomic, strong) UITextField *setPasswordContent;
@property (nonatomic, strong) UIImageView *setPasswordTips;
@property (nonatomic, strong) UILabel *nickTitle;
@property (nonatomic, strong) UITextField *nickContent;
@property (nonatomic, strong) UIImageView *nickTips;
@property (nonatomic, strong) UILabel *sexTitle;
@property (nonatomic, assign) NSUInteger sex;
@property (nonatomic, strong) UIButton *manButton;
@property (nonatomic, strong) UIButton *womanButton;

@property (nonatomic, strong) IMErrorTips *errorTips;

@property (nonatomic, strong) NSString *verifyNickName;
@property (nonatomic, assign) BOOL isVerifyNick;
@property (nonatomic, assign) BOOL isComplete;

@end

@implementation RegisterFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        self.sex = 1;
        
        float height = self.view.bounds.size.height * 0.25f;
        
        // 添加设置密码
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.setPasswordTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
        self.setPasswordTitle.textAlignment = NSTextAlignmentLeft;
        self.setPasswordTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.setPasswordTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.setPasswordTitle.text = NSLocalizedString(@"register_view_password", nil);
        [view addSubview:self.setPasswordTitle];
        
        self.setPasswordContent = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+80, 10, self.view.bounds.size.width-PAGE_MARGIN*2-120, 25)];
        self.setPasswordContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.setPasswordContent.textAlignment = NSTextAlignmentLeft;
        self.setPasswordContent.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.setPasswordContent.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.setPasswordContent.returnKeyType = UIReturnKeyNext;
        self.setPasswordContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.setPasswordContent.secureTextEntry = YES;
        self.setPasswordContent.placeholder = NSLocalizedString(@"register_view_password_default", nil);
        self.setPasswordContent.delegate = self;
        [view addSubview:self.setPasswordContent];
        
        self.setPasswordTips = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-PAGE_MARGIN-20, 12, 20, 20)];
        [view addSubview:self.setPasswordTips];
        
        [self.view addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加昵称
        view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.nickTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
        self.nickTitle.textAlignment = NSTextAlignmentLeft;
        self.nickTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.nickTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.nickTitle.text = NSLocalizedString(@"register_view_nick", nil);
        [view addSubview:self.nickTitle];
        
        self.nickContent = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+80, 10, self.view.bounds.size.width-PAGE_MARGIN*2-120, 25)];
        self.nickContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.nickContent.textAlignment = NSTextAlignmentLeft;
        self.nickContent.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.nickContent.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.nickContent.returnKeyType = UIReturnKeyNext;
        self.nickContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.nickContent.placeholder = NSLocalizedString(@"register_view_nick_default", nil);
        self.nickContent.delegate = self;
        [view addSubview:self.nickContent];
        
        self.nickTips = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-PAGE_MARGIN-20, 12, 20, 20)];
        [view addSubview:self.nickTips];
        
        [self.view addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加性别
        view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.sexTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
        self.sexTitle.textAlignment = NSTextAlignmentLeft;
        self.sexTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.sexTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.sexTitle.text = NSLocalizedString(@"register_view_sex", nil);
        [view addSubview:self.sexTitle];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN+80, 12, 35, 24);
        [button setImage:[UIImage imageNamed:@"man_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"man_highlight"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickManButton) forControlEvents:UIControlEventTouchUpInside];
        button.selected = YES;
        [view addSubview:button];
        self.manButton = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN+140, 12, 35, 24);
        [button setImage:[UIImage imageNamed:@"women_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"women_highlight"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickWomanButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        self.womanButton = button;
        
        [self.view addSubview:view];
        
        ProgressView *progressView = [[ProgressView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-36, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT - 15, 90, 3)];
        [progressView setProgress:2 ofTotal:3];
        [self.view addSubview:progressView];
        
        // 添加完善信息按钮
        LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width/2, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"register_view_more", nil) forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"complete_normal"] forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"complete_highlight"] forState:UIControlStateHighlighted];
        [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 10)];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [loginButton addTarget:self action:@selector(clickCompleteButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        
        // 添加快速注册按钮
        loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width/2, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"register_view_register", nil) forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"next_normal"] forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"next_highlight"] forState:UIControlStateHighlighted];
        [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 10)];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [loginButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerUserOK:) name:@"registerUserOK" object:nil];
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
    if (textField == self.setPasswordContent)
    {
        if ([self.setPasswordContent.text length] < 6 || [self.setPasswordContent.text length] > 32)
        {
            self.setPasswordTips.image = [UIImage imageNamed:@"error.png"];
        }
        else
        {
            self.setPasswordTips.image = [UIImage imageNamed:@"right.png"];
        }
    }
    else
    {
        if ([self.nickContent.text length] < 2 || [self.nickContent.text length] > 10)
        {
            self.nickTips.image = [UIImage imageNamed:@"error.png"];
            self.verifyNickName = nil;
        }
        else
        {
            self.nickTips.image = [UIImage imageNamed:@"right.png"];
            [self verifyNick];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.setPasswordContent)
    {
        [self.nickContent becomeFirstResponder];
    }
    else
    {
        [self.nickContent resignFirstResponder];
    }
    return NO;
}

- (void)clickManButton
{
    if (self.sex == 1)
    {
        return;
    }
    
    self.sex = 1;
    self.manButton.selected = YES;
    self.womanButton.selected = NO;
}

- (void)clickWomanButton
{
    if (self.sex == 2)
    {
        return;
    }
    
    self.sex = 2;
    self.manButton.selected = NO;
    self.womanButton.selected = YES;
}

- (void)clickCompleteButton
{
    [self registerUser:YES];
}

- (void)clickNextButton
{
    [self registerUser:NO];
}

- (void)verifyNick
{
    if (self.verifyNickName && [self.verifyNickName isEqualToString:self.nickContent.text])
    {
        return;
    }
    
    if (self.isVerifyNick)
    {
        return;
    }
    
    self.verifyNickName = self.nickContent.text;
    
    self.isVerifyNick = YES;
    
    NSString *md5 = [TFTools md5:[self.menuCode stringByAppendingString:ENCODE_STRING]];
    NSDictionary *dic = @{@"menuCode":md5,
                          @"memberName":self.verifyNickName};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"member/member/validateMemberName" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isVerifyNick = NO;
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] != 0)
                {
                    if ([self.verifyNickName isEqualToString:self.nickContent.text])
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
                        self.nickTips.image = [UIImage imageNamed:@"error.png"];
                    }
                }
                else
                {
                    [self hideTips];
                }
                
                [self verifyNick];
            }
        });
    });
}

- (void)registerUser:(BOOL)isComplete
{
    if ([self.setPasswordContent.text length] < 6)
    {
        [self showTips:NSLocalizedString(@"register_view_error_tip2", nil) asError:YES];
        return;
    }
    
    if (self.verifyNickName == nil)
    {
        [self showTips:NSLocalizedString(@"register_view_error_tip1", nil) asError:YES];
        return;
    }
    
    if (self.isVerifyNick)
    {
        [self showTips:NSLocalizedString(@"register_view_error_tip3", nil) asError:YES];
        return;
    }
    
    self.isComplete = isComplete;
    
    NSString *md5 = [TFTools md5:[self.menuCode stringByAppendingString:ENCODE_STRING]];
    NSDictionary *dic = @{@"areaCode":@"86",
                          @"mobile":self.phoneString,
                          @"menuCode":md5,
                          @"password":self.setPasswordContent.text,
                          @"memberName":self.verifyNickName,
                          @"sex":[NSString stringWithFormat:@"%d", self.sex]};
    
    [[UserData sharedUserData] registerUserWithData:dic];
}

- (void)registerUserOK:(NSNotification *)notification
{
    NSDictionary *result = notification.userInfo;
    if (result)
    {
        NSString *errorString = result[@"error"];
        if ([errorString length] == 0)
        {
            [[IMConfig sharedConfig] setSexColor:[UserData sharedUserData].sex];
            IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
            
            if (self.isComplete)
            {
                RegisterCompleteViewController *viewController = [[RegisterCompleteViewController alloc] initWithNibName:nil bundle:nil];
                [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"register_title4", nil) animated:YES];
            }
            else
            {
                [pVC backToMainView];
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
}

@end
