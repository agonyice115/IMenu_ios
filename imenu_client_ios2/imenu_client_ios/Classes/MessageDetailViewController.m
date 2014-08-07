//
//  MessageDetailViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-13.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationTitle = @"我的消息";
        
        self.navigationBarType = IM_NAVIGATION_BAR_TYPE_TITLE;
        self.baseNavigationBarType = self.navigationBarType;
        self.kindNavigationBarType = IM_NAVIGATION_ITEM_SWITCH_DYNIMIC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, TOP_BAR_HEIGHT+20, 320-PAGE_MARGIN*2, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:FIRST_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#47acfc"];
    label.text = @"◎ 购买成功短信服务变更通知";
    [self.view addSubview:label];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(PAGE_MARGIN, TOP_BAR_HEIGHT+70, 320-PAGE_MARGIN*2, 90)];
    textView.text = @"购买成功短信服务变更通知，购买成功短信服务变更通知。\n购买成功短信服务变更通知，购买成功短信服务变更通知。";
    textView.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    textView.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    textView.editable = NO;
    [self.view addSubview:textView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, TOP_BAR_HEIGHT+190, 320-PAGE_MARGIN*2, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"2014-05-09 18:00";
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
