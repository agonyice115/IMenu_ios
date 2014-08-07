//
//  RecommendViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-8.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "RecommendViewController.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "IMSegmentedControl.h"
#import "RecommendCell.h"

@interface RecommendView : UIView

@property (nonatomic, assign) NSUInteger index;

@end

@implementation RecommendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *stokeColor = [UIColor colorWithHtmlColor:@"#888888"];
    UIColor *fillColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    
    CGContextSetStrokeColorWithColor(context, stokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineWidth(context, 0.0f);
    
    CGContextSaveGState(context);
    
    CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 0.8f, [UIColor colorWithWhite:0.6f alpha:0.4f].CGColor);
    
    CGContextMoveToPoint(context, 0, rect.size.height);
    
    for (int i = 0; i < 19; i++)
    {
        CGContextAddLineToPoint(context, i*13+6, rect.size.height-10);
        CGContextAddLineToPoint(context, i*13+13, rect.size.height);
    }
    CGContextAddLineToPoint(context, 19*13+6, rect.size.height-10);
    CGContextAddLineToPoint(context, rect.size.width-1, rect.size.height);
    
    CGFloat arrow = 40 + self.index * 90;
    
    CGContextAddArcToPoint(context, rect.size.width-1, 20, 55, 20, 5);
    CGContextAddLineToPoint(context, arrow+15, 20);
    CGContextAddLineToPoint(context, arrow, 0);
    CGContextAddLineToPoint(context, arrow-15, 20);
    CGContextAddArcToPoint(context, 0, 20, 0, rect.size.height, 5);
    
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
    
    CGContextSetLineWidth(context, 0.5f);
    
    CGContextMoveToPoint(context, 10, 49);
    CGContextAddLineToPoint(context, rect.size.width-10, 49);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 0.5f);
    float lengths[] = {3, 3};
    
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 10, rect.size.height-80);
    CGContextAddLineToPoint(context, rect.size.width-10, rect.size.height-80);
    CGContextStrokePath(context);
}

@end

@interface RecommendViewController () <IMSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) RecommendView *recommendView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationTitle = @"麦当劳";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_SHOP;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IMSegmentedControl *segment = [[IMSegmentedControl alloc] initWithFrame:CGRectMake(PAGE_MARGIN, TOP_BAR_HEIGHT+15, 320-PAGE_MARGIN*2, 30)
                                                         withSegmentedItems:@[NSLocalizedString(@"recommend_title1", nil),
                                                                              NSLocalizedString(@"recommend_title2", nil),
                                                                              NSLocalizedString(@"recommend_title3", nil)]
                                                                    atIndex:0];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    self.recommendView = [[RecommendView alloc] initWithFrame:CGRectMake(PAGE_MARGIN*2, TOP_BAR_HEIGHT+50,
                                                                                   260, self.view.frame.size.height-TOP_BAR_HEIGHT-80)];
    [self.view addSubview:self.recommendView];
    
    CGFloat height = 30.0f;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height+5, 10, 11)];
    icon.image = [UIImage imageNamed:@"recommend"];
    [self.recommendView addSubview:icon];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+12, height, 60, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"店长推荐";
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
    [self.recommendView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+12+62, height, 98, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"麦趣鸡盒套餐";
    label.textColor = [UIColor colorWithHtmlColor:@"#f8985b"];
    label.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    [self.recommendView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(190, height, 60, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"￥35.50";
    label.textColor = [UIColor colorWithHtmlColor:@"#46acfe"];
    label.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
    label.textAlignment = NSTextAlignmentRight;
    [self.recommendView addSubview:label];
    
    height += 20;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, height,
                                                                   240, self.recommendView.frame.size.height-80-height)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.recommendView addSubview:self.tableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, self.recommendView.frame.size.height-70, 240, 50);
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#46acfe"];
    button.layer.cornerRadius = 5.0f;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:FIRST_FONT_SIZE];
    [button setTitle:@"立即下单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(onClickRecommend) forControlEvents:UIControlEventTouchUpInside];
    [self.recommendView addSubview:button];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, 320, 30)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    [self.view addSubview:self.pageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmented:(IMSegmentedControl *)segment clickSegmentItemAtIndex:(NSUInteger)index bySort:(BOOL)isAscending
{
    self.recommendView.index = index;
    self.pageControl.currentPage = index;
    
    if (index == 0)
    {
    }
    else if (index == 1)
    {
    }
    else
    {
    }
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell"];
    if (cell == nil)
    {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
