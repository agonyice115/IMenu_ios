//
//  ShopDetailsViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-24.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopDetailsViewController.h"
#import "RoundHeadView.h"
#import "LongBarButton.h"
#import "IMConfig.h"
#import "UIColor+HtmlColor.h"
#import "FansViewController.h"
#import "Networking.h"
#import "UserData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ShopDescriptionCell.h"
#import "ShopServiceCell.h"
#import "ClientConfig.h"
#import "ShopMenuViewController.h"
#import "IMPopViewController.h"
#import "ShopAddressViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ShopDynamicViewController.h"
#import "TFTools.h"
#import "IMRefreshView.h"
#import "RecommendViewController.h"

#define TOP_HEADER_VIEW_HEIGHT 130.0f

@interface FlagView : UIView

@end

@implementation FlagView

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *fillColor = [IMConfig sharedConfig].bgColor;
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextFillPath(context);
}

@end



@interface ShopDetailsViewController () <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) RoundHeadView *headPicView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *popularView;
@property (nonatomic, strong) NSMutableArray *popularViews;

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UIButton *shopPrice;
@property (nonatomic, strong) UIButton *shopTime;

@property (nonatomic, strong) UIImageView *payTypeImageView;
@property (nonatomic, strong) UIImageView *saleImageView;

@property (nonatomic, strong) UIButton *shopRecommend;
@property (nonatomic, strong) UIButton *shopMenu;

@property (nonatomic, strong) LongBarButton *shopFans;
@property (nonatomic, strong) LongBarButton *shopBrowse;
@property (nonatomic, strong) LongBarButton *shopAddress;
@property (nonatomic, strong) LongBarButton *shopTel;
@property (nonatomic, strong) LongBarButton *shopOrder;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *currentButton;
@property (nonatomic, strong) FlagView *flagView;
@property (nonatomic, assign) NSUInteger flagIndex;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSArray *environment;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) IMRefreshView *refreshView;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation ShopDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"store_details_title", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_SHOP;
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-160,
                                                                       IMAGE_SIZE_BIG,
                                                                       IMAGE_SIZE_BIG)];
        self.photoView.image = [UIImage imageNamed:@"default_shop.png"];
        self.photoView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.photoView];
        
        [self createHeadView];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT+30,
                                                                       320,
                                                                       self.view.bounds.size.height-TOP_BAR_HEIGHT-TOP_HEADER_VIEW_HEIGHT-30)
                                                      style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.allowsSelection = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        
        [self createTableHeaderView];
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

- (BOOL)onNavigationItemClicked:(IM_NAVIGATION_ITEM_ID)navigationItemId
{
    if ([super onNavigationItemClicked:navigationItemId])
    {
        return YES;
    }
    
    switch (navigationItemId)
    {
        case IM_NAVIGATION_ITEM_SHARE_FRIENDS:
            [self shareShopWithType:ShareTypeWeixiTimeline];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_WECHAT:
            [self shareShopWithType:ShareTypeWeixiSession];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_RENREN:
            [self shareShopWithType:ShareTypeRenren];
            break;
            
        case IM_NAVIGATION_ITEM_SHARE_SINA:
            [self shareShopWithType:ShareTypeSinaWeibo];
            break;
            
        default:
            return NO;
            break;
    }
    
    return YES;
}

- (void)shareShopWithType:(ShareType)type
{
    NSString *name = self.data[@"store_name"];
    NSString *Id = self.data[@"store_id"];
    NSDictionary *share = [[ClientConfig sharedConfig] getShareStringWithName:name andId:Id from:@"share_store"];
    
    NSString *title = type == ShareTypeWeixiTimeline ? share[@"content"] : share[@"title"];
    
    id<ISSContent> publishContent = [ShareSDK content:share[@"content"]
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:self.headPicView.headPic quality:1.0f]
                                                title:title
                                                  url:share[@"link"]
                                          description:share[@"description"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:publishContent type:type authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (error)
        {
            NSLog(@"[%d]%@", error.errorCode, error.errorDescription);
        }
        if (SSResponseStateSuccess == state)
        {
            self.navigationBarType = self.baseNavigationBarType;
            [[self getIMNavigationController].navigationBarView setNavigationBarType:self.navigationBarType animated:YES fromTop:NO];
        }
    }];
}

