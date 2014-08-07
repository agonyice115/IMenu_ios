//
//  FilterSelectViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-2.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FilterSelectViewController.h"
#import "ShopFilterCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "ClientConfig.h"
#import "IMTipView.h"
#import "RegionSelectView.h"

@interface FilterSelectViewController () <UITableViewDataSource, UITableViewDelegate, RegionSelectViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *currentFilterView;

@property (nonatomic, strong) NSDictionary *filterData;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) UIButton *regionButton;

@end

@implementation FilterSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.contentView];
        
        self.currentFilterView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
        self.currentFilterView.backgroundColor = [UIColor clearColor];
        self.currentFilterView.showsVerticalScrollIndicator = NO;
        self.currentFilterView.dataSource = self;
        self.currentFilterView.delegate = self;
        self.currentFilterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.currentFilterView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        [self.contentView addSubview:self.currentFilterView];
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

- (void)setShowRegionButton:(BOOL)showRegionButton
{
    _showRegionButton = showRegionButton;
    
    if (showRegionButton)
    {
        CGRect frame = self.contentView.frame;
        frame.origin.y += 40;
        frame.size.height -= 40;
        self.contentView.frame = frame;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 10, 13)];
        imageView.image = [UIImage imageNamed:@"map_highlight@2x.png"];
        [self.view addSubview:imageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithHtmlColor:@"#008fff"];
        button.frame = CGRectMake(PAGE_MARGIN+15, 0, 160, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        [button setTitle:@"陕西/西安" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickRegionSelect) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [self.view addSubview:button];
        
        self.regionButton = button;
    }
}

- (void)setRegionTitleById:(NSString *)Id
{
    if (self.regionButton)
    {
        NSString *regionId = [self getRegionIdById:Id];
        NSString *title = [[ClientConfig sharedConfig] getRegionStringById:regionId];
        [self.regionButton setTitle:title forState:UIControlStateNormal];
        [self.regionButton sizeToFit];
        
        CGRect frame = self.regionButton.frame;
        frame.size.width += 10;
        self.regionButton.frame = frame;
    }
}

- (void)clickRegionSelect
{
    RegionSelectView *view = [[RegionSelectView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [view setCurrentId:[self getRegionIdById:self.currentId] withData:self.filterData];
    view.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    return;
}

- (void)onSelectId:(NSString *)Id withData:(NSDictionary *)data by:(RegionSelectView *)filter
{
    NSString *regionId = [self getRegionIdById:self.currentId];
    NSString *level = data[@"level"];
    if (![regionId isEqualToString:Id] && [level isEqualToString:@"2"])
    {
        NSString *isOpen = data[@"is_open"];
        if ([isOpen isEqualToString:@"0"])
        {
            IMTipView *tip = [[IMTipView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
            tip.tips.text = @"您选择的地区尚未开通服务";
            [[UIApplication sharedApplication].keyWindow addSubview:tip];
            
            return;
        }
        
        [self setRegionTitleById:Id];
        [self generateData:Id];
    }
}

- (NSString *)getRegionIdById:(NSString *)Id
{
    NSDictionary *dic = self.filterData[Id];
    NSString *level = dic[@"level"];
    NSString *parentId = dic[@"parent"];
    while (![level isEqualToString:@"2"] && parentId != nil)
    {
        dic = self.filterData[parentId];
        if (dic == nil)
        {
            return @"29";
        }
        
        level = dic[@"level"];
        parentId = dic[@"parent"];
    }
    
    return dic[@"id"];
}

- (void)setCurrentId:(NSString *)currentId withData:(NSDictionary *)data
{
    self.filterData = data;
    
    [self setRegionTitleById:currentId];
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
    
    if (!(level && [level isEqualToString:@"2"]))
    {
        NSString *parentId = dic[@"parent"];
        while (parentId != nil)
        {
            NSDictionary *parent = self.filterData[parentId];
            if (parent == nil)
            {
                return;
            }
            
            NSString *level = parent[@"level"];
            if (level && [level isEqualToString:@"1"])
            {
                break;
            }
            [data insertObject:parent atIndex:0];
            parentId = parent[@"parent"];
        }
    }
    
    NSArray *children = dic[@"children"];
    if (children)
    {
        [data addObject:dic];
        
        if (![dic[@"has_all"] isEqualToString:@"yes"])
        {
            self.currentId = children[0];
        }
        else
        {
            self.currentId = generateId;
        }
        
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
