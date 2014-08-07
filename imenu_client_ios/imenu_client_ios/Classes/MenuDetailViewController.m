//
//  MenuDetailViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-27.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "MenuDetailViewController.h"
#import "UIColor+HtmlColor.h"
#import "CartBar.h"
#import "CartData.h"
#import "UserData.h"
#import "Networking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MenuImageViewController.h"
#import "UIViewController+GetTop.h"
#import "MenuPhotoView.h"
#import "TFTools.h"
#import "ClientConfig.h"
#import <ShareSDK/ShareSDK.h>
#import "IMProgressView.h"
#import "IMRefreshView.h"

@interface MenuDetailViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *menuImageView;
@property (nonatomic, strong) UILabel *menuTitle;
@property (nonatomic, strong) UILabel *menuPrice;

@property (nonatomic, strong) UIButton *menuCount;
@property (nonatomic, strong) UILabel *menuImageAuthor;

@property (nonatomic, strong) UIButton *menuOrder;
@property (nonatomic, strong) UILabel *menuState;

@property (nonatomic, strong) CartBar *cartBar;

@property (nonatomic, strong) NSDictionary *storeData;
@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) NSArray *imageList;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) UIScrollView *tableView;
@property (nonatomic, strong) IMRefreshView *refreshView;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL needLoadMore;
@property (nonatomic, strong) NSMutableArray *menuImageViewList;
@property (nonatomic, strong) UIImageView *loadImage;
@property (nonatomic, assign) BOOL isLoadMore;

@end

@implementation MenuDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = @"菜单详情";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_SHOP;
        
        self.menuImageViewList = [NSMutableArray array];
        
        self.loadImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.loadImage.image = [UIImage imageNamed:@"loading_dark.png"];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        self.tableView = scrollView;
        
        float height = TOP_BAR_HEIGHT-50;
        
        self.refreshView = [IMRefreshView createRefreshView];
        self.refreshView.frame = CGRectMake(0, height, 320, 50);
        self.refreshView.hidden = YES;
        self.refreshView.darkTheme = YES;
        [scrollView addSubview:self.refreshView];
        
        height = TOP_BAR_HEIGHT;
        self.menuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
        self.menuImageView.image = [UIImage imageNamed:@"default_big.png"];
        self.menuImageView.userInteractionEnabled = YES;
        [self.menuImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuImage:)]];
        [scrollView addSubview:self.menuImageView];
        
        height += IMAGE_SIZE_BIG;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 60)];
        view.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:view];
        
        self.menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 160, 20)];
        self.menuTitle.backgroundColor = [UIColor clearColor];
        self.menuTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.menuTitle.textAlignment = NSTextAlignmentLeft;
        self.menuTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [view addSubview:self.menuTitle];
        
        self.menuCount = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuCount.frame = CGRectMake(PAGE_MARGIN, 30, 100, 20);
        self.menuCount.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.menuCount setTitle:@"0次/本月" forState:UIControlStateNormal];
        [self.menuCount setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
        [self.menuCount setImage:[UIImage imageNamed:@"shop_order_normal"] forState:UIControlStateNormal];
        self.menuCount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [view addSubview:self.menuCount];
        
        self.menuPrice = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 95, 20)];
        self.menuPrice.backgroundColor = [UIColor clearColor];
        self.menuPrice.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.menuPrice.textAlignment = NSTextAlignmentRight;
        self.menuPrice.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        [view addSubview:self.menuPrice];
        
        self.menuImageAuthor = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 140, 20)];
        self.menuImageAuthor.backgroundColor = [UIColor clearColor];
        self.menuImageAuthor.font = [UIFont systemFontOfSize:10.0f];
        self.menuImageAuthor.textAlignment = NSTextAlignmentRight;
        self.menuImageAuthor.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.menuImageAuthor.textColor = [UIColor colorWithHtmlColor:@"#ccd0d4"];
        [view addSubview:self.menuImageAuthor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        bgView.center = CGPointMake(320-30, 30);
        bgView.backgroundColor = [UIColor colorWithHtmlColor:@"#008fff"];
        [view addSubview:bgView];
        
        self.menuOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuOrder.frame = CGRectMake(view.frame.size.width-52, 0, 43, 43);
        [self.menuOrder setImage:[UIImage imageNamed:@"plus_white@2x.png"] forState:UIControlStateNormal];
        [self.menuOrder setImage:[UIImage imageNamed:@"plus_normal@2x.png"] forState:UIControlStateHighlighted];
        [self.menuOrder addTarget:self action:@selector(onClickOrder) forControlEvents:UIControlEventTouchUpInside];
        self.menuOrder.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.menuOrder.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [view addSubview:self.menuOrder];
        
        self.menuState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
        self.menuState.center = CGPointMake(self.menuOrder.center.x, self.menuOrder.center.y+23);
        self.menuState.backgroundColor = [UIColor clearColor];
        self.menuState.text = @"选菜";
        self.menuState.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.menuState.textAlignment = NSTextAlignmentCenter;
        self.menuState.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
        self.menuState.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [view addSubview:self.menuState];
        
        height += 80;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, 320, 120)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [scrollView addSubview:self.scrollView];
        
        height += 130;
        
        scrollView.contentSize = CGSizeMake(320, height);
        
        self.cartBar = [[CartBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, BOTTOM_BAR_HEIGHT)];
        self.cartBar.presentedViewController = self;
        [self.view addSubview:self.cartBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CartDataChanged:) name:CART_DATA_CHANGED object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    NSString *name = self.data[@"menu_name"];
    NSString *Id = self.menuId;
    NSDictionary *share = [[ClientConfig sharedConfig] getShareStringWithName:name andId:Id from:@"share_menu"];
    NSString *title = type == ShareTypeWeixiTimeline ? share[@"content"] : share[@"title"];
    
    id<ISSContent> publishContent = [ShareSDK content:share[@"content"]
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:self.menuImageView.image quality:1.0f]
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

