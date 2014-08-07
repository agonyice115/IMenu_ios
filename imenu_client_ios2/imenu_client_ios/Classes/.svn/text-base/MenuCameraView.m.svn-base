//
//  MenuCameraView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "MenuCameraView.h"
#import "Common.h"
#import "TFTools.h"
#import "MenuPhotoView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MenuCameraView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UILabel *menuName;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) CGAffineTransform currentTransform;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation MenuCameraView

- (id)initWithFrame:(CGRect)frame
{
    float width = frame.size.width;
    float height = frame.size.height;
    float barHeight = 80.0f;
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, barHeight)];
        self.leftView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self addSubview:self.leftView];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(0, 0, 36, 36);
        [self.cancelButton setImage:[UIImage imageNamed:@"camera_cancel.png"] forState:UIControlStateNormal];
        [self.leftView addSubview:self.cancelButton];
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width-50, barHeight)];
        self.bgView.backgroundColor = [UIColor blackColor];
        [self.leftView addSubview:self.bgView];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 0, 230, barHeight)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.bgView addSubview:self.scrollView];
        
        self.menuImageViewList = [NSMutableArray array];
        
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, height-barHeight, width, barHeight)];
        self.rightView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self addSubview:self.rightView];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.doneButton.frame = CGRectMake(0, 0, 50, 63);
        [self.doneButton setImage:[UIImage imageNamed:@"camera_done.png"] forState:UIControlStateNormal];
        [self.rightView addSubview:self.doneButton];
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoButton.frame = CGRectMake(0, 0, 67, 67);
        [self.photoButton setImage:[UIImage imageNamed:@"camera_photo.png"] forState:UIControlStateNormal];
        [self.rightView addSubview:self.photoButton];
        
        self.albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.albumButton.frame = CGRectMake(0, 0, 50, 63);
        [self.albumButton setImage:[UIImage imageNamed:@"camera_album.png"] forState:UIControlStateNormal];
        [self.rightView addSubview:self.albumButton];
        
        self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.flashButton.frame = CGRectMake(0, 0, 50, 63);
        [self.flashButton setImage:[UIImage imageNamed:@"camera_auto.png"] forState:UIControlStateNormal];
        [self.rightView addSubview:self.flashButton];
        
        self.menuName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        self.menuName.text = @"菜品名称我要长到人们注意我";
        self.menuName.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.menuName.textColor = [UIColor whiteColor];
        self.menuName.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        self.menuName.layer.cornerRadius = 2.0f;
        [self addSubview:self.menuName];
        
        [self createLines];
        
        [self.menuName sizeToFit];
        self.menuName.center = CGPointMake(width-20, height/2);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        self.currentTransform = CGAffineTransformMakeRotation(M_PI*0.5);
        self.cancelButton.center = CGPointMake(width-25, barHeight/2);
        self.menuName.center = CGPointMake(width-20, height/2);
        self.doneButton.center = CGPointMake(35, barHeight/2);
        self.photoButton.center = CGPointMake(width/2-10, barHeight/2);
        self.albumButton.center = CGPointMake(width-105, barHeight/2);
        self.flashButton.center = CGPointMake(width-35, barHeight/2);
    }
    return self;
}

