//
//  PersonalSettingViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-17.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "LongBarButton.h"
#import "HeadPicView.h"
#import "UserData.h"
#import "Networking.h"
#import "EditNickViewController.h"
#import "EditNameViewController.h"
#import "EditBirthdayViewController.h"
#import "EditSexViewController.h"
#import "EidtSignatureViewController.h"
#import "AccountsViewController.h"
#import "TFTools.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import "RegionSelectView.h"
#import "ClientConfig.h"

#define TOP_HEADER_VIEW_HEIGHT 130.0f

@interface PersonalSettingViewController () <UIScrollViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RegionSelectViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) HeadPicView *headPicView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) LongBarButton *nick;
@property (nonatomic, strong) LongBarButton *signature;
@property (nonatomic, strong) LongBarButton *name;
@property (nonatomic, strong) LongBarButton *birthday;
@property (nonatomic, strong) LongBarButton *sex;
@property (nonatomic, strong) LongBarButton *location;
@property (nonatomic, strong) LongBarButton *accounts;

@property (nonatomic, assign) BOOL isSetHeadPic;

@end

@implementation PersonalSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"setting_view_subtitle1", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       IMAGE_SIZE_BIG,
                                                                       IMAGE_SIZE_BIG)];
        self.photoView.userInteractionEnabled = YES;
        self.photoView.image = [UIImage imageNamed:@"default_user.png"];
        self.photoView.backgroundColor = [UIColor clearColor];
        NSString *url = [NSString stringWithFormat:@"%@%@", [UserData sharedUserData].dynamicLocation, [UserData sharedUserData].dynamicName];
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                                   options:0
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     if (finished && image)
                                                     {
                                                         self.photoView.image = image;
                                                     }
                                                 }];
        
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-160, 320, 320)];
        [self.headView addSubview:self.photoView];
        [self.view addSubview:self.headView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.photoView addGestureRecognizer:singleTap];
        
        float height = 110.0f;
        self.headPicView = [[HeadPicView alloc] initWithFrame:CGRectMake(height, height, 110, 110)];
        url = [NSString stringWithFormat:@"%@%@", [UserData sharedUserData].iconLocation, [UserData sharedUserData].iconName];
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                                   options:0
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     if (finished && image)
                                                     {
                                                         self.headPicView.headPic = image;
                                                     }
                                                 }];
        [self.headPicView setTarget:self action:@selector(clickHeadPic)];
        [self.headView addSubview:self.headPicView];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT,
                                                                         320,
                                                                         self.view.bounds.size.height-TOP_BAR_HEIGHT-TOP_HEADER_VIEW_HEIGHT)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
        
        height = 0.0f;
        
        // 添加昵称
        self.nick = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.nick.title.text = NSLocalizedString(@"register_view_nick", nil);
        self.nick.subTitle.text = [UserData sharedUserData].memberName;
        [self.nick setTarget:self action:@selector(clickNick)];
        [self.scrollView addSubview:self.nick];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 添加个性签名
        self.signature = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.signature.title.text = NSLocalizedString(@"register_view_signature", nil);
        self.signature.subTitle.text = [UserData sharedUserData].memberSignature;
        [self.signature setTarget:self action:@selector(clickSignature)];
        [self.scrollView addSubview:self.signature];
        
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
        
        UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height + BOTTOM_BAR_HEIGHT)];
        tableHeader.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        [self.scrollView addSubview:tableHeader];
        [self.scrollView sendSubviewToBack:tableHeader];
        
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
    self.isSetHeadPic = YES;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"tip_button_camera", nil)
                                              otherButtonTitles:NSLocalizedString(@"tip_button_album", nil), nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)handleTap:(UIGestureRecognizer *)tap
{
    self.isSetHeadPic = NO;
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

- (void)clickSignature
{
    EidtSignatureViewController *viewController = [[EidtSignatureViewController alloc] initWithNibName:nil bundle:nil];
    viewController.oldText = [UserData sharedUserData].memberSignature;
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
    self.signature.subTitle.text = [UserData sharedUserData].memberSignature;
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
    if (self.isSetHeadPic)
    {
        [self setHeadPicImage:info];
    }
    else
    {
        [self setPhotoImage:info];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setHeadPicImage:(NSDictionary *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.headPicView.headPic = [TFTools reSizeImage:editedImage withSize:CGSizeMake(IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE)];
    
    NSDictionary *dic = @{@"memberId":[UserData sharedUserData].memberId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"member/member/editMemberIcon" withToken:[UserData sharedUserData].token withImage:self.headPicView.headPic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *data = result[@"data"];
                    [UserData sharedUserData].iconLocation = data[@"iconLocation"];
                    [UserData sharedUserData].iconName = data[@"iconName"];
                    NSString *url = [NSString stringWithFormat:@"%@%@", data[@"iconLocation"], data[@"iconName"]];
                    [[SDImageCache sharedImageCache] storeImage:self.headPicView.headPic forKey:[[NSURL URLWithString:url] absoluteString]];
                }
                else
                {
                }
            }
        });
    });
}

- (void)setPhotoImage:(NSDictionary *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.photoView.image = [TFTools reSizeImage:editedImage withSize:CGSizeMake(IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
    
    NSDictionary *dic = @{@"memberId":[UserData sharedUserData].memberId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"member/member/editMemberDynamicImage"
                                          withToken:[UserData sharedUserData].token
                                          withImage:self.photoView.image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *data = result[@"data"];
                    [UserData sharedUserData].dynamicLocation = data[@"dynamicLocation"];
                    [UserData sharedUserData].dynamicName = data[@"dynamicName"];
                    NSString *url = [NSString stringWithFormat:@"%@%@", data[@"dynamicLocation"], data[@"dynamicName"]];
                    [[SDImageCache sharedImageCache] storeImage:self.photoView.image forKey:[[NSURL URLWithString:url] absoluteString]];
                }
                else
                {
                }
            }
        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        CGPoint center = self.headView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-scrollView.contentOffset.y)/2;
        self.headView.center = center;
    }
}

@end
