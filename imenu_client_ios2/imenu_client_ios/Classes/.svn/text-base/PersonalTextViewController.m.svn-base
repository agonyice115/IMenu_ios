//
//  PersonalTextViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-14.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "PersonalTextViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"

@interface PersonalTextViewController () <UITextFieldDelegate>

@end

@implementation PersonalTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        float height = TOP_BAR_HEIGHT;
        
        // 添加输入
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.textContent = [[UITextField alloc] initWithFrame:CGRectMake(PAGE_MARGIN, 10, self.view.bounds.size.width-PAGE_MARGIN*2, 25)];
        self.textContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textContent.textAlignment = NSTextAlignmentLeft;
        self.textContent.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.textContent.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.textContent.returnKeyType = UIReturnKeyDone;
        self.textContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textContent.delegate = self;
        [self.textContent becomeFirstResponder];
        [view addSubview:self.textContent];
        
        [self.contentView addSubview:view];
        
        height += MIDDLE_BAR_HEIGHT + 10;
        // 添加错误提示
        self.errorTips = [[UILabel alloc] initWithFrame:CGRectMake(PAGE_MARGIN, height, 320-PAGE_MARGIN*2, 20)];
        self.errorTips.backgroundColor = [UIColor clearColor];
        self.errorTips.text = @"";
        self.errorTips.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.errorTips.textColor = [UIColor colorWithHtmlColor:@"#ff0000"];
        [self.contentView addSubview:self.errorTips];
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

- (void)setOldText:(NSString *)oldText
{
    self.textContent.text = oldText;
    _oldText = oldText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textContent)
    {
        [self didEditPersonalInfo];
    }
    return NO;
}

@end
