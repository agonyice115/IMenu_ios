//
//  SkinViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-12.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SkinViewController.h"
#import "IMConfig.h"
#import "ClientConfig.h"
#import "SkinCell.h"
#import "TFTools.h"

@interface SkinViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation SkinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"setting_view_subtitle4", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
        
        self.data = [NSArray arrayWithContentsOfFile:[TFTools getDocumentPathOfFile:[CONFIG_VERSION_NAME_SKIN stringByAppendingPathExtension:@"plist"]]];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
        [self.view addSubview:self.tableView];
        
        for (int i = 0; i < [self.data count]; i++)
        {
            NSDictionary *data = self.data[i];
            if ([[IMConfig sharedConfig].bgColorString isEqualToString:data[@"client_skin_value"]])
            {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionMiddle];
                break;
            }
        }
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
    SkinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SkinCell"];
    if (cell == nil)
    {
        cell = [[SkinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SkinCell"];
    }
    
    cell.data = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.data[indexPath.row];
    [[IMConfig sharedConfig] setBgColorString:data[@"client_skin_value"]];
}

@end
