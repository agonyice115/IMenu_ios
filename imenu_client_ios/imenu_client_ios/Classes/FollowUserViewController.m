//
//  FollowUserViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FollowUserViewController.h"
#import "Common.h"
#import "FollowUserCell.h"
#import "UserData.h"
#import "Networking.h"
#import "MineViewController.h"
#import "OthersViewController.h"

@interface FollowUserViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FollowUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.data = [NSArray array];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.backgroundColor = [UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
        {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.tableView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 40)];
        imageView.center = CGPointMake(160, -30);
        imageView.image = [UIImage imageNamed:@"logo.png"];
        [self.tableView addSubview:imageView];
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

- (void)setData:(NSDictionary *)data isFans:(BOOL)isFans
{
    if (isFans)
    {
        [self loadFansData:data];
    }
    else
    {
        [self loadFollowData:data];
    }
}

- (void)setData:(NSArray *)data
{
    _data = data;
    [self.tableView reloadData];
}

- (void)loadFansData:(NSDictionary *)data
{
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"followed_member_id":data[@"followed_member_id"],
                          @"followed_store_id":data[@"followed_store_id"]};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"member/member/getFollowedList"
                                          withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSString *successString = result[@"success"];
                    if (self.delegate)
                    {
                        [self.delegate showTips:successString];
                    }
                    
                    NSDictionary *resultData = result[@"data"];
                    self.data = resultData[@"member_list"];
                }
                else
                {
                    if (self.delegate)
                    {
                        [self.delegate showTips:errorString];
                    }
                }
            }
            else
            {
                if (self.delegate)
                {
                    [self.delegate showTips:NSLocalizedString(@"networking_error", nil)];
                }
            }
        });
    });
}

- (void)loadFollowData:(NSDictionary *)data
{
    // 这个暂时不能单独获取
}

#pragma mark - UITableView 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowUserCell"];
    if (cell == nil)
    {
        cell = [[FollowUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FollowUserCell"];
    }
    cell.data = self.data[indexPath.row];
    cell.delegate = self.delegate;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMBaseViewController *parentVC = (IMBaseViewController *)self.parentViewController;
    
    NSDictionary *data = self.data[indexPath.row];
    if ([[UserData sharedUserData].memberId isEqualToString:data[@"member_id"]])
    {
        MineViewController *vc = [[MineViewController alloc] initWithNibName:nil bundle:nil];
        vc.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
        vc.baseNavigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
        [parentVC.getIMNavigationController pushViewController:vc animated:YES];
    }
    else
    {
        OthersViewController *vc = [[OthersViewController alloc] initWithNibName:nil bundle:nil];
        [vc setUserMemberId:data[@"member_id"] andMemberName:data[@"member_name"]];
        [parentVC.getIMNavigationController pushViewController:vc animated:YES];
    }
}

@end
