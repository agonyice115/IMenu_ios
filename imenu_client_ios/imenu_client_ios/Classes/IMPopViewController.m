//
//  LoginAndRegisterMainViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-3.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMPopViewController.h"
#import "LoginAndRegisterNavigationBar.h"
#import "IMConfig.h"
#import "Common.h"
#import "IMLoadingView.h"

@interface IMPopViewController ()

@property (nonatomic, strong) LoginAndRegisterNavigationBar *navigationBarView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bottomAnimationView;

/**
 *  当前内容视图
 */
@property (nonatomic, strong) UIViewController *currentContentViewController;

@end

@implementation IMPopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.contentView];
        
        self.navigationBarView = [[LoginAndRegisterNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, TOP_BAR_HEIGHT)];
        self.navigationBarView.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        [self.view addSubview:self.navigationBarView];
        
        self.navigationBarView.title.textColor = [IMConfig sharedConfig].fgColor;
        [self.navigationBarView.closeButton addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
        
        self.bottomAnimationView = [[UIView alloc] initWithFrame:CGRectMake(-960, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT - 1, 1280, 1)];
        for (int i = 0; i < 2; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*640, 0, 640, 1)];
            imageView.image = [UIImage imageNamed:@"color_bar.png"];
            [self.bottomAnimationView addSubview:imageView];
        }
        self.bottomAnimationView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.bottomAnimationView.layer.shadowOffset = CGSizeMake(0, -1.0f);
        self.bottomAnimationView.layer.shadowOpacity = 0.5f;
        [self.view addSubview:self.bottomAnimationView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.bottomAnimation)
    {
        self.bottomAnimationView.hidden = NO;
        [self startAnimation];
    }
    else
    {
        self.bottomAnimationView.hidden = YES;
    }
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

- (void)setBottomAnimation:(BOOL)bottomAnimation
{
    _bottomAnimation = bottomAnimation;
    
    if (bottomAnimation)
    {
        self.bottomAnimationView.hidden = NO;
        [self startAnimation];
    }
    else
    {
        self.bottomAnimationView.hidden = YES;
    }
}

- (void)backToMainView
{
    [IMLoadingView hideLoading];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideCloseButton
{
    self.navigationBarView.closeButton.hidden = YES;
}

- (void)showInfoButtonWithTarget:(id)target action:(SEL)action
{
    [self.navigationBarView.closeButton removeTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView.closeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView.closeButton setImage:[UIImage imageNamed:@"info_highlight"] forState:UIControlStateNormal];
    [self.navigationBarView.closeButton setImage:[UIImage imageNamed:@"info_normal"] forState:UIControlStateHighlighted];
}

- (void)startAnimation
{
    self.bottomAnimationView.frame = CGRectMake(-960, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT - 1, 640, 1);
    [UIView animateWithDuration:20 delay:1 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
        self.bottomAnimationView.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT - 1, 640, 1);
    } completion:nil];
}

- (void)setRootViewController:(UIViewController *)viewController withTitle:(NSString *)title animated:(BOOL)flag
{
    [self addChildViewController:viewController];
    viewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    if (flag && self.currentContentViewController != nil)
    {
        CGRect frame = self.currentContentViewController.view.frame;
        frame.origin.x += frame.size.width;
        viewController.view.frame = frame;
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.currentContentViewController.view.frame;
            viewController.view.frame = frame;
            
            frame.origin.x -= frame.size.width;
            self.currentContentViewController.view.frame = frame;
        } completion:^(BOOL finished) {
            [self.currentContentViewController willMoveToParentViewController:nil];
            [self.currentContentViewController.view removeFromSuperview];
            [self.currentContentViewController removeFromParentViewController];
            
            self.currentContentViewController = viewController;
            [self.navigationBarView switchTitle:title];
        }];
    }
    else
    {
        if (self.currentContentViewController != nil)
        {
            [self.currentContentViewController willMoveToParentViewController:nil];
            [self.currentContentViewController.view removeFromSuperview];
            [self.currentContentViewController removeFromParentViewController];
        }
        
        self.currentContentViewController = viewController;
        self.navigationBarView.title.text = title;
    }
}

@end
