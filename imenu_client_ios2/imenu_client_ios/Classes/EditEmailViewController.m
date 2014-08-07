//
//  EditEmailViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-15.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "EditEmailViewController.h"
#import "UserData.h"

@interface EditEmailViewController ()

@end

@implementation EditEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationBarView.title.text = NSLocalizedString(@"register_view_mail", nil);
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

- (void)didEditPersonalInfo
{
    if ([self.oldText isEqualToString:self.textContent.text])
    {
        [super didEditPersonalInfo];
    }
    else
    {
        [self editEmail];
    }
}

- (void)editEmail
{
    NSDictionary *dic = @{@"memberId":[UserData sharedUserData].memberId,
                          @"email":self.textContent.text};
    
    [[UserData sharedUserData] editUserInfo:dic];
}

- (void)editMemberInfoOK:(NSNotification *)notification
{
    NSDictionary *result = notification.userInfo;
    if (result)
    {
        NSString *errorString = result[@"error"];
        if ([errorString length] == 0)
        {
            [super didEditPersonalInfo];
        }
        else
        {
            if ([errorString hasPrefix:@"10|"] || [errorString hasPrefix:@"12|"])
            {
                self.errorTips.text = [errorString substringFromIndex:3];
            }
        }
    }
    else
    {
        self.errorTips.text = NSLocalizedString(@"networking_error", nil);
    }
}

@end
