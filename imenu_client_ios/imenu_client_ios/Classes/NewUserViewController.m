//
//  NewUserViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "NewUserViewController.h"
#import "ClientConfig.h"
#import "CartData.h"
#import "Networking.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(320*4, self.view.bounds.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i = 1; i < 5; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"new_user_%d.png", i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320-320, 0, 320, self.view.bounds.size.height)];
        imageView.image = [UIImage imageNamed:fileName];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [scrollView addSubview:imageView];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(3*320+60, 400, 200, 100);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated
{
    [CartData sharedCartData];
    [ClientConfig sharedConfig];
    [[Networking sharedNetworking] startNetCheck];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickStart
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1.0" forKey:@"NewUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newUserStart" object:nil];
}

@end
