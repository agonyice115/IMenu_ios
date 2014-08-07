//
//  GeneralSettingViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-17.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "GeneralSettingViewController.h"
#import "LongBarButton.h"
#import "IMConfig.h"
#import "ClientConfig.h"
#import "UIColor+HtmlColor.h"
#import "SkinViewController.h"
#import "TFTools.h"
#import "Networking.h"
#import <SDWebImage/SDImageCache.h>

@interface GeneralSettingViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) LongBarButton *clearButton;

@end

@implementation GeneralSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationTitle = NSLocalizedString(@"setting_view_subtitle2", nil);
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_MINE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float height = TOP_BAR_HEIGHT + 10.0f;
    LongBarButton *longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    [longBarButton setNoRightMore];
    longBarButton.title.text = NSLocalizedString(@"setting_view_skin_select", nil);
    longBarButton.subTitle.text = @"更多";
    [longBarButton setTarget:self action:@selector(clickMoreButton)];
    [self.view addSubview:longBarButton];
    
    height += MIDDLE_BAR_HEIGHT + 5.0f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    
    self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.selectImageView.image = [UIImage imageNamed:@"select.png"];
    [view addSubview:self.selectImageView];
    
    self.colorArray = [NSMutableArray array];
    NSArray *skinData = [NSArray arrayWithContentsOfFile:[TFTools getDocumentPathOfFile:[CONFIG_VERSION_NAME_SKIN stringByAppendingPathExtension:@"plist"]]];
    BOOL isSetSkinColor = NO;
    for (NSDictionary *data in skinData)
    {
        [self.colorArray addObject:data[@"client_skin_value"]];
        
        if ([self.colorArray count] >= 5)
        {
            break;
        }
        
        if (isSetSkinColor)
        {
            continue;
        }
        
        if ([[IMConfig sharedConfig].bgColorString isEqualToString:data[@"client_skin_value"]])
        {
            isSetSkinColor = YES;
        }
    }
    
    if (!isSetSkinColor)
    {
        self.colorArray[0] = [IMConfig sharedConfig].bgColorString;
    }
    
    for (int i = 0; i < 5; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN + ((320-PAGE_MARGIN*2-36*5)/4+36)*i, (MIDDLE_BAR_HEIGHT-36)/2, 36, 36);
        button.backgroundColor = [UIColor colorWithHtmlColor:self.colorArray[i]];
        [button addTarget:self action:@selector(clickColorButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [view addSubview:button];
        
        if ([[IMConfig sharedConfig].bgColorString isEqualToString:self.colorArray[i]])
        {
            self.selectImageView.center = CGPointMake(button.frame.origin.x+button.frame.size.width,
                                                      button.frame.origin.y+button.frame.size.height-8);
        }
    }
    
    [view bringSubviewToFront:self.selectImageView];
    [self.view addSubview:view];
    
    height += MIDDLE_BAR_HEIGHT + 20.0f;
    longBarButton = [[LongBarButton alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    [longBarButton setNoRightMore];
    longBarButton.title.text = NSLocalizedString(@"setting_view_clear_cache", nil);
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        unsigned long long size = [[SDImageCache sharedImageCache] getSize];
        float cacheSize = size/1024/1024.0f;
        dispatch_async(dispatch_get_main_queue(), ^{
            longBarButton.subTitle.text = [NSString stringWithFormat:@"%.1fMB", cacheSize];
        });
    });
    
    [longBarButton setTarget:self action:@selector(clickClearButton)];
    [self.view addSubview:longBarButton];
    self.clearButton = longBarButton;
    
    height += MIDDLE_BAR_HEIGHT + 1.0f;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, 200, 25)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"仅Wi-Fi网络加载菜单图片";
    [view addSubview:label];
    
    UISwitch *bind = [[UISwitch alloc] init];
    bind.center = CGPointMake(320-PAGE_MARGIN-bind.bounds.size.width/2, MIDDLE_BAR_HEIGHT/2);
    bind.onTintColor = [IMConfig sharedConfig].bgColor;
    [view addSubview:bind];
    [bind setOn:[Networking sharedNetworking].isAutoWiFi animated:NO];
    [bind addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    [Networking sharedNetworking].isAutoWiFi = [switchButton isOn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickColorButton:(id)sender
{
    UIButton *button = sender;
    self.selectImageView.center = CGPointMake(button.frame.origin.x+button.frame.size.width,
                                              button.frame.origin.y+button.frame.size.height-8);
    [[IMConfig sharedConfig] setBgColorString:self.colorArray[button.tag-100]];
}

- (void)clickMoreButton
{
    SkinViewController *vc = [[SkinViewController alloc] initWithNibName:nil bundle:nil];
    [[self getIMNavigationController] pushViewController:vc animated:YES];
}

- (void)clickClearButton
{
    NSString *title = [NSString stringWithFormat:@"确认要清除%@缓存吗？", self.clearButton.subTitle.text];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"tip_button_cancel", nil)
                                         destructiveButtonTitle:@"确认清除"
                                              otherButtonTitles:nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        return;
    }
    
    [[SDImageCache sharedImageCache] clearDisk];
    self.clearButton.subTitle.text = @"0MB";
    [self showTips:NSLocalizedString(@"setting_view_success_tip1", nil)];
}

@end
