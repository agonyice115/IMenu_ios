//
//  SecondaryViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-15.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SecondaryViewController.h"
#import "Common.h"
#import "IMConfig.h"

@interface SecondaryViewController ()

/**
 *  导航栏返回按钮
 */
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation SecondaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        [self.view addSubview:self.contentView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TOP_BAR_HEIGHT)];
        view.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowOpacity = 0.5;
        [self.view addSubview:view];
        
        self.navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 30.0f, self.view.bounds.size.width-2*PAGE_MARGIN, 25.0f)];
        self.navigationTitle.backgroundColor = [UIColor clearColor];
        self.navigationTitle.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        self.navigationTitle.textAlignment = NSTextAlignmentCenter;
        self.navigationTitle.textColor = [UIColor whiteColor];
        [view addSubview:self.navigationTitle];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame = CGRectMake(PAGE_MARGIN-11, 20.0f, 45.0f, 45.0f);
        [self.backButton setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
        [self.backButton addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.backButton];
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
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = 0.4f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [CATransaction commit];
}

@end