- (void)createHeadView
{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-160, 320, 320)];
    self.headView.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.5f alpha:0.3f];
    [self.view addSubview:self.headView];
    
    float height = 60.0f;
    
    self.refreshView = [IMRefreshView createRefreshView];
    self.refreshView.frame = CGRectMake(0, height, 320, 50);
    self.refreshView.hidden = YES;
    [self.headView addSubview:self.refreshView];
    
    height += 50.0f;
    self.headPicView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN,
                                                                       height,
                                                                       IMAGE_SIZE_MIDDLE,
                                                                       IMAGE_SIZE_MIDDLE)];
    self.headPicView.headPic = [UIImage imageNamed:@"shop_logo_big.png"];
    [self.headView addSubview:self.headPicView];
    
    float x = PAGE_MARGIN*2 + 100;
    self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 130, 50)];
    self.shopName.text = @"袁老大肉夹馍";
    self.shopName.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
    self.shopName.textColor = [UIColor whiteColor];
    self.shopName.backgroundColor = [UIColor clearColor];
    self.shopName.textAlignment = NSTextAlignmentLeft;
    self.shopName.numberOfLines = 2;
    [self.headView addSubview:self.shopName];
    
    UIImageView *payType = [[UIImageView alloc] initWithFrame:CGRectMake(320-52, height+5, 52, 24)];
    payType.image = [UIImage imageNamed:@"shop_pay_online"];
    payType.hidden = YES;
    [self.headView addSubview:payType];
    self.payTypeImageView = payType;
    
    UIImageView *sale = [[UIImageView alloc] initWithFrame:CGRectMake(320-52, height+30, 52, 24)];
    sale.image = [UIImage imageNamed:@"shop_sale"];
    sale.hidden = YES;
    [self.headView addSubview:sale];
    self.saleImageView = sale;
    
    height += 50.0f;
    self.popularView = [[UIView alloc] initWithFrame:CGRectMake(x, height, 120, 20)];
    self.popularView.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:self.popularView];
    
    self.popularViews = [NSMutableArray array];
    for (int i = 0; i < 5; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        imageView.center = CGPointMake(7+i*15, 10);
        imageView.image = [UIImage imageNamed:@"popular_dark.png"];
        [self.popularView addSubview:imageView];
        [self.popularViews addObject:imageView];
    }
    
    height += 20.0f;
    self.shopPrice = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shopPrice.frame = CGRectMake(x, height, 160, 20);
    self.shopPrice.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [self.shopPrice setTitle:@"暂无" forState:UIControlStateNormal];
    [self.shopPrice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shopPrice setImage:[UIImage imageNamed:@"price"] forState:UIControlStateNormal];
    self.shopPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.headView addSubview:self.shopPrice];
    
    height += 20.0f;
    self.shopTime = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shopTime.frame = CGRectMake(x, height, 160, 20);
    self.shopTime.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [self.shopTime setTitle:@"暂无" forState:UIControlStateNormal];
    [self.shopTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shopTime setImage:[UIImage imageNamed:@"time"] forState:UIControlStateNormal];
    self.shopTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.headView addSubview:self.shopTime];
    
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followButton.frame = CGRectMake(0, 0, 60, 25);
    self.followButton.center = CGPointMake(320-PAGE_MARGIN-30, height);
    self.followButton.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    self.followButton.layer.cornerRadius = 2.0f;
    self.followButton.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5f];
    self.followButton.hidden = YES;
    [self.followButton addTarget:self action:@selector(clickFollowButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.followButton];
    
    height += 25.0f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 10, 10)];
    label.backgroundColor = [UIColor redColor];
    label.text = @"菜品八折";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [label sizeToFit];
    [self.headView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+60, height, 10, 10)];
    label.backgroundColor = [UIColor redColor];
    label.text = @"满200减10";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    [label sizeToFit];
    [self.headView addSubview:label];
}

