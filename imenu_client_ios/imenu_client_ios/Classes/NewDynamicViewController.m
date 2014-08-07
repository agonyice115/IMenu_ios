//
//  NewDynamicViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "NewDynamicViewController.h"
#import "Common.h"
#import "LoginButton.h"
#import "UIColor+HtmlColor.h"
#import "BubbleEditView.h"
#import "MenuPhotoView.h"
#import "RoundHeadView.h"
#import "IMPopViewController.h"
#import "MenuCameraView.h"
#import "TFTools.h"
#import "UserData.h"
#import "Networking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IMLoadingView.h"
#import "IMErrorTips.h"
#import "IMNavigationController.h"
#import "DynamicViewController.h"
#import "FirstShowHelpView.h"
#import "NewOrderViewController.h"
#import "ImageBrowserViewController.h"

@interface NewDynamicViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) RoundHeadView *headView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *dynamicTime;
@property (nonatomic, strong) BubbleEditView *dynamicTitle;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *photoUpload;

@property (nonatomic, strong) UIButton *shopName;
@property (nonatomic, strong) UIButton *peopleCount;
@property (nonatomic, strong) UIButton *shopAddress;

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSMutableArray *menuImageViewList;

@property (nonatomic, assign) NSUInteger uploadIndex;
@property (nonatomic, strong) NSArray *changeIndexs;

@property (nonatomic, assign) UIImagePickerControllerCameraFlashMode currentFlashMode;

@end

@implementation NewDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        self.currentFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:scrollView];
        
        float height = TOP_BAR_HEIGHT+10;
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
        self.headView.roundSideWidth = 1.0f;
        self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
        [scrollView addSubview:self.headView];
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN+IMAGE_SIZE_TINY+5,
                                                                  height+IMAGE_SIZE_TINY-SECOND_FONT_SIZE-2,
                                                                  140, SECOND_FONT_SIZE+2)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.text = @"";
        self.userName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [scrollView addSubview:self.userName];
        
        self.dynamicTime = [[UILabel alloc] initWithFrame:CGRectMake(220-PAGE_MARGIN,
                                                                     height+IMAGE_SIZE_TINY-THIRD_FONT_SIZE-2,
                                                                     100, THIRD_FONT_SIZE+2)];
        self.dynamicTime.backgroundColor = [UIColor clearColor];
        self.dynamicTime.text = @"";
        self.dynamicTime.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dynamicTime.textAlignment = NSTextAlignmentRight;
        self.dynamicTime.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [scrollView addSubview:self.dynamicTime];
        
        height += IMAGE_SIZE_TINY+10;
        
        self.dynamicTitle = [[BubbleEditView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, 320-PAGE_MARGIN*2, 120)];
        self.dynamicTitle.placeholder = @"此刻的想法";
        [scrollView addSubview:self.dynamicTitle];
        
        height += 120 + 10;
        
        self.photoUpload = [[UILabel alloc] initWithFrame:CGRectZero];
        self.photoUpload.backgroundColor = [UIColor clearColor];
        self.photoUpload.text = @"";
        self.photoUpload.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.photoUpload.textAlignment = NSTextAlignmentCenter;
        self.photoUpload.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.photoUpload.hidden = YES;
        [scrollView addSubview:self.photoUpload];
        
        self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 60)];
        self.infoView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:self.infoView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(6, 0, 320-PAGE_MARGIN*2, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitle:@"" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"shop_gray"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        button.enabled = NO;
        [self.infoView addSubview:button];
        self.shopName = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(6, 20, 320-PAGE_MARGIN*2, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitle:@"" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"fans_normal"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
        button.enabled = NO;
        [self.infoView addSubview:button];
        self.peopleCount = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(6, 40, 320-PAGE_MARGIN*2, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitle:@"" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"map_normal"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 8)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        button.enabled = NO;
        [self.infoView addSubview:button];
        self.shopAddress = button;
        
        height += 110;
        
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(320, height);
        self.scrollView = scrollView;
        
        // 添加保存动态按钮
        LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width/2, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"cart_view_button5", nil) forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(onClickSave) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        
        // 添加发布动态按钮
        loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, self.view.bounds.size.width/2, BOTTOM_BAR_HEIGHT);
        [loginButton setTitle:NSLocalizedString(@"cart_view_button4", nil) forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(onClickPublish) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        
        // 添加底部按钮分割线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height - BOTTOM_BAR_HEIGHT, 1, BOTTOM_BAR_HEIGHT)];
        view.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [self.view addSubview:view];
        
        [FirstShowHelpView loadHelpView:HELP_DYNAMIC_PUBULISH];
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

- (void)onClickSave
{
    if ([self.dynamicTitle.textField.text length] == 0)
    {
        IMErrorTips *tips = [IMErrorTips showTips:NSLocalizedString(@"dynamic_view_error_tip1", nil) inView:self.view asError:YES];
        [tips hideAfterDelay:2.0];
        return;
    }
    
    [IMLoadingView showLoading];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"member_id"] = [UserData sharedUserData].memberId;
    dic[@"dynamic_id"] = self.dynamicId;
    dic[@"dynamic_type"] = @"2";
    dic[@"title"] = self.dynamicTitle.textField.text;
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/editDynamic" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [IMLoadingView hideLoading];
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    UIViewController *viewController = self.parentViewController.presentingViewController;
                    
                    if ([viewController isKindOfClass:[IMNavigationController class]])
                    {
                        IMNavigationController *baseVC = (IMNavigationController *)viewController;
                        [self.parentViewController dismissViewControllerAnimated:YES completion:^{
                            DynamicViewController *vc = [[DynamicViewController alloc] initWithNibName:nil bundle:nil];
                            vc.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
                            vc.baseNavigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
                            vc.showPublic = NO;
                            vc.viewMemberId = [UserData sharedUserData].memberId;
                            [baseVC pushViewController:vc animated:YES];
                        }];
                    }
                }
            }
        });
    });
}

