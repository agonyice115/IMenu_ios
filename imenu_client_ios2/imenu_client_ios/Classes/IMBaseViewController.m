//
//  IMBaseViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-16.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMBaseViewController.h"
#import "IMErrorTips.h"

@interface IMBaseViewController ()

@property (nonatomic, strong) IMErrorTips *errorTips;

@end

@implementation IMBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_UNLOGIN;
        self.baseNavigationBarType = IM_NAVIGATION_BAR_TYPE_UNLOGIN;
        self.kindNavigationBarType = IM_NAVIGATION_BAR_TYPE_UNLOGIN;
        self.navigationTitle = @"你不应当看到我";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTips:(NSString *)tips
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTips) object:nil];
    
    [self hideTips];
    
    
    if ([tips hasPrefix:@"10|"])
    {
        self.errorTips = [IMErrorTips showTips:[tips substringFromIndex:3] inView:self.view asError:YES];
    }
    else if ([tips hasPrefix:@"11|"])
    {
        self.errorTips = [IMErrorTips showTips:[tips substringFromIndex:3] inView:self.view asError:NO];
    }
    else if ([tips hasPrefix:@"12|"])
    {
        self.errorTips = [IMErrorTips showTips:[tips substringFromIndex:3] inView:self.view asError:YES];
    }
    else if ([tips hasPrefix:@"13|"])
    {
        return;
    }
    else if ([tips hasPrefix:@"14|"])
    {
        return;
    }
    else if ([tips hasPrefix:@"20|"])
    {
        return;
    }
    else
    {
        self.errorTips = [IMErrorTips showTips:tips inView:self.view asError:YES];
    }
    
    [self performSelector:@selector(hideTips) withObject:nil afterDelay:2.0f];
}

- (void)hideTips
{
    if (self.errorTips)
    {
        [self.errorTips removeFromSuperview];
        self.errorTips = nil;
    }
}

- (BOOL)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId
{
    switch (navigationItemId)
    {
        case IM_NAVIGATION_ITEM_CLOSE:
            self.navigationBarType = self.baseNavigationBarType;
            [[self getIMNavigationController].navigationBarView setNavigationBarType:self.navigationBarType animated:YES fromTop:NO];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE:
            self.navigationBarType = IM_NAVIGATION_BAR_TYPE_SHARE;
            [[self getIMNavigationController].navigationBarView setNavigationBarType:self.navigationBarType animated:YES fromTop:YES];
            break;
            
        case IM_NAVIGATION_ITEM_SWITCH:
            self.navigationBarType = IM_NAVIGATION_BAR_TYPE_SWITCH;
            [[self getIMNavigationController].navigationBarView setNavigationBarType:self.navigationBarType animated:YES fromTop:YES];
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
}

- (IMNavigationController *)getIMNavigationController
{
    if (self.parentViewController)
    {
        return (IMNavigationController *)self.parentViewController;
    }
    
    return nil;
}

@end
