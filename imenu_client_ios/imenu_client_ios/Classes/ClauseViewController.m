//
//  ClauseViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-6.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ClauseViewController.h"
#import "LoginAndRegisterNavigationBar.h"
#import "Common.h"
#import "IMConfig.h"
#import "UIColor+HtmlColor.h"

@interface ClauseViewController ()

@property (nonatomic, strong) LoginAndRegisterNavigationBar *navigationBarView;

@end

@implementation ClauseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        self.navigationBarView = [[LoginAndRegisterNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, TOP_BAR_HEIGHT)];
        self.navigationBarView.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        [self.view addSubview:self.navigationBarView];
        
        self.navigationBarView.title.textColor = [IMConfig sharedConfig].fgColor;
        self.navigationBarView.title.text = NSLocalizedString(@"register_title3", nil);
        [self.navigationBarView.closeButton addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
        
        float height = TOP_BAR_HEIGHT + 30;
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, self.view.bounds.size.width-PAGE_MARGIN*2, 20)];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = @"微点软件许可及服务协议";
        tip.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        tip.textColor = [UIColor colorWithHtmlColor:@"#000000"];
        [self.view addSubview:tip];
        
        height += 40;
        tip = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, self.view.bounds.size.width-PAGE_MARGIN*2, 20)];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = @"欢迎您使用微点软件及服务！";
        tip.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        tip.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:tip];
        
        height += 40;
        tip = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, self.view.bounds.size.width-PAGE_MARGIN*2, 240)];
        tip.backgroundColor = [UIColor clearColor];
        tip.text = @"为使用微点软件（以下简称“本软件”）及服务，您应当阅读并遵守《微点软件许可及服务协议》（以下简称“本协议”），以及《微点服务协议》和《微点号码规则》。请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制责任的条款，以及开通或使用某项服务的单独协议，并选择接受或不接受。限制、免责条款可能以加粗形式提示您注意。\n\n除非您已阅读并接受本协议所有条款，否则您无权下载、安装或使用本软件及相关服务。您的下载、安装、使用、获取微信帐号、登录等行为即视为您已阅读并同意上述协议的约束。\n\n如果您未满18周岁，请在法定监护人的陪同下阅读本协议及其他上述协议，并特别注意未成年人使用条款。";
        tip.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        tip.numberOfLines = 0;
        tip.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:tip];
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

- (void)backToMainView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
