//
//  MenuImageViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-2-21.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "MenuImageViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserData.h"
#import "Networking.h"
#import "RoundHeadView.h"
#import "TFTools.h"
#import "DynamicDetailViewController.h"
#import "DynamicMenuDetailViewController.h"
#import "IMNavigationController.h"
#import "MenuDetailViewController.h"
#import "IMProgressView.h"

#define TOP_HEADER_VIEW_HEIGHT 50.0f

@interface MenuImageViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView *menuImage;
@property (nonatomic, strong) UIImage *needSaveImage;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) RoundHeadView *headView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *menuTitle;
@property (nonatomic, strong) UILabel *menuPrice;

@property (nonatomic, strong) UIButton *good;
@property (nonatomic, strong) UIButton *comment;

@property (nonatomic, strong) NSDictionary *menuData;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation MenuImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        
        self.view.backgroundColor = [UIColor blackColor];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(self.view.frame.size.width-PAGE_MARGIN-34, 20.0f, 45.0f, 45.0f);
        [self.closeButton setImage:[UIImage imageNamed:@"close_normal"] forState:UIControlStateNormal];
        [self.closeButton setImage:[UIImage imageNamed:@"close_highlight"] forState:UIControlStateHighlighted];
        [self.closeButton addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.closeButton];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, 320, 410)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.scrollView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:lineView];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, 320, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:lineView];
    }
    return self;
}

- (void)setShopData:(NSDictionary *)data withMenuName:(NSString *)name andPrice:(NSString *)price andImageUrl:(NSString *)url
{
    self.menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT, IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
    self.menuImage.image = [UIImage imageNamed:@"default_big.png"];
    self.menuImage.userInteractionEnabled = YES;
    [self.menuImage addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)]];
    [self.view addSubview:self.menuImage];
    
    self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN,
                                                                    TOP_BAR_HEIGHT+(TOP_HEADER_VIEW_HEIGHT-IMAGE_SIZE_TINY)/2,
                                                                    IMAGE_SIZE_TINY,
                                                                    IMAGE_SIZE_TINY)];
    self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
    self.headView.roundSideWidth = 1.0f;
    [self.view addSubview:self.headView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_TINY+10, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-10, 125, 20)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.text = @"商户名称";
    self.nameLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    [self.view addSubview:self.nameLabel];
    
    self.nameLabel.frame = CGRectMake(PAGE_MARGIN+IMAGE_SIZE_TINY+10, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT/2-10, 250, 20);
    self.nameLabel.text = data[@"store_name"];
    
    self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
    NSString *thumbUrl = [TFTools getThumbImageUrlOfLacation:data[@"store_logo_location"] andName:data[@"store_logo_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:thumbUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    self.menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT+IMAGE_SIZE_BIG+10, 200, 20)];
    self.menuTitle.backgroundColor = [UIColor clearColor];
    self.menuTitle.text = name;
    self.menuTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    self.menuTitle.textAlignment = NSTextAlignmentLeft;
    self.menuTitle.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    [self.view addSubview:self.menuTitle];
    
    self.menuPrice = [[UILabel alloc] initWithFrame:CGRectMake(205, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT+IMAGE_SIZE_BIG+10, 100, 20)];
    self.menuPrice.backgroundColor = [UIColor clearColor];
    self.menuPrice.text = price;
    self.menuPrice.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    self.menuPrice.textAlignment = NSTextAlignmentRight;
    self.menuPrice.textColor = [UIColor colorWithHtmlColor:@"#008fff"];
    [self.view addSubview:self.menuPrice];
    
    [self.menuImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_big.png"]];
}

- (void)setMenudata:(NSArray *)data ofIndex:(NSUInteger)index showDynamic:(BOOL)isShow
{
    self.data = data;
    
    self.scrollView.contentSize = CGSizeMake(320 * data.count, self.scrollView.frame.size.height);
    
    for (int i = 0; i < data.count; i++)
    {
        NSDictionary *menuData = data[i];
        UIView *view = [self getImageView:menuData ofIndex:i showDynamic:isShow];
        [self.scrollView addSubview:view];
    }
    
    [self.scrollView setContentOffset:CGPointMake(index*320, 0) animated:NO];
}

- (UIView *)getImageView:(NSDictionary *)data ofIndex:(NSUInteger)index showDynamic:(BOOL)isShow
{
    NSDictionary *memberInfo = data[@"member_info"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(index*320, 0, 320, self.scrollView.frame.size.height)];
    
    UIImageView *menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_VIEW_HEIGHT, IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
    NSString *url = [NSString stringWithFormat:@"%@%@", data[@"image_location"], data[@"image_name"]];
    
    IMProgressView *progress = [IMProgressView createProgressView];
    progress.center = CGPointMake(CGRectGetWidth(menuImage.frame)/2, CGRectGetHeight(menuImage.frame)/2);
    [menuImage addSubview:progress];
    
    __weak IMProgressView *wProgress = progress;
    [menuImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_big.png"] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
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
    
    menuImage.userInteractionEnabled = YES;
    [menuImage addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)]];
    [view addSubview:menuImage];
    
    RoundHeadView *headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN,
                                                                    (TOP_HEADER_VIEW_HEIGHT-IMAGE_SIZE_TINY)/2,
                                                                    IMAGE_SIZE_TINY,
                                                                    IMAGE_SIZE_TINY)];
    headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
    headView.roundSideWidth = 1.0f;
    NSString *thumbUrl = [TFTools getThumbImageUrlOfLacation:memberInfo[@"iconLocation"] andName:memberInfo[@"iconName"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:thumbUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     headView.headPic = image;
                                                 }
                                             }];
    [view addSubview:headView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_TINY+10, TOP_HEADER_VIEW_HEIGHT/2-10, 125, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = memberInfo[@"member_name"];
    nameLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    [view addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-PAGE_MARGIN-125, TOP_HEADER_VIEW_HEIGHT/2-7, 125, 20)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.text = [data[@"member_menu_imag_date"] substringToIndex:16];
    timeLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    [view addSubview:timeLabel];
    
    if (isShow)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30, TOP_HEADER_VIEW_HEIGHT+IMAGE_SIZE_BIG+10, 60, 23);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitle:@"动态" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"dynamic_white"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button addTarget:self action:@selector(goUserDynamic:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000+index;
        [view addSubview:button];
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30, TOP_HEADER_VIEW_HEIGHT+IMAGE_SIZE_BIG+10, 160, 20);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitle:data[@"menu_name"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(goMenuDetail:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000+index;
        [view addSubview:button];
    }
    
    UIButton *good = [UIButton buttonWithType:UIButtonTypeCustom];
    good.frame = CGRectMake(210, TOP_HEADER_VIEW_HEIGHT+IMAGE_SIZE_BIG+9, 50, 23);
    good.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
    [good setTitle:data[@"goods_count"] forState:UIControlStateNormal];
    [good setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
    [good setImage:[UIImage imageNamed:@"good_white"] forState:UIControlStateNormal];
    good.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [good addTarget:self action:@selector(goMenuDynamic:) forControlEvents:UIControlEventTouchUpInside];
    good.tag = 1000+index;
    [view addSubview:good];
    
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
    comment.frame = CGRectMake(260, TOP_HEADER_VIEW_HEIGHT+IMAGE_SIZE_BIG+9, 50, 23);
    comment.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
    [comment setTitle:data[@"comment_count"] forState:UIControlStateNormal];
    [comment setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
    [comment setImage:[UIImage imageNamed:@"comment_white"] forState:UIControlStateNormal];
    comment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [comment addTarget:self action:@selector(goMenuDynamic:) forControlEvents:UIControlEventTouchUpInside];
    comment.tag = 1000+index;
    [view addSubview:comment];
    
    return view;
}

- (void)backToMainView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePhoto:(UIGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateBegan)
    {
        UIImageView *imageView = (UIImageView *)tap.view;
        self.needSaveImage = imageView.image;
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                             destructiveButtonTitle:NSLocalizedString(@"tip_button_save_photo", nil)
                                                  otherButtonTitles:nil];
        sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        return;
    }
    
    // 保存到相册
    UIImageWriteToSavedPhotosAlbum(self.needSaveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        NSLog(@"保存成功");
    }
    else
    {
        NSLog(@"%@", error);
    }
}

