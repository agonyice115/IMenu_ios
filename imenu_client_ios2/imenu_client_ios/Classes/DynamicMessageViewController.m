//
//  DynamicMessageViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-8.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DynamicMessageViewController.h"
#import "DynamicMessageCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@interface DynamicMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DynamicMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationTitle = @"动态消息";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_DYNIMIC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT,
                                                                   320, self.view.frame.size.height-TOP_BAR_HEIGHT)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"查看更早的消息...";
    [footView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
    line.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    [footView addSubview:line];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicMessageCell"];
    if (cell == nil)
    {
        cell = [[DynamicMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicMessageCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
