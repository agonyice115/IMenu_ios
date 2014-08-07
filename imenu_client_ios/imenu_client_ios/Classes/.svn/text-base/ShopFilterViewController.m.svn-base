//
//  ShopFilterViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-2.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopFilterViewController.h"
#import "Common.h"
#import "IMConfig.h"
#import "UIColor+HtmlColor.h"
#import "FilterSelectViewController.h"
#import "IMSegmentedControl.h"
#import "ShopViewController.h"
#import "TFTools.h"
#import "ClientConfig.h"

@interface ShopFilterViewController () <IMSegmentedControlDelegate, FilterSelectViewDelegate>

@property (nonatomic, strong) FilterSelectViewController *categoryViewController;
@property (nonatomic, strong) FilterSelectViewController *regionViewController;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSDictionary *categoryFilterData;
@property (nonatomic, strong) NSDictionary *regionFilterData;

@end

@implementation ShopFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        NSString *fileName = [CONFIG_VERSION_NAME_REGION stringByAppendingPathExtension:@"plist"];
        NSString *filePath = [TFTools getDocumentPathOfFile:fileName];
        self.regionFilterData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        fileName = [CONFIG_VERSION_NAME_CATEGORY stringByAppendingPathExtension:@"plist"];
        filePath = [TFTools getDocumentPathOfFile:fileName];
        self.categoryFilterData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TOP_BAR_HEIGHT)];
        view.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        [self.view addSubview:view];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        button.frame = CGRectMake(PAGE_MARGIN-10, 20, 50, 45);
        [button setTitle:NSLocalizedString(@"main_title3", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectFilterEnd) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIImageView *triangle = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+40, 40, 10, 5)];
        triangle.image = [UIImage imageNamed:@"triangle.png"];
        triangle.transform = CGAffineTransformMakeRotation(M_PI);
        [view addSubview:triangle];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320-PAGE_MARGIN-34, 20.0f, 45.0f, 45.0f);
        [button setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"select_highlight"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(selectFilterEnd) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        IMSegmentedControl *segment = [[IMSegmentedControl alloc] initWithFrame:CGRectMake(PAGE_MARGIN, TOP_BAR_HEIGHT+15, 320-PAGE_MARGIN*2, 30)
                                                             withSegmentedItems:@[NSLocalizedString(@"store_filter_title1", nil),
                                                                                  NSLocalizedString(@"store_filter_title2", nil)]
                                                                        atIndex:0];
        segment.delegate = self;
        [self.view addSubview:segment];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+60, 320, self.view.frame.size.height-TOP_BAR_HEIGHT-60)];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.contentView];
        
        self.categoryViewController.view.hidden = NO;
        self.regionViewController.view.hidden = YES;
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

- (void)setRegionId:(NSString *)regionId
{
    _regionId = regionId;
    [self.regionViewController setCurrentId:regionId withData:self.regionFilterData];
}

- (void)setCategoryId:(NSString *)categoryId
{
    _categoryId = categoryId;
    [self.categoryViewController setCurrentId:categoryId withData:self.categoryFilterData];
}

- (FilterSelectViewController *)categoryViewController
{
    if (_categoryViewController)
    {
        return _categoryViewController;
    }
    
    _categoryViewController = [[FilterSelectViewController alloc] initWithNibName:nil bundle:nil];
    _categoryViewController.delegate = self;
    
    [self addChildViewController:_categoryViewController];
    _categoryViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:_categoryViewController.view];
    [_categoryViewController didMoveToParentViewController:self];
    
    return _categoryViewController;
}

- (FilterSelectViewController *)regionViewController
{
    if (_regionViewController)
    {
        return _regionViewController;
    }
    
    _regionViewController = [[FilterSelectViewController alloc] initWithNibName:nil bundle:nil];
    _regionViewController.delegate = self;
    _regionViewController.showRegionButton = YES;
    
    [self addChildViewController:_regionViewController];
    _regionViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:_regionViewController.view];
    [_regionViewController didMoveToParentViewController:self];
    
    return _regionViewController;
}

- (void)selectFilterEnd
{
    [self dismissViewControllerAnimated:YES completion:^{
        ShopViewController *vc = (ShopViewController *)self.shopVC;
        [vc setCategoryId:self.categoryViewController.currentId andRegionId:self.regionViewController.currentId];
    }];
}

- (void)segmented:(IMSegmentedControl *)segment clickSegmentItemAtIndex:(NSUInteger)index bySort:(BOOL)isAscending
{
    if (index == 0)
    {
        self.categoryViewController.view.hidden = NO;
        self.regionViewController.view.hidden = YES;
    }
    else
    {
        self.categoryViewController.view.hidden = YES;
        self.regionViewController.view.hidden = NO;
    }
}

- (void)onSelectId:(NSString *)Id withData:(NSDictionary *)data by:(FilterSelectViewController *)filter
{
    if (filter == self.regionViewController)
    {
        if (![Id isEqualToString:self.regionId] && !data[@"children"])
        {
            self.regionId = Id;
            [self selectFilterEnd];
        }
    }
    else
    {
        if (![Id isEqualToString:self.categoryId] && !data[@"children"])
        {
            self.categoryId = Id;
            [self selectFilterEnd];
        }
    }
}

@end