- (void)createTableHeaderView
{
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, MIDDLE_BAR_HEIGHT*5+20)];
    tableHeader.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.tableView.tableHeaderView = tableHeader;
    
    float height = 0.0f;
    LongBarButton *longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 160, MIDDLE_BAR_HEIGHT)];
    longBarButton.title.text = @"0粉丝";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    imageView.image = [UIImage imageNamed:@"fans_normal@2x.png"];
    [longBarButton setIconView:imageView];
    [longBarButton setNoSubTitle];
    longBarButton.normalIcon = imageView.image;
    //longBarButton.highlightIcon = [UIImage imageNamed:@"order_highlight@2x.png"];
    [longBarButton setTarget:self action:@selector(onClickFans)];
    [tableHeader addSubview:longBarButton];
    self.shopFans = longBarButton;
    
    longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(161, height, 159, MIDDLE_BAR_HEIGHT)];
    longBarButton.title.text = @"0浏览";
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    imageView.image = [UIImage imageNamed:@"follow_normal@2x.png"];
    [longBarButton setIconView:imageView];
    [longBarButton setNoSubTitle];
    longBarButton.normalIcon = imageView.image;
    //longBarButton.highlightIcon = [UIImage imageNamed:@"order_highlight@2x.png"];
    [longBarButton setTarget:self action:@selector(onClickBrowse)];
    [tableHeader addSubview:longBarButton];
    self.shopBrowse = longBarButton;
    
    height += MIDDLE_BAR_HEIGHT + 1.0f;
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    tempView.backgroundColor = [UIColor whiteColor];
    [tableHeader addSubview:tempView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(PAGE_MARGIN, 3, 130, 39);
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 5.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [button setTitle:@"店长推荐" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickRecommend) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:button];
    button.hidden = YES;
    self.shopRecommend = button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(PAGE_MARGIN, 3, 290, 39);
    button.layer.cornerRadius = 5.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#d6edfd"];
    [button setTitle:@"查看菜单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#2798f4"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickMenu) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:button];
    self.shopMenu = button;
    
    height += MIDDLE_BAR_HEIGHT + 1.0f;
    longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    longBarButton.title.text = @"暂无";
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 13)];
    imageView.image = [UIImage imageNamed:@"map_normal@2x.png"];
    [longBarButton setIconView:imageView];
    [longBarButton setNoSubTitle];
    longBarButton.normalIcon = imageView.image;
    longBarButton.highlightIcon = [UIImage imageNamed:@"map_highlight@2x.png"];
    [longBarButton setTarget:self action:@selector(onClickAddress)];
    [tableHeader addSubview:longBarButton];
    self.shopAddress = longBarButton;
    
    height += MIDDLE_BAR_HEIGHT + 1.0f;
    longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    longBarButton.title.text = @"暂无";
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView.image = [UIImage imageNamed:@"phone_normal@2x.png"];
    [longBarButton setIconView:imageView];
    [longBarButton setNoSubTitle];
    longBarButton.normalIcon = imageView.image;
    longBarButton.highlightIcon = [UIImage imageNamed:@"phone_highlight@2x.png"];
    [longBarButton setTarget:self action:@selector(onClickTel)];
    [tableHeader addSubview:longBarButton];
    self.shopTel = longBarButton;
    
    height += MIDDLE_BAR_HEIGHT + 1.0f;
    longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    longBarButton.title.text = @"0单/本月";
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView.image = [UIImage imageNamed:@"shop_order_normal@2x.png"];
    [longBarButton setIconView:imageView];
    [longBarButton setNoSubTitle];
    longBarButton.normalIcon = imageView.image;
    longBarButton.highlightIcon = [UIImage imageNamed:@"shop_order_highlight@2x.png"];
    [longBarButton setTarget:self action:@selector(onClickOrder)];
    [tableHeader addSubview:longBarButton];
    self.shopOrder = longBarButton;
    
    height += MIDDLE_BAR_HEIGHT;
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    shadowView.backgroundColor = [UIColor lightGrayColor];
    [tableHeader addSubview:shadowView];
}

