//
//  IMWebViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-26.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMWebViewController.h"
#import "Common.h"

@interface IMWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation IMWebViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg@2x.png"]];
    
    CGRect frame = self.view.bounds;
    frame.origin.y += TOP_BAR_HEIGHT;
    frame.size.height -= TOP_BAR_HEIGHT;
    
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
