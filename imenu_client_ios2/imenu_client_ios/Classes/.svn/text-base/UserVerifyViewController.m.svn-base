//
//  UserVerifyViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-13.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "UserVerifyViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "IMBgView.h"
#import "RoundHeadView.h"
#import "OrderPayViewController.h"
#import "IMPopViewController.h"

@interface UserVerifyViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RoundHeadView *headView;

@end

@implementation UserVerifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    float x = 10.0f;
    float y = TOP_BAR_HEIGHT + 10;
    
    IMBgView *bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 100)];
    bgView.borderColor = [UIColor colorWithHtmlColor:@"#e9f6fe"];
    bgView.fillColor = [UIColor colorWithHtmlColor:@"#e9f6fe"];
    [self.scrollView addSubview:bgView];
    
    x += 20;
    y += 10;
    
    self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(x, y, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
    self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
    self.headView.roundSideWidth = 2.0f;
    [self.scrollView addSubview:self.headView];
    
    x += IMAGE_SIZE_TINY + 10;
    y += 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 220, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"雕刻时光咖啡店（交大店）";
    [self.scrollView addSubview:label];
    
    y += 20;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"人数：";
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+50, y, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
    label.text = @"3人";
    [self.scrollView addSubview:label];
    
    y += 20;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"合计：";
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+50, y, 80, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
    label.text = @"￥267.00";
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+130, y, 80, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
    label.text = @"￥377.00";
    label.clipsToBounds = YES;
    [self.scrollView addSubview:label];
    
    [label sizeToFit];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 100, 1)];
    line.backgroundColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
    [label addSubview:line];
    
    x = 10.0f;
    y += 50;
    
    bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 220, 40)];
    [self.scrollView addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_phone"];
    [self.scrollView addSubview:imageView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x+40, y+5, 170, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = @"请输入手机号码";
    textField.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    textField.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [self.scrollView addSubview:textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x+230, y, 70, 40);
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#d6edfd"];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [button setTitle:@"获取" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#2798f4"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [self.scrollView addSubview:button];
    
    y += 50;
    
    bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 40)];
    [self.scrollView addSubview:bgView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_user_verify"];
    [self.scrollView addSubview:imageView];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(x+40, y+5, 250, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = @"请输入短信验证码";
    textField.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    textField.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [self.scrollView addSubview:textField];
    
    y += 40;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_support"];
    [self.scrollView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+10, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#2798f4"];
    label.text = @"支持随时退款";
    [self.scrollView addSubview:label];
    
    x += 150;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_support"];
    [self.scrollView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+10, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#2798f4"];
    label.text = @"支持过期退款";
    [self.scrollView addSubview:label];
    
    x = 10.0f;
    y += 40;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 300, 40);
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#d35d53"];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithHtmlColor:@"#d35d53"].CGColor;
    [button setTitle:@"提交订单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [button addTarget:self action:@selector(onClickSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    y += 50;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 70, 40);
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#d6edfd"];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#2798f4"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [self.scrollView addSubview:button];
    
    x += 80;
    y += 20;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 160, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"您当前状态：未登录";
    [self.scrollView addSubview:label];
    
    y += 40;
    self.scrollView.contentSize = CGSizeMake(320, y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickSubmit
{
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    
    OrderPayViewController *viewController = [[OrderPayViewController alloc] initWithNibName:nil bundle:nil];
    [pVC setRootViewController:viewController withTitle:@"在线支付" animated:YES];
    
}

@end
