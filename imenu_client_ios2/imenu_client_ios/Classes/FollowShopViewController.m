//
//  FollowShopViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FollowShopViewController.h"
#import "FollowShopCell.h"
#import "ShopDetailsViewController.h"

@interface FollowShopViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FollowShopViewController

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

- (void)setData:(NSArray *)data
{
    _data = data;
    [self.tableView reloadData];
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
    FollowShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowShopCell"];
    if (cell == nil)
    {
        cell = [[FollowShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FollowShopCell"];
    }
    cell.data = self.data[indexPath.row];
    cell.delegate = self.delegate;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMBaseViewController *parentVC = (IMBaseViewController *)self.parentViewController;
    
    NSDictionary *data = self.data[indexPath.row];
    ShopDetailsViewController *vc = [[ShopDetailsViewController alloc] initWithNibName:nil bundle:nil];
    [vc setStoreId:data[@"store_id"] andStoreName:data[@"store_name"]];
    [parentVC.getIMNavigationController pushViewController:vc animated:YES];
}


@end