- (void)onClickPublish
{
    if ([self.dynamicTitle.textField.text length] == 0)
    {
        IMErrorTips *tips = [IMErrorTips showTips:NSLocalizedString(@"dynamic_view_error_tip2", nil) inView:self.view asError:YES];
        [tips hideAfterDelay:2.0];
        return;
    }
    
    [IMLoadingView showLoading];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"member_id"] = [UserData sharedUserData].memberId;
    dic[@"dynamic_id"] = self.dynamicId;
    dic[@"dynamic_type"] = @"1";
    dic[@"title"] = self.dynamicTitle.textField.text;
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/editDynamic" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [IMLoadingView hideLoading];
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    UIViewController *viewController = self.parentViewController.presentingViewController;
                    
                    if ([viewController isKindOfClass:[IMNavigationController class]])
                    {
                        IMNavigationController *baseVC = (IMNavigationController *)viewController;
                        [self.parentViewController dismissViewControllerAnimated:YES completion:^{
                            DynamicViewController *vc = [[DynamicViewController alloc] initWithNibName:nil bundle:nil];
                            [vc setViewMemberId:@""];
                            [baseVC setRootViewController:vc];
                        }];
                    }
                }
            }
        });
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MenuCameraView *view = (MenuCameraView *)self.picker.cameraOverlayView;
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
    image = [TFTools clippingImage:image withSize:CGSizeMake(IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
    [view setImage:image];
}

- (void)clickCancelButton
{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    self.picker = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)clickPhotoButton
{
    [self.picker takePicture];
}

- (void)clickFlashButton
{
    MenuCameraView *view = (MenuCameraView *)self.picker.cameraOverlayView;
    if (self.currentFlashMode == UIImagePickerControllerCameraFlashModeAuto)
    {
        self.currentFlashMode = UIImagePickerControllerCameraFlashModeOn;
        self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        [view.flashButton setImage:[UIImage imageNamed:@"camera_open.png"] forState:UIControlStateNormal];
    }
    else if (self.currentFlashMode == UIImagePickerControllerCameraFlashModeOn)
    {
        self.currentFlashMode = UIImagePickerControllerCameraFlashModeOff;
        self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        [view.flashButton setImage:[UIImage imageNamed:@"camera_close.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.currentFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        [view.flashButton setImage:[UIImage imageNamed:@"camera_auto.png"] forState:UIControlStateNormal];
    }
}

- (void)clickAlbumButton
{
    MenuCameraView *view = (MenuCameraView *)self.picker.cameraOverlayView;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = view;
    [self.picker presentViewController:picker animated:YES completion:nil];
}

- (void)clickDoneButton
{
    MenuCameraView *view = (MenuCameraView *)self.picker.cameraOverlayView;
    NSUInteger count = [view.menuImageViewList count];
    for (int i = 0; i < count; i++)
    {
        MenuPhotoView *sView = view.menuImageViewList[i];
        MenuPhotoView *tView = self.menuImageViewList[i];
        tView.imageView.image = sView.imageView.image;
    }
    self.changeIndexs = [view.changedIndexs allObjects];
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    self.picker = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.uploadIndex = 0;
    [IMLoadingView showLoading];
    [IMLoadingView showText:[NSString stringWithFormat:@"正在上传图片 (%d/%d)", self.uploadIndex+1, self.changeIndexs.count]];
    self.photoUpload.hidden = NO;
    self.photoUpload.text =[NSString stringWithFormat:@"%d已上传/共%d张", self.uploadIndex, self.changeIndexs.count];
    [self uploadMenuImages];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)setDynamicId:(NSString *)dynamicId
{
    _dynamicId = dynamicId;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"member_id"] = [UserData sharedUserData].memberId;
    dic[@"dynamic_id"] = dynamicId;
    dic[@"longitude_num"] = [UserData sharedUserData].longitude;
    dic[@"latitude_num"] = [UserData sharedUserData].latitude;
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/getDynamicDetail" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    self.data = [result[@"data"] lastObject];
                    [self updateData];
                }
            }
        });
    });
}

