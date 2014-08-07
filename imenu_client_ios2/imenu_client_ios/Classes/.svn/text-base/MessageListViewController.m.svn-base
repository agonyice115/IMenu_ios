//
//  MessageListViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-13.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "MessageDetailViewController.h"

@interface MessageListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = @"我的消息";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_DYNIMIC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT,
                                                                   320, self.view.frame.size.height-TOP_BAR_HEIGHT)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailViewController *vc = [[MessageDetailViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

@end
