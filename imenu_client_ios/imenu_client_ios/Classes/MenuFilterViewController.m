//
//  MenuFilterViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-17.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "MenuFilterViewController.h"
#import "IMSegmentedControl.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "CartData.h"

@interface MenuFilterViewController () <IMSegmentedControlDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) FilterSelectViewController *menuFilter;
@property (nonatomic, strong) NSDictionary *menuData;
@property (nonatomic, strong) UIView *conditionView;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation MenuFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CartDataChanged:) name:CART_DATA_CHANGED object:nil];
        
        IMSegmentedControl *segment = [[IMSegmentedControl alloc] initWithFrame:CGRectMake(5, 5, 110, 30)
                                                             withSegmentedItems:@[NSLocalizedString(@"menu_filter_title1", nil),
                                                                                  NSLocalizedString(@"menu_filter_title2", nil)]
                                                                        atIndex:0];
        segment.delegate = self;
        [self.view addSubview:segment];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 120, self.view.frame.size.height-40)];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.contentView];
        
        self.menuFilter.view.hidden = NO;
        
        self.conditionView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        self.conditionView.backgroundColor = [UIColor clearColor];
        self.conditionView.hidden = YES;
        [self.contentView addSubview:self.conditionView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [self.conditionView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 0, 60, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor blackColor];
        label.text = @"人数";
        [self.conditionView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN, 50, 23, 23);
        [button setImage:[UIImage imageNamed:@"minus_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"minus_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickMinus) forControlEvents:UIControlEventTouchUpInside];
        [self.conditionView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(120-PAGE_MARGIN-23, 50, 23, 23);
        [button setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"plus_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickPlus) forControlEvents:UIControlEventTouchUpInside];
        [self.conditionView addSubview:button];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+25, 50, 40, 23)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"0人";
        [self.conditionView addSubview:label];
        self.countLabel = label;
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

- (void)onClickPlus
{
    [CartData sharedCartData].storeData = self.storeData;
    if ([CartData sharedCartData].peopleCount == 99)
    {
        return;
    }
    [CartData sharedCartData].peopleCount += 1;
}

- (void)onClickMinus
{
    [CartData sharedCartData].storeData = self.storeData;
    if ([CartData sharedCartData].peopleCount == 0)
    {
        return;
    }
    [CartData sharedCartData].peopleCount -= 1;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)CartDataChanged:(NSNotification *)notification
{
    if ([[CartData sharedCartData].storeId isEqualToString:self.storeData[@"store_id"]])
    {
        self.countLabel.text = [NSString stringWithFormat:@"%d人", [CartData sharedCartData].peopleCount];
    }
}

- (FilterSelectViewController *)menuFilter
{
    if (_menuFilter)
    {
        return _menuFilter;
    }
    
    _menuFilter = [[FilterSelectViewController alloc] initWithNibName:nil bundle:nil];
    
    [self addChildViewController:_menuFilter];
    _menuFilter.view.frame = self.contentView.bounds;
    [self.contentView addSubview:_menuFilter.view];
    [_menuFilter didMoveToParentViewController:self];
    
    return _menuFilter;
}

- (void)setDelegate:(id<FilterSelectViewDelegate>)delegate
{
    _delegate = delegate;
    
    self.menuFilter.delegate = delegate;
}

- (void)segmented:(IMSegmentedControl *)segment clickSegmentItemAtIndex:(NSUInteger)index bySort:(BOOL)isAscending
{
    if (index == 0)
    {
        self.menuFilter.view.hidden = NO;
        self.conditionView.hidden = YES;
    }
    else
    {
        self.menuFilter.view.hidden = YES;
        self.conditionView.hidden = NO;
    }
}

- (void)setFilterData:(NSArray *)data
{
    if ([[CartData sharedCartData].storeId isEqualToString:self.storeData[@"store_id"]])
    {
        self.countLabel.text = [NSString stringWithFormat:@"%d人", [CartData sharedCartData].peopleCount];
    }
    
    self.menuData = [self analysisFilterData:data];
    
    [self.menuFilter setCurrentId:@"0" withData:self.menuData];
}

- (NSDictionary *)analysisFilterData:(NSArray *)data
{
    NSMutableDictionary *regionData = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in data)
    {
        NSMutableDictionary *filterData = [NSMutableDictionary dictionary];
        filterData[@"id"] = dic[@"menu_category_id"];
        filterData[@"title"] = dic[@"menu_category_name"];
        filterData[@"image"] = [NSString stringWithFormat:@"%@%@", dic[@"menu_category_image_location"], dic[@"menu_category_image_name"]];
        filterData[@"sort"] = dic[@"sort_order"];
        filterData[@"parent"] = dic[@"parent_id"];
        filterData[@"has_all"] = @"yes";
        filterData[@"menu_ids"] = dic[@"menu_ids"];
        
        regionData[filterData[@"id"]] = filterData;
    }
    
    NSMutableDictionary *top = [NSMutableDictionary dictionary];
    top[@"has_all"] = @"yes";
    top[@"title"] = @"全部";
    top[@"id"] = @"0";
    regionData[@"0"] = top;
    
    return [self generateFilterChildren:regionData];
}

- (NSDictionary *)generateFilterChildren:(NSMutableDictionary *)data
{
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableDictionary *dic = obj;
        NSString *parentId = dic[@"parent"];
        
        if (parentId)
        {
            NSMutableDictionary * parent = data[parentId];
            if (parent == nil)
            {
                parent = data[@"0"];
                dic[@"parent"] = @"0";
            }
            
            NSMutableArray *children = parent[@"children"];
            if (children == nil)
            {
                children = [NSMutableArray array];
                parent[@"children"] = children;
            }
            [children addObject:dic[@"id"]];
        }
    }];
    
    return [self sortFilterChildren:data];
}

- (NSDictionary *)sortFilterChildren:(NSMutableDictionary *)data
{
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableDictionary *dic = obj;
        NSMutableArray *children = dic[@"children"];
        if (children)
        {
            [children sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSMutableDictionary *filterData1 = data[obj1];
                NSMutableDictionary *filterData2 = data[obj2];
                NSString *sort1 = filterData1[@"sort"];
                NSString *sort2 = filterData2[@"sort"];
                if (sort1.intValue < sort2.intValue)
                {
                    return NSOrderedAscending;
                }
                else if (sort1.intValue == sort2.intValue)
                {
                    return NSOrderedSame;
                }
                else
                {
                    return NSOrderedDescending;
                }
            }];
        }
    }];
    
    return data;
}


@end
