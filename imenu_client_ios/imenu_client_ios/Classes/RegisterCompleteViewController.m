//
//  RegisterCompleteViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-8.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "RegisterCompleteViewController.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "LoginButton.h"
#import "LongBarButton.h"
#import "HeadPicView.h"
#import "UserData.h"
#import "IMPopViewController.h"
#import "Networking.h"
#import "EditNickViewController.h"
#import "EditNameViewController.h"
#import "EditBirthdayViewController.h"
#import "EditSexViewController.h"
#import "AccountsViewController.h"
#import "TFTools.h"
#import "RegionSelectView.h"
#import "ClientConfig.h"

@interface RegisterCompleteViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RegionSelectViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) HeadPicView *headView;

@property (nonatomic, strong) LongBarButton *nick;
@property (nonatomic, strong) LongBarButton *name;
@property (nonatomic, strong) LongBarButton *birthday;
@property (nonatomic, strong) LongBarButton *sex;
@property (nonatomic, strong) LongBarButton *location;
@property (nonatomic, strong) LongBarButton *accounts;

@end

@implementation RegisterCompleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.scrollView];
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65.0f, self.view.bounds.size.width, 130)];
        self.photoView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.photoView];
        
        self.headView = [[HeadPicView alloc] initWithFrame:CGRectMake(105, 75.0f, 110, 110)];
        [self.headView setTarget:self action:@selector(clickHeadPic)];
        [self.scrollView addSubview:self.headView];
        
        float height = 195.0f;
        
        // 添加昵称
        self.nick = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.nick.title.text = NSLocalizedString(@"register_view_nick", nil);
        self.nick.subTitle.text = [UserData sharedUserData].memberName;
        [self.nick setTarget:self action:@selector(clickNick)];
        [self.scrollView addSubview:self.nick];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加真实姓名
        self.name = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.name.title.text = NSLocalizedString(@"register_view_name", nil);
        self.name.subTitle.text = [UserData sharedUserData].realname;
        [self.name setTarget:self action:@selector(clickName)];
        [self.scrollView addSubview:self.name];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加生日
        self.birthday = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.birthday.title.text = NSLocalizedString(@"register_view_birthday", nil);
        self.birthday.subTitle.text = [UserData sharedUserData].birthday;
        [self.birthday setTarget:self action:@selector(clickBirthday)];
        [self.scrollView addSubview:self.birthday];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加性别
        self.sex = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.sex.title.text = NSLocalizedString(@"register_view_sex", nil);
        if ([[UserData sharedUserData].sex isEqualToString:@"1"])
        {
            self.sex.subTitle.text = NSLocalizedString(@"sex_man", nil);;
        }
        else
        {
            self.sex.subTitle.text = NSLocalizedString(@"sex_woman", nil);;
        }
        [self.sex setTarget:self action:@selector(clickSex)];
        [self.scrollView addSubview:self.sex];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加所在地
        self.location = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.location.title.text = NSLocalizedString(@"register_view_local", nil);
        self.location.subTitle.text = [[ClientConfig sharedConfig] getRegionStringById:[UserData sharedUserData].regionId];
        [self.location setTarget:self action:@selector(clickLocation)];
        [self.scrollView addSubview:self.location];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加相关账户
        self.accounts = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.accounts.title.text = NSLocalizedString(@"register_view_accounts", nil);
        [self.accounts setTarget:self action:@selector(clickAccounts)];
        [self.scrollView addSubview:self.accounts];
        
        height += MIDDLE_BAR_HEIGHT + 50;
        
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, height + BOTTOM_BAR_HEIGHT);
        
        // 添加完成按钮
        LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"register_view_complete", nil) forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(clickCompleteButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
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

- (void)clickHeadPic
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"tip_button_camera", nil)
                                              otherButtonTitles:NSLocalizedString(@"tip_button_album", nil), nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)clickNick
{
    EditNickViewController *viewController = [[EditNickViewController alloc] initWithNibName:nil bundle:nil];
    viewController.oldText = [UserData sharedUserData].memberName;
    [self.parentViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)clickName
{
    EditNameViewController *viewController = [[EditNameViewController alloc] initWithNibName:nil bundle:nil];
    viewController.oldText = [UserData sharedUserData].realname;
    [self.parentViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)clickBirthday
{
    EditBirthdayViewController *viewController = [[EditBirthdayViewController alloc] initWithNibName:nil bundle:nil];
    viewController.oldText = [UserData sharedUserData].birthday;
    [self.parentViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)clickSex
{
    EditSexViewController *viewController = [[EditSexViewController alloc] initWithNibName:nil bundle:nil];
    viewController.oldText = [UserData sharedUserData].sex;
    [self.parentViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)clickLocation
{
    NSString *regionId = [UserData sharedUserData].regionId;
    if (!regionId || [regionId isEqualToString:@"0"])
    {
        regionId = [UserData sharedUserData].shopRegionId;
    }
    if (!regionId || [regionId isEqualToString:@"0"])
    {
        regionId = @"29";
    }
    RegionSelectView *view = [[RegionSelectView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    view.delegate = self;
    [view setCurrentId:regionId withData:[ClientConfig sharedConfig].regionFilterData];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)onSelectId:(NSString *)Id withData:(NSDictionary *)data by:(RegionSelectView *)filter
{
    NSString *regionId = [UserData sharedUserData].regionId;
    if (![regionId isEqualToString:Id])
    {
        NSDictionary *dic = @{@"memberId":[UserData sharedUserData].memberId,
                              @"regionId":Id};
        
        [[UserData sharedUserData] editUserInfo:dic];
    }
}

- (void)clickAccounts
{
    AccountsViewController *viewController = [[AccountsViewController alloc] initWithNibName:nil bundle:nil];
    
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = 0.4f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    
    [self.parentViewController presentViewController:viewController animated:NO completion:nil];
    
    [CATransaction commit];
}

- (void)clickCompleteButton
{
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    [pVC backToMainView];
}

- (void)editMemberInfoOK:(NSNotification *)notification
{
    NSDictionary *result = notification.userInfo;
    if (result)
    {
        NSString *errorString = result[@"error"];
        if ([errorString length] == 0)
        {
            [self setUserData];
        }
    }
}

- (void)setUserData
{
    self.nick.subTitle.text = [UserData sharedUserData].memberName;
    self.name.subTitle.text = [UserData sharedUserData].realname;
    self.birthday.subTitle.text = [UserData sharedUserData].birthday;
    self.location.subTitle.text = [[ClientConfig sharedConfig] getRegionStringById:[UserData sharedUserData].regionId];
    if ([[UserData sharedUserData].sex isEqualToString:@"1"])
    {
        self.sex.subTitle.text = NSLocalizedString(@"sex_man", nil);;
    }
    else
    {
        self.sex.subTitle.text = NSLocalizedString(@"sex_woman", nil);;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self.parentViewController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.headView.headPic = [TFTools reSizeImage:editedImage withSize:CGSizeMake(IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
