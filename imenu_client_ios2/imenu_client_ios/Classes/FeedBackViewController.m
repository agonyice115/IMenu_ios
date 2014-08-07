//
//  FeedBackViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "Networking.h"
#import "TFTools.h"
#import "LoginButton.h"
#import "UserData.h"
#import "FeedBackSelectView.h"

@interface FeedBackViewController () <UITextFieldDelegate, UITextViewDelegate, FeedBackSelectViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIView *personalInfoView;

@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UITextField *userPhone;
@property (nonatomic, strong) UITextField *userEmail;

@property (nonatomic, strong) UIImageView *userNameTips;
@property (nonatomic, strong) UIImageView *userPhoneTips;
@property (nonatomic, strong) UIImageView *userEmailTips;

@property (nonatomic, strong) UILabel *mainFeedbackLabel;
@property (nonatomic, strong) UILabel *subFeedbackLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textViewTip;

@property (nonatomic, strong) NSString *feedbackType;
@property (nonatomic, strong) NSString *feedbackId;

@property (nonatomic, strong) NSDictionary *mainType;
@property (nonatomic, strong) NSDictionary *subType;

@end

@implementation FeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = @"意见反馈";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createFeedBackView];
    [self createPersonalInfoView];
    
    LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width/2, BOTTOM_BAR_HEIGHT);
    [loginButton setTitle:@"提 交" forState:UIControlStateNormal];
    [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 10)];
    [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [loginButton addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width/2, BOTTOM_BAR_HEIGHT);
    [loginButton setTitle:@"重 写" forState:UIControlStateNormal];
    [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 10)];
    [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [loginButton addTarget:self action:@selector(clickRedo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // 添加底部按钮分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, 1, BOTTOM_BAR_HEIGHT)];
    view.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    [self.view addSubview:view];
}

- (void)createFeedBackView
{
    float height = TOP_BAR_HEIGHT + 20;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, 60, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"问题分类";
    [self.view addSubview:label];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+65, height, 320-PAGE_MARGIN*2-65, 30)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMainFeedBack)]];
    [self.view addSubview:view];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+70, height, 320-PAGE_MARGIN*2-110, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#888888"];
    label.text = @"点击选择问题分类";
    [self.view addSubview:label];
    self.mainFeedbackLabel = label;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320-PAGE_MARGIN-30, height+5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"right_more_normal@2x.png"];
    imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:imageView];
    
    height += 40;
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, 60, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"子分类";
    [self.view addSubview:label];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+65, height, 320-PAGE_MARGIN*2-65, 30)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSubFeedBack)]];
    [self.view addSubview:view];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+70, height, 320-PAGE_MARGIN*2-110, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#888888"];
    label.text = @"点击选择问题子分类";
    [self.view addSubview:label];
    self.subFeedbackLabel = label;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320-PAGE_MARGIN-30, height+5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"right_more_normal@2x.png"];
    imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:imageView];
    
    height += 50;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, 320-PAGE_MARGIN*2, self.view.bounds.size.height-BOTTOM_BAR_HEIGHT-190-height)];
    textView.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    textView.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 5.0f;
    textView.layer.masksToBounds = YES;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+5, height+2, 150, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"请输入您的反馈";
    [self.view addSubview:label];
    self.textViewTip = label;
}

