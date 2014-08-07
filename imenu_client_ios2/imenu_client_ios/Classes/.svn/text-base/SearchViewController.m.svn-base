//
//  SerchViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-17.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SearchViewController.h"
#import "IMSegmentedControl.h"
#import "UIColor+HtmlColor.h"
#import "Networking.h"
#import "UserData.h"
#import "SearchResultViewController.h"
#import "IMConfig.h"
#import "TFTools.h"

@interface SearchViewController () <IMSegmentedControlDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger searchIndex;
@property (nonatomic, strong) NSArray *searchData;
@property (nonatomic, strong) NSMutableArray *searchHistoryData;

@property (nonatomic, strong) SearchResultViewController *resultViewController;

@property (nonatomic, assign) BOOL showClearHistory;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"main_title4", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_SERCH;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_SERCH;
        
        float height = TOP_BAR_HEIGHT;
        
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        searchView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:searchView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 11, 24, 24)];
        imageView.image = [UIImage imageNamed:@"search.png"];
        [searchView addSubview:imageView];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN+35, 10, 320-PAGE_MARGIN*2-80, 25)];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.textField.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        self.textField.placeholder = @"Search for anything";
        [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [searchView addSubview:self.textField];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320-PAGE_MARGIN-45, 10, 45, 25);
        button.backgroundColor = [IMConfig sharedConfig].bgColor;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5.0f;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#cccccc"] forState:UIControlStateHighlighted];
        [button setTitle:NSLocalizedString(@"tip_button_cancel", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        [searchView addSubview:button];
        self.cancelButton = button;
        
        height += MIDDLE_BAR_HEIGHT+10;
        
        IMSegmentedControl *seg = [[IMSegmentedControl alloc] initWithFrame:CGRectMake(20, height, 280, 30)
                                                         withSegmentedItems:@[NSLocalizedString(@"serch_view_title1", nil),
                                                                              NSLocalizedString(@"serch_view_title2", nil),
                                                                              NSLocalizedString(@"serch_view_title3", nil),
                                                                              NSLocalizedString(@"serch_view_title4", nil)]
                                                                    atIndex:0];
        seg.delegate = self;
        [self.view addSubview:seg];
        
        height += 40;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, self.view.frame.size.height-height)];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.contentView];
        
        self.resultViewController = [[SearchResultViewController alloc] initWithNibName:nil bundle:nil];
        
        [self addChildViewController:self.resultViewController];
        self.resultViewController.view.frame = self.contentView.bounds;
        [self.contentView addSubview:self.resultViewController.view];
        [self.resultViewController didMoveToParentViewController:self];
        
        [self loadSerchHistory];
        
        CGRect frame = searchView.frame;
        frame.origin.y = CGRectGetMaxY(frame);
        frame.size.height = self.view.frame.size.height-frame.origin.y;
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        self.tableView.hidden = YES;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        footerView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = footerView;
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

- (void)loadSerchHistory
{
    NSString *fileName = [TFTools getDocumentPathOfFile:@"SerchHistory.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        self.searchHistoryData = [NSMutableArray arrayWithContentsOfFile:fileName];
    }
    else
    {
        self.searchHistoryData = [NSMutableArray array];
    }
    
    self.searchData = self.searchHistoryData;
    self.showClearHistory = YES;
}

- (void)saveSerchHistory
{
    if (self.searchHistoryData.count > 10)
    {
        [self.searchHistoryData removeLastObject];
    }
    NSString *fileName = [TFTools getDocumentPathOfFile:@"SerchHistory.plist"];
    [self.searchHistoryData writeToFile:fileName atomically:YES];
}

- (BOOL)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId
{
    if ([super onNavigationItemClicked:navigationItemId])
    {
        return YES;
    }
    
    switch (navigationItemId)
    {
        case IM_NAVIGATION_ITEM_SERCH:
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
}

- (void)segmented:(IMSegmentedControl *)segment clickSegmentItemAtIndex:(NSUInteger)index bySort:(BOOL)isAscending
{
    self.searchIndex = index;
    
    [self.resultViewController setIndex:index andValue:self.textField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tableView.hidden = NO;
    self.cancelButton.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    self.tableView.hidden = YES;
    self.cancelButton.hidden = YES;
    
    if (self.textField.text.length > 0)
    {
        [self.searchHistoryData insertObject:@{@"result_name":self.textField.text} atIndex:0];
        [self saveSerchHistory];
    }
    [self.resultViewController setIndex:self.searchIndex andValue:self.textField.text];
    
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
        self.searchData = self.searchHistoryData;
        self.showClearHistory = YES;
        [self.tableView reloadData];
    }
}

- (void)clickCancelButton
{
    [self.textField resignFirstResponder];
    self.tableView.hidden = YES;
    self.cancelButton.hidden = YES;
}

- (void)searchVaule:(NSString *)value
{
    NSDictionary *dic = @{@"filter_data":value,
                          @"longitude_num":[UserData sharedUserData].longitude,
                          @"latitude_num":[UserData sharedUserData].latitude,
                          @"count":@"20",
                          @"search_type":[NSString stringWithFormat:@"%d", self.searchIndex+1]};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"search/search/searchVague" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    self.searchData = resultData[@"result_list"];
                    self.showClearHistory = NO;
                    [self.tableView reloadData];
                }
            }
        });
    });
}

#pragma mark - UITableView 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.showClearHistory)
    {
        return self.searchData.count+1;
    }
    else
    {
        return self.searchData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SearchCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        cell.textLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        
        cell.detailTextLabel.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    }
    
    if (indexPath.row >= self.searchData.count)
    {
        cell.textLabel.text = @"清除搜索历史";
        cell.detailTextLabel.text = nil;
    }
    else
    {
        NSDictionary *dic = self.searchData[indexPath.row];
        cell.textLabel.text = dic[@"result_name"];
        if (dic[@"result_count"])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@个结果", dic[@"result_count"]];
        }
        else
        {
            cell.detailTextLabel.text = nil;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.searchData.count)
    {
        self.searchHistoryData = [NSMutableArray array];
        self.searchData = self.searchHistoryData;
        [self saveSerchHistory];
        [self.tableView reloadData];
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.textField.text = cell.textLabel.text;
        [self.textField resignFirstResponder];
        tableView.hidden = YES;
        self.cancelButton.hidden = YES;
        
        [self.searchHistoryData insertObject:@{@"result_name":self.textField.text} atIndex:0];
        [self saveSerchHistory];
        self.searchData = self.searchHistoryData;
        [self.tableView reloadData];
        [self.resultViewController setIndex:self.searchIndex andValue:self.textField.text];
    }
}

#pragma mark - UIScrollView 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
}

@end
