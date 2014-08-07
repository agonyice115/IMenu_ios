//
//  FansViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FansViewController.h"
#import "FollowUserViewController.h"

@interface FansViewController ()

@property (nonatomic, strong) FollowUserViewController *followUserViewController;

@end

@implementation FansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = @"火钳刘明的粉丝";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
        
        FollowUserViewController *viewController = [[FollowUserViewController alloc] initWithNibName:nil bundle:nil];
        viewController.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
        viewController.delegate = self;
        self.followUserViewController = viewController;
        
        [self addChildViewController:viewController];
        viewController.view.frame = self.view.bounds;
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
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

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.navigationTitle = [NSString stringWithFormat:@"%@的粉丝", data[@"name"]];
    [self.followUserViewController setData:data isFans:YES];
}

@end