- (void)updateData
{
    NSString *vipLevel = self.data[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.headPicView.vipPic = [UIImage imageNamed:[NSString stringWithFormat:@"shop_vip_%@@2x.png", vipLevel]];
    }
    
    NSString *logoUrl = [NSString stringWithFormat:@"%@%@", self.data[@"store_logo_location"], self.data[@"store_logo_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:logoUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headPicView.headPic = image;
                                                 }
                                             }];
    
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", self.data[@"store_dynamic_location"], self.data[@"store_dynamic_name"]];
    [self.photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_shop.png"]];
    
    NSString *popular = self.data[@"star"];
    int i = 0;
    for (i = 0; i < popular.intValue; i++)
    {
        UIImageView *imageView = self.popularViews[i];
        imageView.image = [UIImage imageNamed:@"popular_light.png"];
    }
    for (i = popular.intValue; i < 5; i++)
    {
        UIImageView *imageView = self.popularViews[i];
        imageView.image = [UIImage imageNamed:@"popular_dark.png"];
    }
    
    NSString *payType = self.data[@"signing_type"];
    if (payType.intValue == 0)
    {
        self.payTypeImageView.hidden = YES;
    }
    else
    {
        self.payTypeImageView.hidden = NO;
        if (payType.intValue == 1)
        {
            self.payTypeImageView.image = [UIImage imageNamed:@"shop_pay_online"];
        }
        else
        {
            self.payTypeImageView.image = [UIImage imageNamed:@"shop_pay_store"];
        }
    }
    
    NSString *sale = self.data[@"coupon_type"];
    if (sale.intValue == 0)
    {
        self.saleImageView.hidden = YES;
    }
    else
    {
        self.saleImageView.hidden = NO;
    }
    
    NSArray *recommend = self.data[@"recommend_list"];
    if (recommend.count > 0)
    {
        self.shopRecommend.hidden = NO;
        self.shopMenu.frame = CGRectMake(PAGE_MARGIN+160, 3, 130, 39);
    }
    else
    {
        self.shopRecommend.hidden = YES;
        self.shopMenu.frame = CGRectMake(PAGE_MARGIN, 3, 290, 39);
    }
    
    [self.shopPrice setTitle:[NSString stringWithFormat:@"%@/人均", self.data[@"per"]] forState:UIControlStateNormal];
    [self.shopTime setTitle:self.data[@"hours"] forState:UIControlStateNormal];
    
    [self updateFollowStatus];
    
    self.shopFans.title.text = [NSString stringWithFormat:@"%@粉丝", [TFTools getFansString:self.data[@"followered_count"]]];
    self.shopBrowse.title.text = [NSString stringWithFormat:@"%@浏览", [TFTools getFansString:self.data[@"view_count"]]];
    if ([self.data[@"address"] length] > 0) self.shopAddress.title.text = self.data[@"address"];
    if ([self.data[@"tel_1"] length] > 0) self.shopTel.title.text = self.data[@"tel_1"];
    self.shopOrder.title.text = [self getOrderCountString:self.data[@"dynamic_count"] type:self.data[@"dynamic_count_type"]];
    
    self.services = [[ClientConfig sharedConfig] getServiceList:self.data[@"service_list"]];
    self.environment = [[ClientConfig sharedConfig] getEnvironmentList:self.data[@"environment_list"]];
    
    [self clickSection:self.currentButton];
}

- (NSString *)getOrderCountString:(NSString *)count type:(NSString *)type
{
    if ([type isEqualToString:@"1"])
    {
        return [NSString stringWithFormat:@"%@单/本日", count];
    }
    else if ([type isEqualToString:@"2"])
    {
        return [NSString stringWithFormat:@"%@单/本周", count];
    }
    else if ([type isEqualToString:@"3"])
    {
        return [NSString stringWithFormat:@"%@单/本月", count];
    }
    else if ([type isEqualToString:@"4"])
    {
        return [NSString stringWithFormat:@"%@单/本季度", count];
    }
    else if ([type isEqualToString:@"5"])
    {
        return [NSString stringWithFormat:@"%@单/本年", count];
    }
    else
    {
        return [NSString stringWithFormat:@"%@单/全部", count];
    }
}

- (void)setStoreId:(NSString *)storeId andStoreName:(NSString *)storeName
{
    self.shopName.text = storeName;
    [self loadStoreData:storeId];
    self.isLoading = YES;
}