- (void)setStoreData:(NSDictionary *)storeData
{
    _storeData = storeData;
    
    self.cartBar.storeId = storeData[@"store_id"];
    [self.cartBar refreshCartBar];
}

- (void)setMenuId:(NSString *)menuId
{
    _menuId = menuId;
    
    [self loadMenuData];
}

- (void)loadMenuData
{
    NSDictionary *dic = @{@"menu_id":self.menuId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"store/menu/getMenuDetail"
                                          withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnimation];
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSString *successString = result[@"success"];
                    [self showTips:successString];
                    
                    NSDictionary *resultData = [result[@"data"] lastObject];
                    self.storeData = resultData[@"store_info"];
                    self.data = resultData[@"menu_info"];
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
    
    self.pageIndex = 1;
    [self loadImageList];
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.menuTitle.text = data[@"menu_name"];
    
    NSString *price = data[@"menu_price"];
    float fPrice = [price floatValue];
    self.menuPrice.text = [NSString stringWithFormat:@"￥%.2f/份", fPrice];
    
    [self.menuCount setTitle:[self getMenuCountString:data[@"menu_count"] type:data[@"menu_count_type"]] forState:UIControlStateNormal];
    
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", data[@"menu_image_location"], data[@"menu_image_name"]];
    self.imageUrl = photoUrl;
    
    IMProgressView *progress = [IMProgressView createProgressView];
    progress.center = CGPointMake(CGRectGetWidth(self.menuImageView.frame)/2, CGRectGetHeight(self.menuImageView.frame)/2);
    [self.menuImageView addSubview:progress];
    
    __weak IMProgressView *wProgress = progress;
    [self.menuImageView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_big.png"] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        if (wProgress)
        {
            [wProgress setProgress:receivedSize*1.0f/expectedSize];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (wProgress)
        {
            [wProgress removeFromSuperview];
        }
    }];
    
    NSString *userName = data[@"upload_member_name"];
    if (userName && [userName isKindOfClass:[NSString class]] && userName.length > 0)
    {
        self.menuImageAuthor.text = [NSString stringWithFormat:@"本信息由%@用户上传", userName];
    }
    
    [self refreshCartState];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        if (self.needLoadMore && scrollView.contentOffset.x >= scrollView.contentSize.width - 350)
        {
            [self loadMoreImageList];
        }
        
        return;
    }
    
    if (scrollView.contentOffset.y <= 0)
    {
        self.refreshView.hidden = NO;
        
        if (!self.isLoading)
        {
            self.refreshView.dy = scrollView.contentOffset.y;
            if (scrollView.contentOffset.y <= -50)
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
    if (scrollView.contentOffset.y <= -50)
    {
        if (!self.isLoading)
        {
            [self startAnimation];
            
            [self performSelector:@selector(loadMenuData) withObject:nil afterDelay:0.5f];
        }
    }
}

- (void)startAnimation
{
    self.isLoading = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
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

- (NSString *)getMenuCountString:(NSString *)count type:(NSString *)type
{
    if ([type isEqualToString:@"1"])
    {
        return [NSString stringWithFormat:@"%@次/本日", count];
    }
    else if ([type isEqualToString:@"2"])
    {
        return [NSString stringWithFormat:@"%@次/本周", count];
    }
    else if ([type isEqualToString:@"3"])
    {
        return [NSString stringWithFormat:@"%@次/本月", count];
    }
    else if ([type isEqualToString:@"4"])
    {
        return [NSString stringWithFormat:@"%@次/本季度", count];
    }
    else if ([type isEqualToString:@"5"])
    {
        return [NSString stringWithFormat:@"%@次/本年", count];
    }
    else
    {
        return [NSString stringWithFormat:@"%@次/全部", count];
    }
}

- (void)setImageList:(NSArray *)imageList
{
    _imageList = imageList;
    
    if (self.pageIndex == 1)
    {
        for (MenuPhotoView *photo in self.menuImageViewList)
        {
            [photo removeFromSuperview];
        }
        
        self.menuImageViewList = [NSMutableArray array];
        [self.scrollView setContentOffset:CGPointZero animated:NO];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"HH:mm"];
    
    NSDateFormatter *before = [[NSDateFormatter alloc] init];
    [before setDateFormat:@"yyyy-MM-dd"];
    
    NSString *todayString = [before stringFromDate:[NSDate date]];
    
    for (int i = self.menuImageViewList.count; i < imageList.count; i++)
    {
        NSDictionary *data = imageList[i];
        MenuPhotoView *photo = [[MenuPhotoView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+i*(IMAGE_SIZE_MIDDLE+10),
                                                                               0, IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE)];
        photo.data = data;
        photo.showCommentAndGoods = YES;
        photo.showName = NO;
        photo.tag = 1000+i;
        photo.imageView.image = [UIImage imageNamed:@"default_small.png"];
        NSString *thumbUrl = [TFTools getThumbImageUrlOfLacation:data[@"image_location"]
                                                         andName:data[@"image_name"] ];
        if (thumbUrl && [thumbUrl length] > 0)
        {
            [photo.imageView setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
        }
        [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuImage:)]];
        [self.scrollView addSubview:photo];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+i*(IMAGE_SIZE_MIDDLE+10),
                                                                   IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE, 20)];
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.scrollView addSubview:label];
        
        NSString *imageDate = data[@"member_menu_imag_date"];
        NSDate *date = [dateFormatter dateFromString:imageDate];
        
        label.text = [before stringFromDate:date];
        if ([todayString isEqualToString:label.text])
        {
            label.text = [today stringFromDate:date];
        }
        
        [self.menuImageViewList addObject:photo];
    }
    
    if (self.needLoadMore)
    {
        self.loadImage.center = CGPointMake(PAGE_MARGIN+imageList.count*(IMAGE_SIZE_MIDDLE+10)+50, 60);
        [self.scrollView addSubview:self.loadImage];
        
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 2.0f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        [self.loadImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        self.scrollView.contentSize = CGSizeMake(PAGE_MARGIN*2+(imageList.count+1)*(IMAGE_SIZE_MIDDLE+10)-10, 120);
    }
    else
    {
        [self.loadImage removeFromSuperview];
        [self.loadImage.layer removeAnimationForKey:@"rotationAnimation"];
        self.scrollView.contentSize = CGSizeMake(PAGE_MARGIN*2+imageList.count*(IMAGE_SIZE_MIDDLE+10)-10, 120);
    }
}