- (void)updateData
{
    NSDictionary *viewMember = self.data[@"view_member"];
    NSDictionary *storeInfo = self.data[@"store_info"];
    NSDictionary *dynamicInfo = [self.data[@"dynamic_info"] lastObject];
    self.userName.text = viewMember[@"member_name"];
    self.dynamicTime.text = [dynamicInfo[@"dynamic_date"] substringToIndex:16];
    self.dynamicTitle.textField.text = dynamicInfo[@"title"];
    [self.dynamicTitle textViewDidChange:self.dynamicTitle.textField];
    [self.shopName setTitle:storeInfo[@"store_name"] forState:UIControlStateDisabled];
    [self.peopleCount setTitle:[NSString stringWithFormat:@"%@人", dynamicInfo[@"people"]] forState:UIControlStateDisabled];
    [self.shopAddress setTitle:storeInfo[@"address"] forState:UIControlStateDisabled];
    
    NSString *logoUrl = [TFTools getThumbImageUrlOfLacation:viewMember[@"iconLocation"] andName:viewMember[@"iconName"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:logoUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    NSArray *menuList = self.data[@"menu_list"];
    NSUInteger count = [menuList count];
    
    float height = CGRectGetMaxY(self.dynamicTitle.frame)+10;
    
    self.menuImageViewList = [NSMutableArray array];
    for (int i = 0; i < count; i++)
    {
        int row = i/3;
        int col = i%3;
        
        NSDictionary *menuData = menuList[i];
        MenuPhotoView *photoView = [[MenuPhotoView alloc] initWithFrame:CGRectMake(6+col*(IMAGE_SIZE_MIDDLE+4),
                                                                                   height+row*(IMAGE_SIZE_MIDDLE+4),
                                                                                   IMAGE_SIZE_MIDDLE,
                                                                                   IMAGE_SIZE_MIDDLE)];
        photoView.dishesName.text = menuData[@"menu_name"];
        photoView.data = menuData;
        photoView.showCamera = YES;
        photoView.tag = i+100;
        NSString *thumbUrl = [TFTools getThumbImageUrlOfLacation:menuData[@"image_location"]
                                                         andName:menuData[@"image_name"] ];
        if (!self.isHidePhoto && thumbUrl && [thumbUrl length] > 0)
        {
            [photoView.imageView setImageWithURL:[NSURL URLWithString:thumbUrl]];
        }
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuCamera:)];
        [photoView addGestureRecognizer:singleTap];
        
        [self.menuImageViewList addObject:photoView];
        [self.scrollView addSubview:photoView];
    }
    
    height += ((count-1)/3+1)*(IMAGE_SIZE_MIDDLE+4)+10;
    self.photoUpload.frame = CGRectMake(0, height, 320, 20);
    height += 20;
    self.infoView.frame = CGRectMake(0, height, 320, 60);
    height += 110;
    
    self.scrollView.contentSize = CGSizeMake(320, height);
}