- (void)createPersonalInfoView
{
    self.personalInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-BOTTOM_BAR_HEIGHT-171, 320, 170)];
    self.personalInfoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.personalInfoView];
    
    float height = 0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 3)];
    view.backgroundColor = [UIColor grayColor];
    [self.personalInfoView addSubview:view];
    
    height += 3;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 30)];
    view.backgroundColor = [UIColor colorWithHtmlColor:@"#dddddd"];
    [self.personalInfoView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"请输入您的个人信息";
    [view addSubview:label];
    
    height += 30;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    [self.personalInfoView addSubview:view];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"用户名";
    [view addSubview:label];
    
    self.userName = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+80, 10, self.view.bounds.size.width-PAGE_MARGIN*2-120, 25)];
    self.userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userName.textAlignment = NSTextAlignmentLeft;
    self.userName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    self.userName.textColor = [UIColor colorWithHtmlColor:@"#888888"];
    self.userName.returnKeyType = UIReturnKeyNext;
    self.userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userName.delegate = self;
    self.userName.text = [UserData sharedUserData].memberName;
    self.userName.userInteractionEnabled = NO;
    [view addSubview:self.userName];
    
    self.userNameTips = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-PAGE_MARGIN-20, 12, 20, 20)];
    self.userNameTips.image = [UIImage imageNamed:@"right.png"];
    [view addSubview:self.userNameTips];
    
    [self.personalInfoView addSubview:view];
    
    height += MIDDLE_BAR_HEIGHT + 1;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"手机";
    [view addSubview:label];
    
    self.userPhone = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+80, 10, self.view.bounds.size.width-PAGE_MARGIN*2-120, 25)];
    self.userPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userPhone.textAlignment = NSTextAlignmentLeft;
    self.userPhone.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    self.userPhone.textColor = [UIColor colorWithHtmlColor:@"#888888"];
    self.userPhone.returnKeyType = UIReturnKeyNext;
    self.userPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userPhone.delegate = self;
    self.userPhone.text = [[UserData sharedUserData].mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.userPhone.userInteractionEnabled = NO;
    [view addSubview:self.userPhone];
    
    self.userPhoneTips = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-PAGE_MARGIN-20, 12, 20, 20)];
    self.userPhoneTips.image = [UIImage imageNamed:@"right.png"];
    [view addSubview:self.userPhoneTips];
    
    [self.personalInfoView addSubview:view];
    
    height += MIDDLE_BAR_HEIGHT + 1;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 65, 25)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"邮箱";
    [view addSubview:label];
    
    self.userEmail = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+80, 10, self.view.bounds.size.width-PAGE_MARGIN*2-120, 25)];
    self.userEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userEmail.textAlignment = NSTextAlignmentLeft;
    self.userEmail.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    self.userEmail.textColor = [UIColor colorWithHtmlColor:@"#888888"];
    self.userEmail.returnKeyType = UIReturnKeyDone;
    self.userEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userEmail.userInteractionEnabled = NO;
    self.userEmail.delegate = self;
    [view addSubview:self.userEmail];
    
    self.userEmailTips = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-PAGE_MARGIN-20, 12, 20, 20)];
    [view addSubview:self.userEmailTips];
    
    if ([UserData sharedUserData].email && [UserData sharedUserData].email.length > 8)
    {
        self.userEmail.text = [[UserData sharedUserData].email stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.userEmailTips.image = [UIImage imageNamed:@"right.png"];
    }
    
    [self.personalInfoView addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickMainFeedBack
{
    FeedBackSelectView *view = [[FeedBackSelectView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [view setParentId:nil withLevel:1];
    view.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)clickSubFeedBack
{
    if (!self.mainType)
    {
        [self showTips:NSLocalizedString(@"feedback_view_error_tip1", nil)];
        return;
    }
    FeedBackSelectView *view = [[FeedBackSelectView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [view setParentId:self.mainType[@"feedback_id"] withLevel:2];
    view.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)onSelectData:(NSDictionary *)data withLevel:(int)level
{
    if (level == 1)
    {
        self.mainType = data;
        self.feedbackType = data[@"feedback_type"];
        self.mainFeedbackLabel.text = data[@"feedback_name"];
    }
    else
    {
        self.subType = data;
        self.feedbackId = data[@"feedback_id"];
        self.subFeedbackLabel.text = data[@"feedback_name"];
    }
}

- (void)clickSend
{
    if (!self.feedbackId || !self.feedbackType)
    {
        [self showTips:NSLocalizedString(@"feedback_view_error_tip1", nil)];
        return;
    }
    
    if (self.textView.text.length == 0)
    {
        [self showTips:NSLocalizedString(@"feedback_view_error_tip2", nil)];
        return;
    }
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"mobile":[UserData sharedUserData].mobile,
                          @"email":[UserData sharedUserData].email,
                          @"feedback_id":self.feedbackId,
                          @"feedback_type":self.feedbackType,
                          @"feedback_content":self.textView.text,
                          @"error_id":@""};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"base/feedback/submitFeedback"
                                          withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"感谢您的反馈，我们会尽快处理"
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                         destructiveButtonTitle:NSLocalizedString(@"tip_button_ok", nil)
                                                              otherButtonTitles:nil];
                    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                    [sheet showInView:[UIApplication sharedApplication].keyWindow];
                }
                else
                {
                    [self showTips:errorString];
                }
            }
            else
            {
                [self showTips:NSLocalizedString(@"networking_error", nil)];
            }
        });
    });
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOver:)]];
    [[self getIMNavigationController].view addSubview:view];
}

- (void)clickOver:(UIGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    [view removeFromSuperview];
    
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        self.textViewTip.hidden = YES;
    }
    else
    {
        self.textViewTip.hidden = NO;
    }
}

- (void)clickRedo
{
    self.mainFeedbackLabel.text = @"点击选择问题分类";
    self.mainFeedbackLabel.text = @"点击选择问题子分类";
    self.textView.text = @"";
    self.textViewTip.hidden = NO;
    self.mainType = nil;
    self.subType = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self clickRedo];
    [self.getIMNavigationController moveToPreViewControllerAnimated:YES];
}

@end