- (void)goUserDynamic:(id)sender
{
    UIButton *button = sender;
    UIViewController *viewController = self.presentingViewController;
    
    if ([viewController isKindOfClass:[IMNavigationController class]])
    {
        IMNavigationController *baseVC = (IMNavigationController *)viewController;
        NSDictionary *menuData = self.data[button.tag-1000];
        NSString *dynamicId = menuData[@"dynamic_id"];
        [self dismissViewControllerAnimated:YES completion:^{
            DynamicDetailViewController *vc = [[DynamicDetailViewController alloc] initWithNibName:nil bundle:nil];
            vc.dynamicId = dynamicId;
            [baseVC pushViewController:vc animated:YES];
        }];
    }
}

- (void)goMenuDetail:(id)sender
{
    UIButton *button = sender;
    UIViewController *viewController = self.presentingViewController;
    
    if ([viewController isKindOfClass:[IMNavigationController class]])
    {
        IMNavigationController *baseVC = (IMNavigationController *)viewController;
        NSDictionary *menuData = self.data[button.tag-1000];
        NSString *menuId = menuData[@"menu_id"];
        [self dismissViewControllerAnimated:YES completion:^{
            MenuDetailViewController *vc = [[MenuDetailViewController alloc] initWithNibName:nil bundle:nil];
            vc.menuId = menuId;
            [baseVC pushViewController:vc animated:YES];
        }];
    }
}

- (void)goMenuDynamic:(id)sender
{
    UIButton *button = sender;
    DynamicMenuDetailViewController *vc = [[DynamicMenuDetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.data = self.data[button.tag-1000];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