- (void)clickMenuCamera:(UIGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag-100;
    
    MenuPhotoView *photoView = (MenuPhotoView *)tap.view;
    if (photoView.imageView.image)
    {
        [self showImageBrowser:index andImage:photoView.imageView.image];
    }
    else
    {
        [self showMenuCamera:index];
    }
}

- (void)showImageBrowser:(NSInteger)index andImage:(UIImage *)image
{
    NSArray *menuList = self.data[@"menu_list"];
    NSDictionary *menuData = menuList[index];
    
    ImageBrowserViewController *vc = [[ImageBrowserViewController alloc] initWithNibName:nil bundle:nil];
    vc.index = index;
    [vc setData:menuData andImage:image];
    [self.parentViewController presentViewController:vc animated:YES completion:nil];
}

- (void)showMenuCamera:(NSInteger)index
{
    MenuCameraView *view = [[MenuCameraView alloc] initWithFrame:self.view.bounds];
    [view.cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [view.flashButton addTarget:self action:@selector(clickFlashButton) forControlEvents:UIControlEventTouchUpInside];
    [view.albumButton addTarget:self action:@selector(clickAlbumButton) forControlEvents:UIControlEventTouchUpInside];
    [view.photoButton addTarget:self action:@selector(clickPhotoButton) forControlEvents:UIControlEventTouchUpInside];
    [view.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [view setData:self.data[@"menu_list"] andIndex:index withImageList:self.menuImageViewList];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = screenSize.height*3/screenSize.width/4;
    CGFloat y = (screenSize.height-screenSize.width*4/3)/2;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraOverlayView = view;
    picker.allowsEditing = NO;
    picker.showsCameraControls = NO;
    picker.cameraViewTransform = CGAffineTransformMakeTranslation(0, y);
    picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale);
    picker.delegate = self;
    self.picker = picker;
    [self.parentViewController presentViewController:picker animated:YES completion:nil];
}

- (void)uploadMenuImages
{
    if (self.uploadIndex >= [self.changeIndexs count])
    {
        [IMLoadingView hideLoading];
        return;
    }
    
    NSNumber *index = self.changeIndexs[self.uploadIndex];
    MenuPhotoView *tView = self.menuImageViewList[index.unsignedIntegerValue];
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"dynamic_id":self.dynamicId,
                          @"menu_id":tView.data[@"menu_id"]};
    
    __weak NewDynamicViewController *wself = self;
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic
                                          withRoute:@"dynamic/dynamic/editMenuImage"
                                          withToken:[UserData sharedUserData].token
                                          withImage:tView.imageView.image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (wself == nil)
            {
                return;
            }
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    wself.uploadIndex += 1;
                    [IMLoadingView showText:[NSString stringWithFormat:@"正在上传图片 (%d/%d)", self.uploadIndex+1, wself.changeIndexs.count]];
                    self.photoUpload.text =[NSString stringWithFormat:@"%d已上传/共%d张", self.uploadIndex, self.changeIndexs.count];
                    [wself uploadMenuImages];
                    return;
                }
            }
            
            [IMLoadingView hideLoading];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"亲，上传图片失败"
                                                               delegate:wself
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"再试一次", nil];
            [alertView show];
        });
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [IMLoadingView showLoading];
        [IMLoadingView showText:[NSString stringWithFormat:@"正在上传图片 (%d/%d)", self.uploadIndex+1, self.changeIndexs.count]];
        [self uploadMenuImages];
    }
}

- (void)showOrder
{
    if (self.orderId)
    {
        IMPopViewController *viewController = [[IMPopViewController alloc] initWithNibName:nil bundle:nil];
        viewController.bottomAnimation = NO;
        
        NewOrderViewController *vc = [[NewOrderViewController alloc] initWithNibName:nil bundle:nil];
        vc.orderId = self.orderId;
        [viewController setRootViewController:vc withTitle:NSLocalizedString(@"order_view_title", nil) animated:NO];
        
        [self.parentViewController presentViewController:viewController animated:YES completion:nil];
    }
}

@end
