//
//  LoadingViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-13.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "LoadingViewController.h"
#import "ClientConfig.h"
#import "Common.h"
#import "CartData.h"
#import "UserData.h"
#import "Networking.h"
#import "UIColor+HtmlColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "TFTools.h"

@interface LoadingViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LoadingViewController

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
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    if (self.view.frame.size.height > 500.0f)
    {
        self.imageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"Default@2x.png"];
    }
    [self.view addSubview:self.imageView];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [CartData sharedCartData];
    [ClientConfig sharedConfig];
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

- (void)showMenuView:(NSDictionary *)data
{
    NSDictionary *menuInfo = data[@"menu_info"];
    NSDictionary *storeInfo = data[@"store_info"];
    //NSDictionary *dynamicInfo = data[@"dynamic_info"];
    NSDictionary *memberInfo = data[@"member_info"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
    NSString *url = [NSString stringWithFormat:@"%@%@", menuInfo[@"image_location"], menuInfo[@"image_name"]];
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_big.png"]];
    [self.view addSubview:imageView];
    
    if (self.view.frame.size.height > 500)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(160-317.0f/4, IMAGE_SIZE_BIG+50, 317.0f/2, 85)];
    }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(160-317.0f/4, IMAGE_SIZE_BIG+10, 317.0f/2, 85)];
    }
    imageView.image = [UIImage imageNamed:@"load_icon.png"];
    [self.view addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, IMAGE_SIZE_BIG-30, IMAGE_SIZE_BIG, 30)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+30, IMAGE_SIZE_BIG-60, 130-PAGE_MARGIN, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:FIRST_FONT_SIZE];
    label.textAlignment = NSTextAlignmentLeft;
    label.shadowOffset = CGSizeMake(1, 1);
    label.shadowColor = [UIColor colorWithHtmlColor:@"#424242"];
    label.text = menuInfo[@"menu_name"];
    label.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    [label sizeToFit];
    label.frame = CGRectMake(320-label.frame.size.width-PAGE_MARGIN, IMAGE_SIZE_BIG-60, label.frame.size.width, 30);
    [self.view addSubview:label];
    
    NSString *imageUrl = [self getImageUrlByCategoryId:storeInfo[@"category_id"]];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x-23, IMAGE_SIZE_BIG-55, 20, 20)];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self.view addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(160, 0, 160-PAGE_MARGIN, 30);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:THIRD_FONT_SIZE];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitle:storeInfo[@"store_name"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"shop_white"] forState:UIControlStateDisabled];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    button.enabled = NO;
    [view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(PAGE_MARGIN, 0, 160-PAGE_MARGIN, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [button setTitle:memberInfo[@"member_name"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fans"] forState:UIControlStateDisabled];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 2.5f, 0, 10)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 12.5f, 0, 0)];
    button.enabled = NO;
    [view addSubview:button];
    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(160, 30, 160-PAGE_MARGIN, 30);
//    button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
//    [button setTitle:[dynamicInfo[@"dynamic_date"] substringToIndex:10] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"time_white"] forState:UIControlStateDisabled];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    button.enabled = NO;
//    [view addSubview:button];
    
    [[Networking sharedNetworking] startNetCheck];
}

- (void)loadData
{
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDictionary *dic = @{@"longitude_num":[UserData sharedUserData].longitude,
                          @"latitude_num":[UserData sharedUserData].latitude,
                          @"request_date":[NSString stringWithFormat:@"%d", (int)interval - 3600*24]};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/getFrontPage" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    [self showMenuView:resultData];
                }
            }
        });
    });
}

- (NSString *)getImageUrlByCategoryId:(NSString *)categoryId
{
    NSString *fileName = [CONFIG_VERSION_NAME_CATEGORY stringByAppendingPathExtension:@"plist"];
    NSString *filePath = [TFTools getDocumentPathOfFile:fileName];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSDictionary *category = dic[categoryId];
    return category[@"image"];
}

@end