- (void)loadStoreData:(NSString *)storeId
{
    NSDictionary *dic = @{@"store_id":storeId,
                          @"member_id":[UserData sharedUserData].memberId,
                          @"longitude_num":[UserData sharedUserData].longitude,
                          @"latitude_num":[UserData sharedUserData].latitude};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"store/store/getStoreDetails"
                                          withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnimation];
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSString *successString = result[@"success"];
                    [self showTips:successString];
                    
                    _data = result[@"data"];
                    [self updateData];
                }
                else
                {
                    [self showTips:errorString];
                }
            }
            else
            {
                [self showTips:NSLocalizedString(@"networking_error", nil)];
            }
        });
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.flagIndex == 3)
    {
        return 400.0;
    }
    else
    {
        int count = 1;
        if (self.flagIndex == 1)
        {
            count = self.services.count;
        }
        else
        {
            count = self.environment.count;
        }
        count = (count-1)/4 + 1;
        return count * 100 + 20;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.flagIndex == 3)
    {
        ShopDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDescriptionCell"];
        if (cell == nil)
        {
            cell = [[ShopDescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopDescriptionCell"];
        }
        [cell setContentString:self.data[@"description"]];
        return cell;
    }
    else
    {
        ShopServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopServiceCell"];
        if (cell == nil)
        {
            cell = [[ShopServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopServiceCell"];
        }
        if (self.flagIndex == 1)
        {
            [cell setServiceData:self.services];
        }
        else
        {
            [cell setEnvironmentData:self.environment];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [IMConfig sharedConfig].bgColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(PAGE_MARGIN, 0, 80, 30);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
    [button setTitle:@"商家服务" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#eeeeee"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.selected = YES;
    button.tag = 1;
    [button addTarget:self action:@selector(clickSection:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.currentButton = button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(120, 0, 80, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [button setTitle:@"商家氛围" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#eeeeee"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.selected = NO;
    button.tag = 2;
    [button addTarget:self action:@selector(clickSection:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(320-PAGE_MARGIN-80, 0, 80, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [button setTitle:@"商家活动" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#eeeeee"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.selected = NO;
    button.tag = 3;
    [button addTarget:self action:@selector(clickSection:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    FlagView *flag = [[FlagView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+32, 29, 16, 10)];
    flag.backgroundColor = [UIColor clearColor];
    [view addSubview:flag];
    self.flagView = flag;
    
    return view;
}

- (void)clickSection:(id)sender
{
    self.currentButton.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    self.currentButton.selected = NO;
    
    UIButton *button = sender;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
    button.selected = YES;
    self.currentButton = button;
    self.flagIndex = button.tag;
    
    [UIView animateWithDuration:0.2f animations:^{
        CGPoint center = button.center;
        center.y += 19;
        self.flagView.center = center;
    }];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        self.refreshView.hidden = NO;
        
        CGPoint center = self.headView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-scrollView.contentOffset.y)/2;
        self.headView.center = center;
        
        center = self.photoView.center;
        center.y = TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-scrollView.contentOffset.y)/2;
        self.photoView.center = center;
        
        if (!self.isLoading)
        {
            self.refreshView.dy = scrollView.contentOffset.y;
            if (scrollView.contentOffset.y <= -80)
            {
                self.refreshView.refreshState = REFRESH_RELEASE;
            }
            else
            {
                self.refreshView.refreshState = REFRESH_PULL;
            }
        }
    }
    
    if (scrollView.contentOffset.y >= 0)
    {
        self.refreshView.hidden = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y <= -80)
    {
        if (!self.isLoading)
        {
            [self startAnimation];
            
            [self performSelector:@selector(loadStoreData:) withObject:self.data[@"store_id"] afterDelay:0.5f];
        }
    }
}

- (void)startAnimation
{
    self.isLoading = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    self.tableView.userInteractionEnabled = NO;
    
    self.refreshView.refreshState = REFRESH_NOW;
}

- (void)stopAnimation
{
    self.isLoading = NO;
    self.refreshView.refreshState = REFRESH_PULL;
    self.refreshView.lastUpdateTime = [NSDate date];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.tableView setContentOffset:CGPointZero animated:NO];
    } completion:^(BOOL finished) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.userInteractionEnabled = YES;
    }];
}

- (void)onClickFans
{
    if (!self.data)
    {
        return;
    }
    
    NSString *fans = self.data[@"followered_count"];
    if (fans.intValue > 0)
    {
        FansViewController *vc = [[FansViewController alloc] initWithNibName:nil bundle:nil];
        vc.data = @{@"followed_member_id":@"",
                    @"followed_store_id":self.data[@"store_id"],
                    @"name":self.data[@"store_name"]};
        [[self getIMNavigationController] pushViewController:vc animated:YES];
    }
}

- (void)onClickBrowse
{
}

- (void)onClickAddress
{
    if (!self.data)
    {
        return;
    }
    
    IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
    viewController.bottomAnimation = NO;
    
    ShopAddressViewController *vc = [[ShopAddressViewController alloc] initWithNibName:nil bundle:nil];
    vc.data = self.data;
    [viewController setRootViewController:vc withTitle:@"商家位置" animated:NO];
    
    [[self getIMNavigationController] presentViewController:viewController animated:YES completion:nil];
}

- (void)onClickTel
{
    if (!self.data)
    {
        return;
    }
    
    if ([self.shopTel.title.text isEqualToString:@"暂无"])
    {
        return;
    }
    
    if ([self.data[@"tel_2"] length] > 0)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                             destructiveButtonTitle:self.data[@"tel_1"]
                                                   otherButtonTitles:self.data[@"tel_2"], nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                             destructiveButtonTitle:self.data[@"tel_1"]
                                                  otherButtonTitles:nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        return;
    }
    
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.shopTel.title.text]]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.data[@"tel_2"]]]];
    }
}

- (void)onClickOrder
{
    if (!self.data)
    {
        return;
    }
    
    if ([self.data[@"dynamic_count"] isEqualToString:@"0"])
    {
        return;
    }
    
    ShopDynamicViewController *vc = [[ShopDynamicViewController alloc] initWithNibName:nil bundle:nil];
    vc.storeId = self.data[@"store_id"];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)onClickRecommend
{
    RecommendViewController *vc = [[RecommendViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)onClickMenu
{
    if (!self.data)
    {
        return;
    }
    ShopMenuViewController *vc = [[ShopMenuViewController alloc] initWithNibName:nil bundle:nil];
    vc.storeData = [self getStoreData:self.data];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (NSDictionary *)getStoreData:(NSDictionary *)data
{
    NSMutableDictionary *storeData = [NSMutableDictionary dictionary];
    storeData[@"store_id"] = data[@"store_id"];
    storeData[@"store_name"] = data[@"store_name"];
    storeData[@"store_logo_name"] = data[@"store_logo_name"];
    storeData[@"store_logo_location"] = data[@"store_logo_location"];
    storeData[@"vip_level"] = data[@"vip_level"];
    return storeData;
}

- (void)clickFollowButton
{
    NSString *followStatus = self.data[@"follow_status"];
    NSString *status = followStatus.intValue > 0 ? @"0" : @"1";
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"following_member_id":@"",
                          @"following_store_id":self.data[@"store_id"],
                          @"following_status":status};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"member/member/editFollowingStatus"
                                          withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSString *successString = result[@"success"];
                    [self showTips:successString];
                    
                    NSDictionary *resultData = result[@"data"];
                    NSMutableDictionary *data = [self.data mutableCopy];
                    data[@"follow_status"] = resultData[@"follow_status"];
                    _data = data;
                    
                    [self updateFollowStatus];
                }
                else
                {
                    [self showTips:errorString];
                }
            }
            else
            {
                [self showTips:NSLocalizedString(@"networking_error", nil)];
            }
        });
    });
}

- (void)updateFollowStatus
{
    NSString *followStatus = self.data[@"follow_status"];
    if (followStatus && [followStatus length] > 0)
    {
        self.followButton.hidden = NO;
        if (followStatus.intValue == 0)
        {
            [self.followButton setTitle:@"未关注" forState:UIControlStateNormal];
        }
        else if (followStatus.intValue == 1)
        {
            [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        }
        else
        {
            [self.followButton setTitle:@"相互关注" forState:UIControlStateNormal];
        }
    }
}

@end