- (void)loadMoreImageList
{
    if (self.isLoadMore)
    {
        return;
    }
    
    self.isLoadMore = YES;
    
    self.pageIndex += 1;
    [self loadImageList];
}

- (void)loadImageList
{
    NSDictionary *dic = @{@"menu_id":self.menuId,
                          @"count":@"5",
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex],
                          @"member_id":[UserData sharedUserData].memberId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"store/menu/getMenuInfoList"
                                          withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isLoadMore = NO;
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSString *successString = result[@"success"];
                    [self showTips:successString];
                    
                    NSDictionary *resultData = result[@"data"];
                    NSArray *menuList = resultData[@"member_menu_list"];
                    self.needLoadMore = menuList.count == 5;
                    if (self.pageIndex == 1)
                    {
                        self.imageList = menuList;
                    }
                    else
                    {
                        self.imageList = [self.imageList arrayByAddingObjectsFromArray:menuList];
                    }
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

- (void)onClickOrder
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    
    if (!self.storeData)
    {
        return;
    }
    
    [CartData sharedCartData].storeData = self.storeData;
    
    NSString *menuId = self.data[@"menu_id"];
    if ([[CartData sharedCartData] isOrder:menuId])
    {
        [[CartData sharedCartData] removeMenu:self.data];
    }
    else
    {
        [[CartData sharedCartData] addMenu:self.data];
    }
}

