//
//  EditBirthdayViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-15.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "EditBirthdayViewController.h"
#import "Common.h"
#import "UserData.h"
#import "UIColor+HtmlColor.h"

@interface EditBirthdayViewController ()

@property (nonatomic, strong) UILabel *textContent;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UILabel *errorTips;

@end

@implementation EditBirthdayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationBarView.title.text = NSLocalizedString(@"register_view_birthday", nil);
        
        float height = TOP_BAR_HEIGHT;
        
        // 添加输入
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.textContent = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, self.view.bounds.size.width-PAGE_MARGIN*2, 25)];
        self.textContent.textAlignment = NSTextAlignmentLeft;
        self.textContent.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.textContent.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [view addSubview:self.textContent];
        [self.contentView addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 10;
        // 添加错误提示
        self.errorTips = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, 200-PAGE_MARGIN, 20)];
        self.errorTips.backgroundColor = [UIColor clearColor];
        self.errorTips.text = @"";
        self.errorTips.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.errorTips.textColor = [UIColor colorWithHtmlColor:@"#ff0000"];
        [self.contentView addSubview:self.errorTips];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 216, 320, 216)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.date = [dateFormatter dateFromString:@"1985-01-01"];
        [self.datePicker addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.datePicker];
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
    if (oldText == nil)
    {
        oldText = @"1985-01-01";
    }
    self.textContent.text = oldText;
    _oldText = oldText;
}

- (void)onValueChanged:(id)datePicker
{
    NSLog(@"onValueChanged:%@", self.datePicker.date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.textContent.text = [dateFormatter stringFromDate:self.datePicker.date];
}

- (void)didEditPersonalInfo
{
    if ([self.oldText isEqualToString:self.textContent.text])
    {
        [super didEditPersonalInfo];
    }
    else
    {
        [self editBirthday];
    }
}

- (void)editBirthday
{
    NSDictionary *dic = @{@"memberId":[UserData sharedUserData].memberId,
                          @"birthday":self.textContent.text};
    
    [[UserData sharedUserData] editUserInfo:dic];
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
