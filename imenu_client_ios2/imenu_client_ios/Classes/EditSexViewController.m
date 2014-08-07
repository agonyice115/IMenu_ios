//
//  EditSexViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-15.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "EditSexViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "UserData.h"

@interface EditSexViewController ()

@property (nonatomic, strong) UILabel *errorTips;

@property (nonatomic, strong) UIImageView *manSelect;
@property (nonatomic, strong) UIImageView *womanSelect;

@property (nonatomic, assign) BOOL isMan;

@end

@implementation EditSexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationBarView.title.text = NSLocalizedString(@"register_view_sex", nil);
        
        float height = TOP_BAR_HEIGHT;
        
        // 男
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, self.view.bounds.size.width-PAGE_MARGIN*2-20, 25)];
        label.text = NSLocalizedString(@"sex_man", nil);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [view addSubview:label];
        
        self.manSelect = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-PAGE_MARGIN-20, 13, 20, 20)];
        self.manSelect.image = [UIImage imageNamed:@"right.png"];
        [view addSubview:self.manSelect];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manTapped)];
        [view addGestureRecognizer:singleTap];
        
        [self.contentView addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 1;
        
        // 女
        view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, self.view.bounds.size.width-PAGE_MARGIN*2-20, 25)];
        label.text = NSLocalizedString(@"sex_woman", nil);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [view addSubview:label];
        
        self.womanSelect = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-PAGE_MARGIN-20, 13, 20, 20)];
        self.womanSelect.image = [UIImage imageNamed:@"right.png"];
        [view addSubview:self.womanSelect];
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(womanTapped)];
        [view addGestureRecognizer:singleTap];
        
        [self.contentView addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 10;
        // 添加错误提示
        self.errorTips = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, 200-PAGE_MARGIN, 20)];
        self.errorTips.backgroundColor = [UIColor clearColor];
        self.errorTips.text = @"";
        self.errorTips.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.errorTips.textColor = [UIColor colorWithHtmlColor:@"#ff0000"];
        [self.view addSubview:self.errorTips];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editMemberInfoOK:) name:@"editMemberInfoOK" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOldText:(NSString *)oldText
{
    self.isMan = [oldText isEqualToString:@"1"];
    if (self.isMan)
    {
        self.womanSelect.hidden = YES;
    }
    else
    {
        self.manSelect.hidden = YES;
    }
    
    _oldText = oldText;
}

- (void)manTapped
{
    if (!self.isMan)
    {
        self.manSelect.hidden = NO;
        self.womanSelect.hidden = YES;
        
        self.isMan = !self.isMan;
    }
}

- (void)womanTapped
{
    if (self.isMan)
    {
        self.manSelect.hidden = YES;
        self.womanSelect.hidden = NO;
        
        self.isMan = !self.isMan;
    }
}

- (void)didEditPersonalInfo
{
    if (self.isMan == [self.oldText isEqualToString:@"1"])
    {
        [super didEditPersonalInfo];
    }
    else
    {
        [self editSex];
    }
}

- (void)editSex
{
    if (self.isMan)
    {
        NSDictionary *dic = @{@"memberId":[UserData sharedUserData].memberId,
                              @"sex":@"1"};
        
        [[UserData sharedUserData] editUserInfo:dic];
    }
    else
    {
        NSDictionary *dic = @{@"memberId":[UserData sharedUserData].memberId,
                              @"sex":@"2"};
        
        [[UserData sharedUserData] editUserInfo:dic];
    }
}

- (void)editMemberInfoOK:(NSNotification *)notification
{
    NSDictionary *result = notification.userInfo;
    if (result)
    {
        NSString *errorString = result[@"error"];
        if ([errorString length] == 0)
        {
            [super didEditPersonalInfo];
        }
        else
        {
            if ([errorString hasPrefix:@"10|"] || [errorString hasPrefix:@"12|"])
            {
                self.errorTips.text = [errorString substringFromIndex:3];
            }
        }
    }
    else
    {
        self.errorTips.text = NSLocalizedString(@"networking_error", nil);
    }
}

@end
