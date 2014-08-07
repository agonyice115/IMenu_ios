//
//  ImageBrowserViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-6-30.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewDynamicViewController.h"

@interface ImageBrowserViewController ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *menuImage;

@end

@implementation ImageBrowserViewController

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
        
        self.menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+50, IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
        self.menuImage.image = [UIImage imageNamed:@"default_big.png"];
        [self.view addSubview:self.menuImage];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(240, TOP_BAR_HEIGHT+IMAGE_SIZE_BIG+60, 60, 23);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        [button setTitle:@"重拍" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button addTarget:self action:@selector(rePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:lineView];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, 320, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self.view addSubview:lineView];
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

- (void)backToMainView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setData:(NSDictionary *)data andImage:(UIImage *)image
{
    NSString *url = [NSString stringWithFormat:@"%@%@", data[@"image_location"], data[@"image_name"]];
    if (url && url.length > 0)
    {
        [self.menuImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_big.png"]];
    }
    else
    {
        self.menuImage.image = image;
    }
}

- (void)rePhoto
{
    UIViewController *viewController = self.presentingViewController.childViewControllers.lastObject;
    
    if ([viewController isKindOfClass:[NewDynamicViewController class]])
    {
        NewDynamicViewController *vc = (NewDynamicViewController *)viewController;
        [self dismissViewControllerAnimated:YES completion:^{
            [vc showMenuCamera:self.index];
        }];
    }
}

@end
