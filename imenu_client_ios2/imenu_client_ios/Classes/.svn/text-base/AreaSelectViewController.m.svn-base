//
//  AreaSelectViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-9.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "AreaSelectViewController.h"
#import "LoginAndRegisterNavigationBar.h"
#import "Common.h"
#import "IMConfig.h"
#import "UIColor+HtmlColor.h"

@interface AreaSelectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) LoginAndRegisterNavigationBar *navigationBarView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AreaSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        self.tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
        {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        [self.view addSubview:self.tableView];
        
        self.navigationBarView = [[LoginAndRegisterNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, TOP_BAR_HEIGHT)];
        self.navigationBarView.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        [self.view addSubview:self.navigationBarView];
        
        self.navigationBarView.title.textColor = [IMConfig sharedConfig].fgColor;
        self.navigationBarView.title.text = NSLocalizedString(@"register_title2", nil);
        [self.navigationBarView.closeButton addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AreaCell"];
        cell.textLabel.text = @"中国（+86）";
        cell.textLabel.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        cell.textLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"right.png"];
        cell.accessoryView = imageView;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MIDDLE_BAR_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
