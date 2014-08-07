//
//  FollowSelectViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FollowSelectViewController.h"
#import "UserSelectCell.h"
#import "Common.h"
#import "LoginAndRegisterNavigationBar.h"
#import "IMConfig.h"
#import "Networking.h"
#import "UserData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TFTools.h"

@interface FollowSelectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) LoginAndRegisterNavigationBar *navigationBarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation FollowSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        self.data = [NSArray array];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.backgroundColor = [UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
        {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
        [self.view addSubview:self.tableView];
        
        self.navigationBarView = [[LoginAndRegisterNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, TOP_BAR_HEIGHT)];
        self.navigationBarView.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        [self.view addSubview:self.navigationBarView];
        
        self.navigationBarView.title.textColor = [IMConfig sharedConfig].fgColor;
        self.navigationBarView.title.text = @"选择好友";
        [self.navigationBarView.closeButton addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
        
        [self loadData];
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

#pragma mark - UITableView 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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
    UserSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserSelectCell"];
    if (cell == nil)
    {
        cell = [[UserSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserSelectCell"];
    }
    NSDictionary *dic = self.data[indexPath.row];
    cell.userName.text = dic[@"member_name"];
    cell.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:dic[@"iconLocation"] andName:dic[@"iconName"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     cell.headView.headPic = image;
                                                 }
                                             }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.data[indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FOLLOW_SELECT_NAME object:dic];
    }];
}

- (void)backToMainView
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FOLLOW_SELECT_NAME object:nil];
    }];
}

- (void)loadData
{
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"following_member_id":[UserData sharedUserData].memberId};
    
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
                    NSDictionary *resultData = result[@"data"];
                    self.data = resultData[@"member_list"];
                    [self.tableView reloadData];
                }
            }
        });
    });
}

@end
