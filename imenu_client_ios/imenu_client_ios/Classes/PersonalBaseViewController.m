//
//  PersonalBaseViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-14.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "PersonalBaseViewController.h"
#import "Common.h"
#import "IMConfig.h"

@interface PersonalBaseViewController ()

@end

@implementation PersonalBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        [self.view addSubview:self.contentView];
        
        self.navigationBarView = [[LoginAndRegisterNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, TOP_BAR_HEIGHT)];
        self.navigationBarView.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        self.navigationBarView.title.textColor = [IMConfig sharedConfig].fgColor;
        [self.navigationBarView.closeButton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        [self.navigationBarView.closeButton setImage:[UIImage imageNamed:@"select_highlight"] forState:UIControlStateHighlighted];
        [self.navigationBarView.closeButton addTarget:self action:@selector(didEditPersonalInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.navigationBarView];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didEditPersonalInfo
{
    NSLog(@"didEditPersonalInfo of PersonalBaseViewController");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
