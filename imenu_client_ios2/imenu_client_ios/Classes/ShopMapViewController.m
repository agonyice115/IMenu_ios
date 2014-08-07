//
//  ShopMapViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-2-24.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopMapViewController.h"
#import "UserData.h"
#import "ShopAnnotation.h"
#import "ShopAnnotationView.h"
#import "TFTools.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import "ShopNoMenuCell.h"
#import "IMNavigationController.h"
#import "ShopDetailsViewController.h"
#import "IMLoadingView.h"
#import "Networking.h"

const CGFloat kBottomBarHeight = 50.0f;

@interface ShopMapViewController () <BMKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *middleView;

@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, assign) BOOL isShowTableView;

@property (nonatomic, assign) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) NSUInteger curIndex;

@end

@implementation ShopMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= kBottomBarHeight;
    self.mapView = [[BMKMapView alloc] initWithFrame:frame];
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(PAGE_MARGIN, TOP_BAR_HEIGHT+PAGE_MARGIN, 30, 30);
    [button setImage:[UIImage imageNamed:@"map_white@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickShowUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    frame.origin.y = CGRectGetMaxY(frame);
    frame.size.height = (self.view.bounds.size.height-TOP_BAR_HEIGHT-kBottomBarHeight)/2+2;
    
    self.middleView = [[UIView alloc] initWithFrame:frame];
    self.middleView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.middleView];
    
    frame.origin.y = 2;
    frame.size.height -= 2;
    // 加载列表视图
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.middleView addSubview:self.tableView];
    
    frame = self.middleView.frame;
    frame.size.height = kBottomBarHeight;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    frame.origin.y = 0;
    frame.size.height = 1;
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    
    frame = CGRectMake(PAGE_MARGIN, 5, 40, 40);
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"menu_blue@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [view addSubview:button];
    self.switchButton = button;
    
    frame.origin.x = 320-PAGE_MARGIN-30;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"next_blue@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [view addSubview:button];
    
    frame.origin.x -= 10+30;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"left_white@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickPre:) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [view addSubview:button];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)refreshData
{
    if (!self.storeList)
    {
        return;
    }
    
    if (self.annotations)
    {
        [self.mapView removeAnnotations:self.annotations];
    }
    
    self.data = [NSMutableArray array];
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D maxCoordinate = {-500, -500};
    CLLocationCoordinate2D minCoordinate = {500, 500};
    for (NSUInteger i = self.curIndex; i < self.storeList.count && i < self.curIndex+5; i++)
    {
        NSDictionary *data = self.storeList[i];
        
        [self.data addObject:data];
        
        NSString *longitude = data[@"store_longitude_num"];
        NSString *latitude = data[@"store_latitude_num"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        maxCoordinate.latitude = coordinate.latitude > maxCoordinate.latitude ? coordinate.latitude : maxCoordinate.latitude;
        maxCoordinate.longitude = coordinate.longitude > maxCoordinate.longitude ? coordinate.longitude : maxCoordinate.longitude;
        minCoordinate.latitude = coordinate.latitude < minCoordinate.latitude ? coordinate.latitude : minCoordinate.latitude;
        minCoordinate.longitude = coordinate.longitude < minCoordinate.longitude ? coordinate.longitude : minCoordinate.longitude;
        ShopAnnotation *annotation = [[ShopAnnotation alloc] initWithCoordinates:coordinate
                                                                           title:data[@"store_name"]
                                                                        subTitle:nil];
        annotation.thumbUrl = [TFTools getThumbImageUrlOfLacation:data[@"store_logo_location"] andName:data[@"store_logo_name"]];
        annotation.index = i-self.curIndex+1;
        
        [self.annotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:self.annotations];
    
    BMKCoordinateSpan span = BMKCoordinateSpanMake(maxCoordinate.latitude-minCoordinate.latitude+0.0005,
                                                   maxCoordinate.longitude-minCoordinate.longitude+0.0005);
    CLLocationCoordinate2D centerCoordinate = {maxCoordinate.latitude/2+minCoordinate.latitude/2,
        maxCoordinate.longitude/2+minCoordinate.longitude/2};
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(centerCoordinate, span);
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self.tableView reloadData];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    ShopAnnotationView *annotationView = (ShopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ShopAnnotationView"];
    if(annotationView == nil)
    {
        annotationView = [[ShopAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:@"ShopAnnotationView"];
    }
    else
    {
        annotationView.annotation = annotation;
        [annotationView resetData];
    }
    annotationView.canShowCallout = NO;
    annotationView.draggable = NO;
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    ShopAnnotation *annotation = view.annotation;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:annotation.index-1 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
    self.isShowTableView = YES;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    self.userCoordinate = userLocation.location.coordinate;
}

- (void)clickShowUser:(id)sender
{
    [self.mapView setCenterCoordinate:self.userCoordinate animated:YES];
}

- (void)clickPre:(id)sender
{
    if (self.curIndex <= 0)
    {
        return;
    }
    
    self.curIndex -= 5;
    
    [self refreshData];
}

- (void)clickNext:(id)sender
{
    if (self.curIndex+5 >= self.storeList.count)
    {
        [self loadMoreShopData];
        return;
    }
    
    self.curIndex += 5;
    
    [self refreshData];
}

- (void)loadMoreShopData
{
    self.pageIndex += 1;
    
    [IMLoadingView showLoading];
    
    [self loadDataFromServer];
}

- (void)loadDataFromServer
{
    NSMutableDictionary *dic = [self.urlData mutableCopy];
    dic[@"page"] = [NSString stringWithFormat:@"%d", self.pageIndex];
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"store/store/getStoreListAndMenus" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [IMLoadingView hideLoading];
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    NSArray *storeList = resultData[@"store_list"];
                    if ([storeList isKindOfClass:[NSArray class]] && storeList.count > 0)
                    {
                        self.storeList = [self.storeList arrayByAddingObjectsFromArray:storeList];
                        [self clickNext:nil];
                    }
                }
            }
        });
    });
}

- (void)clickSwitch:(id)sender
{
    self.isShowTableView = !self.isShowTableView;
}

- (void)setIsShowTableView:(BOOL)isShowTableView
{
    if (_isShowTableView == isShowTableView)
    {
        return;
    }
    
    _isShowTableView = isShowTableView;
    
    CGRect frame = self.middleView.frame;
    if (isShowTableView)
    {
        frame.origin.y -= frame.size.height;
        
        [self.switchButton setImage:[UIImage imageNamed:@"minus_highlight@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        frame.origin.y += frame.size.height;
        
        [self.switchButton setImage:[UIImage imageNamed:@"menu_blue@2x.png"] forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.middleView.frame = frame;
    }];
}

#pragma mark - UITableView 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
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
    ShopNoMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopNoMenuCell"];
    if (cell == nil)
    {
        cell = [[ShopNoMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopNoMenuCell"];
        
        UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
        view.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = view;
    }
    
    [cell setData:self.data[indexPath.row] withType:self.type];
    cell.index = indexPath.row+1;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = self.parentViewController.presentingViewController;
    
    if ([viewController isKindOfClass:[IMNavigationController class]])
    {
        NSDictionary *data = self.data[indexPath.row];
        IMNavigationController *baseVC = (IMNavigationController *)viewController;
        [self dismissViewControllerAnimated:YES completion:^{
            ShopDetailsViewController *vc = [[ShopDetailsViewController alloc] initWithNibName:nil bundle:nil];
            [vc setStoreId:data[@"store_id"] andStoreName:data[@"store_name"]];
            [baseVC pushViewController:vc animated:YES];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -30)
    {
        self.isShowTableView = NO;
    }
}

@end