- (void)createLines
{
    CGFloat x1 = 10;
    CGFloat x2 = 310;
    CGFloat y1 = self.frame.size.height/2-150;
    CGFloat y2 = self.frame.size.height/2+150;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x1, y1, 50, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(x2-50, y1, 50, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(x1, y1, 1, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(x2, y1, 1, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(x1, y2, 50, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(x2-49, y2, 50, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(x1, y2-50, 1, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(x2, y2-49, 1, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float barHeight = 80.0f;
    
    NSUInteger count = [self.data count];
    if (orientation == UIDeviceOrientationLandscapeLeft && !CGAffineTransformEqualToTransform(self.currentTransform,
                                                                                              CGAffineTransformMakeRotation(M_PI*0.5)))
    {
        self.currentTransform = CGAffineTransformMakeRotation(M_PI*0.5);
        self.leftView.frame = CGRectMake(0, 0, width, barHeight);
        self.rightView.frame = CGRectMake(0, height-barHeight, width, barHeight);
        
        self.bgView.frame = CGRectMake(0, 0, width-50, barHeight);
        if (count > 4)
        {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-self.scrollView.contentOffset.x-230, 0) animated:NO];
        }
        self.cancelButton.center = CGPointMake(width-25, barHeight/2);
        
        for (int i = 0; i < count; i++)
        {
            float x = count < 4 ? (4-i-1)*(IMAGE_SIZE_SMALL+10) : (count-i-1)*(IMAGE_SIZE_SMALL+10);
            MenuPhotoView *photoView = self.menuImageViewList[i];
            photoView.frame = CGRectMake(x,
                                         (barHeight-IMAGE_SIZE_SMALL)/2,
                                         IMAGE_SIZE_SMALL,
                                         IMAGE_SIZE_SMALL);
        }
        
        self.menuName.center = CGPointMake(width-20, height/2);
        self.doneButton.center = CGPointMake(35, barHeight/2);
        self.photoButton.center = CGPointMake(width/2-10, barHeight/2);
        self.albumButton.center = CGPointMake(width-105, barHeight/2);
        self.flashButton.center = CGPointMake(width-35, barHeight/2);
    }
    else if (orientation == UIDeviceOrientationLandscapeRight && !CGAffineTransformEqualToTransform(self.currentTransform,
                                                                                                    CGAffineTransformMakeRotation(-M_PI*0.5)))
    {
        self.currentTransform = CGAffineTransformMakeRotation(-M_PI*0.5);
        self.leftView.frame = CGRectMake(0, height-barHeight, width, barHeight);
        self.rightView.frame = CGRectMake(0, 0, width, barHeight);
        
        self.bgView.frame = CGRectMake(50, 0, width-50, barHeight);
        if (count > 4)
        {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-self.scrollView.contentOffset.x-230, 0) animated:NO];
        }
        self.cancelButton.center = CGPointMake(25, barHeight/2);
        
        for (int i = 0; i < count; i++)
        {
            MenuPhotoView *photoView = self.menuImageViewList[i];
            photoView.frame = CGRectMake(i*(IMAGE_SIZE_SMALL+10),
                                         (barHeight-IMAGE_SIZE_SMALL)/2,
                                         IMAGE_SIZE_SMALL,
                                         IMAGE_SIZE_SMALL);
        }
        
        self.menuName.center = CGPointMake(20, height/2);
        self.doneButton.center = CGPointMake(width-35, barHeight/2);
        self.photoButton.center = CGPointMake(width/2+10, barHeight/2);
        self.albumButton.center = CGPointMake(105, barHeight/2);
        self.flashButton.center = CGPointMake(35, barHeight/2);
    }
    
    self.cancelButton.transform = self.currentTransform;
    self.doneButton.transform = self.currentTransform;
    self.photoButton.transform = self.currentTransform;
    self.albumButton.transform = self.currentTransform;
    self.flashButton.transform = self.currentTransform;
    self.menuName.transform = self.currentTransform;
    
    for (MenuPhotoView *view in self.menuImageViewList)
    {
        view.transform = self.currentTransform;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    image = [TFTools clippingImage:image withSize:CGSizeMake(IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
    [self setImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImage:(UIImage *)image
{
    UIView *flashView = [[UIView alloc] initWithFrame:self.bounds];
    flashView.backgroundColor = [UIColor whiteColor];
    [self addSubview:flashView];
    
    [UIView animateWithDuration:0.5f animations:^{
        flashView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
    
    MenuPhotoView *photoView = self.menuImageViewList[self.currentIndex];
    photoView.imageView.image = image;
    
    NSNumber *index = [NSNumber numberWithUnsignedInteger:self.currentIndex];
    [self.changedIndexs addObject:index];
    
    if (self.currentIndex+1 < self.menuImageViewList.count)
    {
        [self changeMenuSelectTo:self.currentIndex+1];
    }
}

- (void)setData:(NSArray *)data andIndex:(NSUInteger)index withImageList:(NSArray *)imageList
{
    _data = data;
    self.currentIndex = index;
    
    self.changedIndexs = [NSMutableSet set];
    
    float barHeight = 80.0f;
    
    NSUInteger count = [data count];
    
    for (int i = 0; i < count; i++)
    {
        MenuPhotoView *existView = imageList[i];
        
        NSDictionary *menuData = data[i];
        float x = count < 4 ? (4-i-1)*(IMAGE_SIZE_SMALL+10) : (count-i-1)*(IMAGE_SIZE_SMALL+10);
        MenuPhotoView *photoView = [[MenuPhotoView alloc] initWithFrame:CGRectMake(x,
                                                                                   (barHeight-IMAGE_SIZE_SMALL)/2,
                                                                                   IMAGE_SIZE_SMALL,
                                                                                   IMAGE_SIZE_SMALL)];
        photoView.dishesName.text = menuData[@"menu_name"];
        photoView.data = menuData;
        photoView.tag = 100+i;
        photoView.imageView.image = existView.imageView.image;
        photoView.showDelete = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuCamera:)];
        [photoView addGestureRecognizer:singleTap];
        
        [self.scrollView addSubview:photoView];
        [self.menuImageViewList addObject:photoView];
        
        if (i == index)
        {
            self.menuName.text = menuData[@"menu_name"];
            [self.menuName sizeToFit];
            self.menuName.center = CGPointMake(self.frame.size.width-20, self.frame.size.height/2);
            
            photoView.borderView.layer.borderColor = [UIColor whiteColor].CGColor;
            photoView.borderView.layer.borderWidth = 1;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(count*(IMAGE_SIZE_SMALL+10)-10, IMAGE_SIZE_SMALL);
    if (count > 4)
    {
        [self.scrollView setContentOffset:CGPointMake((IMAGE_SIZE_SMALL+10)*(count-4), 0) animated:NO];
    }
    
    [self onDeviceOrientationChange];
}

- (void)clickMenuCamera:(UIGestureRecognizer *)tap
{
    MenuPhotoView *photoView = (MenuPhotoView *)tap.view;
    [self changeMenuSelectTo:photoView.tag-100];
}

- (void)changeMenuSelectTo:(NSUInteger)index
{
    MenuPhotoView *photoView = self.menuImageViewList[self.currentIndex];
    
    photoView.borderView.layer.borderColor = [UIColor clearColor].CGColor;
    photoView.borderView.layer.borderWidth = 0;
    
    self.currentIndex = index;
    
    photoView = self.menuImageViewList[self.currentIndex];
    
    photoView.borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoView.borderView.layer.borderWidth = 1;
    
    CGPoint center = self.menuName.center;
    self.menuName.text = photoView.dishesName.text;
    [self.menuName sizeToFit];
    self.menuName.center = center;
    
    [self.scrollView scrollRectToVisible:photoView.frame animated:YES];
}

@end
