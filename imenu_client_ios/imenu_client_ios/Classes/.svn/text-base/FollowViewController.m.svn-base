//
//  FollowViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FollowViewController.h"
#import "FollowUserViewController.h"
#import "FollowShopViewController.h"
#import "IMConfig.h"
#import "IMSegmentedControl.h"
#import "UserData.h"
#import "Networking.h"

@interface FollowViewController () <IMSegmentedControlDelegate>

@property (nonatomic, strong) FollowUserViewController *followUserViewController;
@property (nonatomic, strong) FollowShopViewController *followShopViewController;

@end

@implementation FollowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = @"火钳刘明的关注";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
        
        IMSegmentedControl *segment = [[IMSegmentedControl alloc] initWithFrame:CGRectMake(PAGE_MARGIN, TOP_BAR_HEIGHT+15, 320-PAGE_MARGIN*2, 30)
                                                             withSegmentedItems:@[NSLocalizedString(@"follow_segment_kind1", nil),
                                                                                  NSLocalizedString(@"follow_segment_kind2", nil)]
                                                                        atIndex:0];
        segment.delegate = self;
        [self.view addSubview:segment];
        
        FollowUserViewController *viewController = [[FollowUserViewController alloc] initWithNibName:nil bundle:nil];
        viewController.delegate = self;
        self.followUserViewController = viewController;
        
        [self addChildViewController:viewController];
        viewController.view.frame = CGRectMake(0, TOP_BAR_HEIGHT+60, 320, self.view.bounds.size.height-TOP_BAR_HEIGHT-60);
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        FollowShopViewController *shopViewController = [[FollowShopViewController alloc] initWithNibName:nil bundle:nil];
        shopViewController.delegate = self;
        shopViewController.view.hidden = YES;
        self.followShopViewController = shopViewController;
        
        [self addChildViewController:shopViewController];
        shopViewController.view.frame = CGRectMake(0, TOP_BAR_HEIGHT+60, 320, self.view.bounds.size.height-TOP_BAR_HEIGHT-60);
        [self.view addSubview:shopViewController.view];
        [shopViewController didMoveToParentViewController:self];
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
    
    self.navigationTitle = [NSString stringWithFormat:@"%@的关注", data[@"name"]];
    [self loadData];
}

- (void)loadData
{
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"following_member_id":self.data[@"following_member_id"]};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"member/member/getFollowingList"
                                          withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSString *successString = result[@"success"];
                    [self showTips:successString];
                    
                    NSDictionary *resultData = result[@"data"];
                    self.followUserViewController.data = resultData[@"member_list"];
                    self.followShopViewController.data = resultData[@"store_list"];
                }
                else
                {
                    [self showTips:errorString];
                }
            }
            else
            {
                [self showTips:NSLocalizedString(@"networking_error", nil)];
            }
        });
    });
}

- (void)segmented:(IMSegmentedControl *)segment clickSegmentItemAtIndex:(NSUInteger)index bySort:(BOOL)isAscending
{
    if (index == 0)
    {
        self.followUserViewController.view.hidden = NO;
        self.followShopViewController.view.hidden = YES;
    }
    else
    {
        self.followUserViewController.view.hidden = YES;
        self.followShopViewController.view.hidden = NO;
    }
}

@end
