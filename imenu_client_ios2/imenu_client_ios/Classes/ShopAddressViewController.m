//
//  ShopAddressViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-2-28.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopAddressViewController.h"
#import "BMapKit.h"
#import "ShopAnnotation.h"
#import "ShopAnnotationView.h"
#import "TFTools.h"

@interface ShopAddressViewController () <BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView* mapView;

@end

@implementation ShopAddressViewController

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
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    
    NSString *longitude = self.data[@"store_longitude_num"];
    NSString *latitude = self.data[@"store_latitude_num"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    ShopAnnotation *annotation = [[ShopAnnotation alloc] initWithCoordinates:coordinate
                                                                       title:self.data[@"store_name"]
                                                                    subTitle:nil];
    annotation.thumbUrl = [TFTools getThumbImageUrlOfLacation:self.data[@"store_logo_location"] andName:self.data[@"store_logo_name"]];
    [self.mapView addAnnotation:annotation];
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self.view addSubview:self.mapView];
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

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    ShopAnnotationView *annotationView = (ShopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ShopAnnotationView"];
    if(annotationView == nil)
    {
        annotationView = [[ShopAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:@"ShopAnnotationView"];
        annotationView.hideIndex = YES;
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

@end
