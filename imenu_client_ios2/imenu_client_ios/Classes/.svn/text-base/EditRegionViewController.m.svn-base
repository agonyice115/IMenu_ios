//
//  EditRegionViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "EditRegionViewController.h"
#import "ShopFilterCell.h"
#import "Common.h"

@interface EditRegionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *currentFilterView;

@property (nonatomic, strong) NSDictionary *filterData;
@property (nonatomic, strong) NSArray *data;

@end

@implementation EditRegionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationBarView.title.text = NSLocalizedString(@"register_view_local", nil);
        
        self.currentFilterView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
        self.currentFilterView.backgroundColor = [UIColor clearColor];
        self.currentFilterView.showsVerticalScrollIndicator = NO;
        self.currentFilterView.dataSource = self;
        self.currentFilterView.delegate = self;
        self.currentFilterView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
        self.currentFilterView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.currentFilterView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentId:(NSString *)currentId withData:(NSDictionary *)data
{
    self.filterData = data;
    
    [self generateData:currentId];
}

- (void)generateData:(NSString *)generateId
{
    NSMutableArray *data = [NSMutableArray array];
    
    NSDictionary *dic = self.filterData[generateId];
    if (dic == nil)
    {
        return;
    }
    
    NSString *level = dic[@"level"];
    
    NSString *parentId = dic[@"parent"];
    while (parentId != nil)
    {
        NSDictionary *parent = self.filterData[parentId];
        if (parent == nil)
        {
            return;
        }
        
        [data insertObject:parent atIndex:0];
        parentId = parent[@"parent"];
    }
    
    NSArray *children = dic[@"children"];
    if (children && ![level isEqualToString:@"2"])
    {
        [data addObject:dic];
        
        self.currentId = generateId;
        
        for (NSString *childId in children)
        {
            [data addObject:self.filterData[childId]];
        }
    }
    else
    {
        self.currentId = generateId;
        if ([data count])
        {
            NSDictionary *parent = [data lastObject];
            children = parent[@"children"];
            
            for (NSString *childId in children)
            {
                [data addObject:self.filterData[childId]];
            }
        }
        else
        {
            [data addObject:dic];
        }
    }
    
    [self showFilterView:data];
}

- (void)showFilterView:(NSArray *)data
{
    if (self.data)
    {
        int i = 0;
        for (i = 0; i < [self.data count] && i < [data count]; i++)
        {
            NSDictionary *old = self.data[i];
            NSDictionary *new = data[i];
            
            if ([old[@"id"] isEqualToString:new[@"id"]])
            {
                continue;
            }
            else
            {
                break;
            }
        }
        
        int first = i;
        NSMutableArray *delArray = [NSMutableArray array];
        for (i = first; i < [self.data count]; i++)
        {
            [delArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        NSMutableArray *insArray = [NSMutableArray array];
        for (i = first; i < [data count]; i++)
        {
            [insArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        self.data = data;
        [self.currentFilterView beginUpdates];
        [self.currentFilterView deleteRowsAtIndexPaths:delArray withRowAnimation:UITableViewRowAnimationFade];
        [self.currentFilterView insertRowsAtIndexPaths:insArray withRowAnimation:UITableViewRowAnimationFade];
        [self.currentFilterView endUpdates];
    }
    else
    {
        self.data = data;
        [self.currentFilterView reloadData];
    }
    
    for (int i = 0; i < [self.data count]; i++)
    {
        NSDictionary *dic = self.data[i];
        if ([self.currentId isEqualToString:dic[@"id"]])
        {
            if (dic[@"children"])
            {
                [self.currentFilterView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                                                    animated:NO
                                              scrollPosition:UITableViewScrollPositionMiddle];
            }
            else
            {
                [self.currentFilterView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                                                    animated:NO
                                              scrollPosition:UITableViewScrollPositionNone];
            }
            
            if (self.delegate)
            {
                [self.delegate onSelectId:self.currentId withData:dic by:self];
            }
        }
    }
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
    ShopFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopFilterCell"];
    if (cell == nil)
    {
        cell = [[ShopFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopFilterCell"];
        cell.isCheckLevel = YES;
    }
    cell.data = self.data[indexPath.row];
    if (indexPath.row == 0)
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.data[indexPath.row];
    [self generateData:dic[@"id"]];
}

@end
