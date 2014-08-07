//
//  ShopMenuSearchViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-6-18.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopMenuSearchViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "ShopMenuCell.h"
#import "MenuDetailViewController.h"
#import "Networking.h"

@interface ShopMenuSearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ShopMenuSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        float height = TOP_BAR_HEIGHT;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height+11, 24, 24)];
        imageView.image = [UIImage imageNamed:@"search.png"];
        [self.view addSubview:imageView];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+35, height+10, 320-PAGE_MARGIN*2-40, 25)];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.textField.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        self.textField.placeholder = @"Search for anything";
        [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.textField];
        
        height += 45;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, 320, self.view.frame.size.height-height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
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
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSDictionary *filter in data)
    {
        NSArray *filterData = filter[@"data"];
        [temp addObjectsFromArray:filterData];
    }
    
    _data = temp;
    
    self.menuList = [_data mutableCopy];
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if ([textField.text length] > 0)
    {
        [self performSelector:@selector(searchVaule:) withObject:textField.text afterDelay:1.0f];
    }
    else
    {
        self.menuList = [self.data mutableCopy];
        [self.tableView reloadData];
    }
}

- (void)searchVaule:(NSString *)value
{
    [self.menuList removeAllObjects];
    
    for (NSDictionary *menu in self.data)
    {
        NSString *menuName = menu[@"menu_name"];
        NSRange range = [menuName rangeOfString:value];
        if (range.location != NSNotFound)
        {
            [self.menuList addObject:menu];
        }
    }
    
    [self.tableView reloadData];
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
    return [self.menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopMenuCell"];
    if (cell == nil)
    {
        cell = [[ShopMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopMenuCell"];
    }
    cell.storeData = self.storeData;
    [cell setData:self.menuList[indexPath.row] showImage:[Networking sharedNetworking].isWiFi];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = self.presentingViewController;
    
    if ([viewController isKindOfClass:[IMNavigationController class]])
    {
        NSDictionary *menu = self.menuList[indexPath.row];
        
        IMNavigationController *baseVC = (IMNavigationController *)viewController;
        [self dismissViewControllerAnimated:YES completion:^{
            MenuDetailViewController *vc = [[MenuDetailViewController alloc] initWithNibName:nil bundle:nil];
            [vc setMenuId:menu[@"menu_id"]];
            [baseVC pushViewController:vc animated:YES];
        }];
    }
}

@end