- (void)CartDataChanged:(NSNotification *)notification
{
    [self refreshCartState];
}

- (void)refreshCartState
{
    NSString *storeId = self.storeData[@"store_id"];
    NSString *menuId = self.data[@"menu_id"];
    if ([storeId isEqualToString:[CartData sharedCartData].storeId] && [[CartData sharedCartData] isOrder:menuId])
    {
        self.menuState.text = @"已选";
        [self.menuOrder setImage:[UIImage imageNamed:@"right_white@2x.png"] forState:UIControlStateNormal];
        [self.menuOrder setImage:[UIImage imageNamed:@"right_normal@2x.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.menuState.text = @"选菜";
        [self.menuOrder setImage:[UIImage imageNamed:@"plus_white@2x.png"] forState:UIControlStateNormal];
        [self.menuOrder setImage:[UIImage imageNamed:@"plus_normal@2x.png"] forState:UIControlStateHighlighted];
    }
}

- (void)clickMenuImage:(UIGestureRecognizer *)tap
{
    MenuImageViewController *vc = [[MenuImageViewController alloc] initWithNibName:nil bundle:nil];
    
    if ([tap.view isKindOfClass:[MenuPhotoView class]])
    {
        MenuPhotoView *view = (MenuPhotoView *)tap.view;
        NSUInteger index = view.tag-1000;
        [vc setMenudata:self.imageList ofIndex:index showDynamic:YES];
    }
    else
    {
        [vc setShopData:self.storeData withMenuName:self.menuTitle.text andPrice:self.menuPrice.text andImageUrl:self.imageUrl];
    }
    
    [[self getTopParentViewController] presentViewController:vc animated:YES completion:nil];
}

@end
